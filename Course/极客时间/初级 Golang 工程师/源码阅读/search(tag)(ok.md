## Domain

### Article

```go
type Article struct {
	Id      int64
	Title   string
	Status  int32
	Content string
	Tags    []string
}
```

### search_result

```go
type SearchResult struct {  
    Users    []User  
    Articles []Article  
}
```

### User

```go
type User struct {
	Id       int64
	Email    string
	Nickname string
	Phone    string
}
```

## Repository

### Dao

```go
const ArticleIndexName = "article_index"
const TagIndexName = "tags_index"

type Article struct {
	Id      int64    `json:"id"`
	Title   string   `json:"title"`
	Status  int32    `json:"status"`
	Content string   `json:"content"`
	Tags    []string `json:"tags"`
}

type ArticleElasticDAO struct {
	client *elastic.Client
}

func NewArticleElasticDAO(client *elastic.Client) ArticleDAO {
	return &ArticleElasticDAO{client: client}
}

func (h *ArticleElasticDAO) Search(ctx context.Context, tagArtIds []int64, keywords []string) ([]Article, error) {
	queryString := strings.Join(keywords, " ")
	ids := slice.Map(tagArtIds, func(idx int, src int64) any {
		return src
	})
	query := elastic.NewBoolQuery().Must(
		elastic.NewBoolQuery().Should(
			// 给予更高权重
			elastic.NewTermsQuery("id", ids...).Boost(2),
			elastic.NewMatchQuery("title", queryString),
			elastic.NewMatchQuery("content", queryString)),
		elastic.NewTermQuery("status", 2))
	resp, err := h.client.Search(ArticleIndexName).Query(query).Do(ctx)
	if err != nil {
		return nil, err
	}
	res := make([]Article, 0, len(resp.Hits.Hits))
	for _, hit := range resp.Hits.Hits {
		var ele Article
		err = json.Unmarshal(hit.Source, &ele)
		res = append(res, ele)
	}
	return res, nil
}

func (h *ArticleElasticDAO) InputArticle(ctx context.Context, art Article) error {
	_, err := h.client.Index().
		Index(ArticleIndexName).
		Id(strconv.FormatInt(art.Id, 10)).
		BodyJson(art).Do(ctx)
	return err
}
```

1. 查询，id 精确查询
2. 查询标题中的符合关键词，查询内容中符合的关键词
3. resp.Hits.Hits 然后 unmarshall 文章到结构体中

init_index

```go
// 创建 userIndex、articleIndex、tagIndex
var (  
    //go:embed user_index.json  
    userIndex string  
    //go:embed article_index.json  
    articleIndex string  
    //go:embed tags_index.json  
    tagIndex string  
)  
  
// InitES 创建索引  
func InitES(client *elastic.Client) error {  
    const timeout = time.Second * 10  
    ctx, cancel := context.WithTimeout(context.Background(), timeout)  
    defer cancel()  
    var eg errgroup.Group  
    eg.Go(func() error {  
       return tryCreateIndex(ctx, client, UserIndexName, userIndex)  
    })  
    eg.Go(func() error {  
       return tryCreateIndex(ctx, client, ArticleIndexName, articleIndex)  
    })  
    eg.Go(func() error { return tryCreateIndex(ctx, client, TagIndexName, tagIndex) })  
  
    return eg.Wait()  
}  
  
func tryCreateIndex(ctx context.Context,  
    client *elastic.Client,  
    idxName, idxCfg string,  
) error {  
    ok, err := client.IndexExists(idxName).Do(ctx)  
    if err != nil {  
       return fmt.Errorf("检测 %s 是否存在失败 %w", idxName, err)  
    }  
    if ok {  
       return nil  
    }  
    _, err = client.CreateIndex(idxName).  
       Body(idxCfg).Do(ctx)  
    if err != nil {  
       return fmt.Errorf("初始化 %s 失败 %w", idxName, err)  
    }  
    return err  
}
```

tag_dao

```go
func (t *TagESDAO) Search(ctx context.Context, uid int64, biz string, keywords []string) ([]int64, error) {
	query := elastic.NewBoolQuery().Must(
		elastic.NewTermsQuery("uid", uid),
		elastic.NewTermsQueryFromStrings("tags", keywords...),
		elastic.NewTermQuery("biz", biz))
	resp, err := t.client.Search(TagIndexName).Query(query).Do(ctx)
	if err != nil {
		return nil, err
	}
	res := make([]int64, 0, len(resp.Hits.Hits))
	for _, hit := range resp.Hits.Hits {
		var ele BizTags
		err = json.Unmarshal(hit.Source, &ele)
		if err != nil {
			return nil, err
		}
		res = append(res, ele.BizId)
	}
	return res, nil
}

type BizTags struct {
	Uid   int64    `json:"uid"`
	Biz   string   `json:"biz"`
	BizId int64    `json:"biz_id"`
	Tags  []string `json:"tags"`
}
```

user_dao

```go
func (h *UserElasticDAO) Search(ctx context.Context, keywords []string) ([]User, error) {
	// 假定上面传入的 keywords 是经过了处理的
	queryString := strings.Join(keywords, " ")
	query := elastic.NewBoolQuery().Must(elastic.NewMatchQuery("nickname", queryString))
	resp, err := h.client.Search(UserIndexName).Query(query).Do(ctx)
	if err != nil {
		return nil, err
	}
	res := make([]User, 0, len(resp.Hits.Hits))
	for _, hit := range resp.Hits.Hits {
		var ele User
		err = json.Unmarshal(hit.Source, &ele)
		if err != nil {
			return nil, err
		}
		res = append(res, ele)
	}
	return res, nil
}
```

### Total

## Service

```go
type SearchService interface {
	Search(ctx context.Context, uid int64, expression string) (domain.SearchResult, error)
}

type searchService struct {
	userRepo    repository.UserRepository
	articleRepo repository.ArticleRepository
}

func NewSearchService(userRepo repository.UserRepository, articleRepo repository.ArticleRepository) SearchService {
	return &searchService{userRepo: userRepo, articleRepo: articleRepo}
}

func (s *searchService) Search(ctx context.Context, uid int64, expression string) (domain.SearchResult, error) {
	// 这边一般要对 expression 进行一些预处理
	// 正常大家都是使用的空格符来分割的，但是有些时候可能会手抖，输错
	keywords := strings.Split(expression, " ")
	// 注意这里我们没有使用 multi query 或者 multi match 之类的写法
	// 是因为正常来说，不同的业务放过来的数据，什么支持搜索，什么不支持搜索，
	// 以及究竟怎么用于搜索，都是有区别的。所以这里我们利用两个 repo 来组合结果
	var eg errgroup.Group
	var res domain.SearchResult
	eg.Go(func() error {
		users, err := s.userRepo.SearchUser(ctx, keywords)
		res.Users = users
		return err
	})
	eg.Go(func() error {
		arts, err := s.articleRepo.SearchArticle(ctx, uid, keywords)
		res.Articles = arts
		return err
	})
	return res, eg.Wait()
}
```

1. 组合结构
2. 正常的搜索顺序，搜索 User 和文章，前端可以进行排序
3. 根据 UserId 查询某一个 User 的文章 —— 很常见的需求
4. 聚合最终结果

同步接口

```go
type SyncService interface {
	InputArticle(ctx context.Context, article domain.Article) error
	InputUser(ctx context.Context, user domain.User) error
	InputAny(ctx context.Context, index, docID, data string) error
}

type syncService struct {
	userRepo    repository.UserRepository
	articleRepo repository.ArticleRepository
	anyRepo     repository.AnyRepository
}

func (s *syncService) InputAny(ctx context.Context, index, docID, data string) error {
	return s.anyRepo.Input(ctx, index, docID, data)
}

func (s *syncService) InputArticle(ctx context.Context, article domain.Article) error {
	return s.articleRepo.InputArticle(ctx, article)
}

func (s *syncService) InputUser(ctx context.Context, user domain.User) error {
	return s.userRepo.InputUser(ctx, user)
}

func NewSyncService(
	anyRepo repository.AnyRepository,
	userRepo repository.UserRepository,
	articleRepo repository.ArticleRepository) SyncService {
	return &syncService{
		userRepo:    userRepo,
		articleRepo: articleRepo,
		anyRepo:     anyRepo,
	}
}
```

## Event

- 利用 sync 接口同步数据到 ES 中。
- 定义任意类型接口
