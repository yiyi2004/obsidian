## Domain

```go
type FeedEvent struct {
	ID int64
	// 以 A 发表了一篇文章为例
	// 如果是 Pull Event，也就是拉模型，那么 Uid 是 A 的id
	// 如果是 Push Event，也就是推模型，那么 Uid 是 A 的某个粉丝的 id
	Uid   int64
	Type  string
	Ctime time.Time
	Ext   ExtendFields
}
```

extend_fields

```go
type ExtendFields map[string]string

var errKeyNotFound = errors.New("没有找到对应的 key")

func (f ExtendFields) Get(key string) ekit.AnyValue {
	val, ok := f[key]
	if !ok {
		return ekit.AnyValue{
			Err: fmt.Errorf("%w, key %s", errKeyNotFound),
		}
	}
	return ekit.AnyValue{Val: val}
}
```

## Event

```go
const topicArticleEvent = "article_feed_event"  
  
// ArticleFeedEvent 由业务方定义，本服务做适配  
type ArticleFeedEvent struct {  
    uid int64  
    aid int64  
}  
  
type ArticleEventConsumer struct {  
    client sarama.Client  
    l      logger.LoggerV1  
    svc    service.FeedService  
}  
  
func NewArticleEventConsumer(  
    client sarama.Client,  
    l logger.LoggerV1,  
    svc service.FeedService) *ArticleEventConsumer {  
    ac := &ArticleEventConsumer{  
       svc:    svc,  
       client: client,  
       l:      l,  
    }  
    return ac  
}  
  
// Start 这边就是自己启动 goroutine 了  
func (r *ArticleEventConsumer) Start() error {  
    cg, err := sarama.NewConsumerGroupFromClient("articleFeed",  
       r.client)  
    if err != nil {  
       return err  
    }  
    go func() {  
       err := cg.Consume(context.Background(),  
          []string{topicArticleEvent},  
          saramax.NewHandler[ArticleFeedEvent](r.l, r.Consume))  
       if err != nil {  
          r.l.Error("退出了消费循环异常", logger.Error(err))  
       }  
    }()  
    return err  
}  
  
func (r *ArticleEventConsumer) Consume(msg *sarama.ConsumerMessage,  
    evt ArticleFeedEvent) error {  
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
    defer cancel()  
    return r.svc.CreateFeedEvent(ctx, domain.FeedEvent{  
       Type: service.FollowEventName,  
       Ext: map[string]string{  
          "uid": strconv.FormatInt(evt.uid, 10),  
          "aid": strconv.FormatInt(evt.uid, 10),  
       },  
    })  
  
}
```

## Repository

### Cache

```go
var FolloweesNotFound = redis.Nil

type FeedEventCache interface {
	SetFollowees(ctx context.Context, follower int64, followees []int64) error
	GetFollowees(ctx context.Context, follower int64) ([]int64, error)
}

type feedEventCache struct {
	client redis.Cmdable
}

func NewFeedEventCache(client redis.Cmdable) FeedEventCache {
	return &feedEventCache{
		client: client,
	}
}
```

### Dao

### Total
