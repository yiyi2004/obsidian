对 Article 进行排序，根据 xxx 计算的方法。只操作缓存，因为变化很大的。

降级策略使用本地缓存

1. 先从本地缓存中查，如果没有，查 Redis 缓存
2. 先替换本地缓存中的内容，然后再替换 Redis 中的

## Repository

```go
type RankingRepository interface {
	ReplaceTopN(ctx context.Context, arts []domain.Article) error
	GetTopN(ctx context.Context) ([]domain.Article, error)
}

type CachedRankingRepository struct {
	redisCache *cache.RedisRankingCache
	localCache *cache.RankingLocalCache
	// 你也可以考虑将这个本地缓存塞进去 RankingCache 里面，作为一个实现
	topN atomicx.Value[[]domain.Article]
}

func NewCachedRankingRepository(
	redisCache *cache.RedisRankingCache,
	localCache *cache.RankingLocalCache) RankingRepository {
	return &CachedRankingRepository{
		redisCache: redisCache,
		localCache: localCache,
	}
}

func (c *CachedRankingRepository) ReplaceTopN(ctx context.Context,
	arts []domain.Article) error {
	// 这一步必然不会出错
	_ = c.localCache.Set(ctx, arts)
	return c.redisCache.Set(ctx, arts)
}

func (c *CachedRankingRepository) GetTopN(ctx context.Context) ([]domain.Article, error) {
	arts, err := c.localCache.Get(ctx)
	if err == nil {
		return arts, nil
	}
	// 回写本地缓存
	arts, err = c.redisCache.Get(ctx)
	if err == nil {
		_ = c.localCache.Set(ctx, arts)
	} else {
		// 这里，我们没有进一步区分是什么原因导致的 Redis 错误
		return c.localCache.ForceGet(ctx)
	}
	return arts, err
}
```

### Cache

本地缓存

```go
// RankingLocalCache 因为本身数据只有一份，所以不需要借助真正的本地缓存
type RankingLocalCache struct {
	topN       *atomicx.Value[[]domain.Article]
	ddl        *atomicx.Value[time.Time]
	expiration time.Duration
}

func NewRankingLocalCache() *RankingLocalCache {
	return &RankingLocalCache{
		topN:       atomicx.NewValue[[]domain.Article](),
		ddl:        atomicx.NewValueOf[time.Time](time.Now()),
		expiration: time.Minute * 3,
	}
}

func (r *RankingLocalCache) Set(_ context.Context, arts []domain.Article) error {
	r.ddl.Store(time.Now().Add(time.Minute * 3))
	r.topN.Store(arts)
	return nil
}

func (r *RankingLocalCache) Get(_ context.Context) ([]domain.Article, error) {
	arts := r.topN.Load()
	if len(arts) == 0 || r.ddl.Load().Before(time.Now()) {
		return nil, errors.New("本地缓存失效了")
	}
	return arts, nil
}

func (r *RankingLocalCache) ForceGet(_ context.Context) ([]domain.Article, error) {
	return r.topN.Load(), nil
}
```

Redis

```go
type RankingCache interface {
	Set(ctx context.Context, arts []domain.Article) error
	Get(ctx context.Context) ([]domain.Article, error)
}

type RedisRankingCache struct {
	client     redis.Cmdable
	key        string
	expiration time.Duration
}

func (r *RedisRankingCache) Set(ctx context.Context, arts []domain.Article) error {
	// 这里我们不会缓存内容
	for i := 0; i < len(arts); i++ {
		arts[i].Content = arts[i].Abstract()
	}
	val, err := json.Marshal(arts)
	if err != nil {
		return err
	}
	// 过期时间要设置得比定时计算的间隔长
	return r.client.Set(ctx, r.key, val,
		r.expiration).Err()
}

func (r *RedisRankingCache) Get(ctx context.Context) ([]domain.Article, error) {
	val, err := r.client.Get(ctx, r.key).Bytes()
	if err != nil {
		return nil, err
	}
	var res []domain.Article
	err = json.Unmarshal(val, &res)
	return nil, err
}

func NewRedisRankingCache(client redis.Cmdable) *RedisRankingCache {
	return &RedisRankingCache{
		key:        "ranking:article",
		client:     client,
		expiration: time.Minute * 3,
	}
}
```

## Service

在 Service 层计算 topN 个文章

```go
	// 优先级队列
	"github.com/ecodeclub/ekit/queue"
	// slice 相关操作
	"github.com/ecodeclub/ekit/slice"
	"google.golang.org/protobuf/types/known/timestamppb"
```

```go
func (a *BatchRankingService) rankTopN(ctx context.Context) ([]domain.Article, error){
	now := time.Now()
	// 只计算七天内的，因为超过七天的我们可以认为绝对不可能成为热榜了
	// 如果一个批次里面 utime 最小已经是七天之前的，我们就中断当前计算
	ddl := now.Add(-time.Hour * 24 * 7)
	offset := 0
	type Score struct {
		art   domain.Article
		score float64
	}
	// 这是一个优先级队列，维持住了 topN 的 id。
	que := queue.NewPriorityQueue[Score](a.N,
		func(src Score, dst Score) int {
			if src.score > dst.score {
				return 1
			} else if src.score == dst.score {
				return 0
			} else {
				return -1
			}
		})

	for {
		// offset 不断向前
		arts, err := a.artSvc.ListPub(ctx, &articlev1.ListPubRequest{
			StartTime: timestamppb.New(now),
			Offset:    int32(offset),
			Limit:     int32(a.BatchSize),
		})
		if err != nil {
			return nil, err
		}
		// 转化成 domain Article
		domainArts := make([]domain.Article, 0, len(arts.Articles))
		for _, art := range arts.Articles {
			domainArts = append(domainArts, articleToDomain(art))
		}

		artIds := slice.Map[domain.Article, int64](domainArts, func(idx int, src domain.Article) int64 {
			return src.Id
		})
		intrResp, err := a.intrSvc.GetByIds(ctx, &intrv1.GetByIdsRequest{
			Biz: "article", Ids: artIds,
		})
		if err != nil {
			return nil, err
		}
		minScore := float64(0)
		for _, art := range domainArts {
			intr, ok := intrResp.GetIntrs()[art.Id]
			if !ok {
				continue
			}
			score := a.scoreFunc(intr.LikeCnt, art.Utime)
			if score > minScore {
				ele := Score{art: art, score: score}
				err = que.Enqueue(ele)
				if err == queue.ErrOutOfCapacity {
					_, _ = que.Dequeue()
					err = que.Enqueue(ele)
				}
			} else {
				minScore = score
			}
		}
		// 退出循环推荐
		if len(domainArts) == 0 || len(domainArts) < a.BatchSize ||
			domainArts[len(domainArts)-1].Utime.Before(ddl) {
			break
		}
		offset = offset + len(domainArts)
	}
	ql := que.Len()
	res := make([]domain.Article, ql)
	for i := ql - 1; i >= 0; i-- {
		val, _ := que.Dequeue()
		res[i] = val.art
	}
	return res, nil
}

// 这里不需要提前抽象算法，因为正常一家公司的算法都是固定的，不会今天切换到这里，明天切换到那里
func (a *BatchRankingService) score(likeCnt int64, utime time.Time) float64 {
	// 这个 factor 也可以做成一个参数
	const factor = 1.5
	return float64(likeCnt-1) /
		math.Pow(time.Since(utime).Hours()+2, factor)
}

func (a *BatchRankingService) TopN(ctx context.Context) ([]domain.Article, error) {
	return a.repo.GetTopN(ctx)
}

func articleToDomain(article *articlev1.Article) domain.Article {
	domainArticle := domain.Article{}
	if article != nil {
		domainArticle.Id = article.GetId()
		domainArticle.Title = article.GetTitle()
		domainArticle.Status = domain.ArticleStatus(article.Status)
		domainArticle.Content = article.Content
		domainArticle.Author = domain.Author{
			Id:   article.GetAuthor().GetId(),
			Name: article.GetAuthor().GetName(),
		}
		domainArticle.Ctime = article.Ctime.AsTime()
		domainArticle.Utime = article.Utime.AsTime()
	}
	return domainArticle
}
```

score 计算公式

```go
	const factor = 1.5
	return float64(likeCnt-1) /
		math.Pow(time.Since(utime).Hours()+2, factor)
```

```go

(likeCnt - 1) / (now - update_time)^factor
```

factor = 1.5
