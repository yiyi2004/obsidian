domain

```go
type Article struct {  
    Id      int64  
    Title   string  
    Status  ArticleStatus  
    Content string  
    // 作者  
    Author Author  
    Ctime  time.Time  
    Utime  time.Time  
}  
  
// Abstract 取部分作为摘要  
func (a Article) Abstract() string {  
    cs := []rune(a.Content)  
    if len(cs) < 100 {  
       return a.Content  
    }  
    return string(cs[:100])  
}  
  
func (a Article) Published() bool {  
    return a.Status == ArticleStatusPublished  
}  
  
type ArticleStatus uint8  
  
//go:inline  
func (s ArticleStatus) ToUint8() uint8 {  
    return uint8(s)  
}  
  
const (  
    // ArticleStatusUnknown 未知状态  
    ArticleStatusUnknown ArticleStatus = iota  
    // ArticleStatusUnpublished 未发表  
    ArticleStatusUnpublished  
    // ArticleStatusPublished 已发表  
    ArticleStatusPublished  
    // ArticleStatusPrivate 仅自己可见  
    ArticleStatusPrivate  
)  
  
// Author 在帖子这个领域内，  
// 没有用户的概念，只有作者的概念  
type Author struct {  
    Id   int64  
    Name string  
}
```

1. 状态
	1. 未知状态
	2. 未发表状态
	3. 已发表状态
	4. 私有装填
2. 摘要

发送 Read Event

```go
const topicReadEvent = "article_read_event"  
  
type ReadEvent struct {  
    Aid int64  
    Uid int64  
}  
  
type Producer interface {  
    ProduceReadEvent(evt ReadEvent) error  
}  
  
type SaramaSyncProducer struct {  
    producer sarama.SyncProducer  
}  
  
func NewSaramaSyncProducer(producer sarama.SyncProducer) Producer {  
    return &SaramaSyncProducer{  
       producer: producer,  
    }  
}  
  
func (s *SaramaSyncProducer) ProduceReadEvent(evt ReadEvent) error {  
    val, err := json.Marshal(evt)  
    if err != nil {  
       return err  
    }  
    _, _, err = s.producer.  
       SendMessage(&sarama.ProducerMessage{  
          Topic: topicReadEvent,  
          Value: sarama.ByteEncoder(val),  
       })  
    return err  
}
```

- interactive 中的是 consumer

dao

cache

```go

type ArticleCache interface {  
    // GetFirstPage 只缓存第第一页的数据  
    // 并且不缓存整个 Content    GetFirstPage(ctx context.Context, author int64) ([]domain.Article, error)  
    SetFirstPage(ctx context.Context, author int64, arts []domain.Article) error  
    DelFirstPage(ctx context.Context, author int64) error  
  
    Set(ctx context.Context, art domain.Article) error  
    Get(ctx context.Context, id int64) (domain.Article, error)  
  
    // SetPub 正常来说，创作者和读者的 Redis 集群要分开，因为读者是一个核心中的核心  
    SetPub(ctx context.Context, article domain.Article) error  
    DelPub(ctx context.Context, id int64) error  
    GetPub(ctx context.Context, id int64) (domain.Article, error)  
}
```

- article_author
- article_reader
- entity
- gorm
- init
- mongo
- s3
- types

gorm

```go
func (dao *GORMArticleDAO) SyncStatus(ctx context.Context, author, id int64, status uint8) error {  
    return dao.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {  
       res := tx.Model(&Article{}).  
          Where("id=? AND author_id = ?", id, author).  
          Update("status", status)  
       if res.Error != nil {  
          return res.Error  
       }  
       if res.RowsAffected != 1 {  
          return ErrPossibleIncorrectAuthor  
       }  
  
       res = tx.Model(&PublishedArticle{}).  
          Where("id=? AND author_id = ?", id, author).Update("status", status)  
       if res.Error != nil {  
          return res.Error  
       }  
       if res.RowsAffected != 1 {  
          return ErrPossibleIncorrectAuthor  
       }  
       return nil  
    })  
}
```

- gorm 同步 status 两个库都要修改

bff

- article 中的内容
- 使用泛型统一处理请求，一个包里面单独定义 Req

```go
package web  
  
import (  
    articlev1 "gitee.com/geekbang/basic-go/webook/api/proto/gen/article/v1"  
)  
  
type RewardReq struct {  
    Id  int64 `json:"id"`  
    Amt int64 `json:"amt"`  
}  
  
type LikeReq struct {  
    Id   int64 `json:"id"`  
    Like bool  `json:"like"`  
}  
  
type CollectReq struct {  
    Id  int64 `json:"id"`  
    Cid int64 `json:"cid"`  
}  
  
type ArticleVo struct {  
    Id    int64  `json:"id"`  
    Title string `json:"title"`  
    // 摘要  
    Abstract string `json:"abstract"`  
    // 内容  
    Content string `json:"content"`  
    Status  int32  `json:"status"`  
    Author  string `json:"author"`  
    Ctime   string `json:"ctime"`  
    Utime   string `json:"utime"`  
  
    // 点赞之类的信息  
    LikeCnt    int64 `json:"likeCnt"`  
    CollectCnt int64 `json:"collectCnt"`  
    ReadCnt    int64 `json:"readCnt"`  
  
    // 个人是否点赞的信息  
    Liked     bool `json:"liked"`  
    Collected bool `json:"collected"`  
}  
  
type ArticleReq struct {  
    Id      int64  `json:"id"`  
    Title   string `json:"title"`  
    Content string `json:"content"`  
}  
  
func (req ArticleReq) toDTO(uid int64) *articlev1.Article {  
    return &articlev1.Article{  
       Id:      req.Id,  
       Title:   req.Title,  
       Content: req.Content,  
       Author: &articlev1.Author{  
          Id: uid,  
       },  
    }  
}
```

event

article event:

```go
const topicReadEvent = "article_read_event"  
  
type ReadEvent struct {  
    Aid int64  
    Uid int64  
}  
  
type Producer interface {  
    ProduceReadEvent(evt ReadEvent) error  
}  
  
type SaramaSyncProducer struct {  
    producer sarama.SyncProducer  
}  
  
func NewSaramaSyncProducer(producer sarama.SyncProducer) Producer {  
    return &SaramaSyncProducer{  
       producer: producer,  
    }  
}  
  
func (s *SaramaSyncProducer) ProduceReadEvent(evt ReadEvent) error {  
    val, err := json.Marshal(evt)  
    if err != nil {  
       return err  
    }  
    _, _, err = s.producer.  
       SendMessage(&sarama.ProducerMessage{  
          Topic: topicReadEvent,  
          Value: sarama.ByteEncoder(val),  
       })  
    return err  
}
```

mysql_binlog_event

```go
type MySQLBinlogConsumer struct {  
    client sarama.Client  
    l      logger.LoggerV1  
    repo   *repository.CachedArticleRepository  
}  
  
func (r *MySQLBinlogConsumer) Start() error {  
    cg, err := sarama.NewConsumerGroupFromClient("pub_articles_cache",  
       r.client)  
    if err != nil {  
       return err  
    }  
    go func() {  
       err := cg.Consume(context.Background(),  
          []string{"webook_binlog"},  
          saramax.NewHandler[canalx.Message[dao.PublishedArticle]](r.l, r.Consume))  
       if err != nil {  
          r.l.Error("退出了消费循环异常", logger.Error(err))  
       }  
    }()  
    return err  
}  
  
func (r *MySQLBinlogConsumer) Consume(msg *sarama.ConsumerMessage,  
    val canalx.Message[dao.PublishedArticle]) error {  
    // 因为共用了一个 topic，所以会有很多表的数据，不是自己的就不用管了  
    if val.Table != "published_articles" {  
       return nil  
    }  
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
    defer cancel()  
    for _, data := range val.Data {  
       var err error  
       switch data.Status {  
       case domain.ArticleStatusPublished.ToUint8():  
          err = r.repo.Cache().SetPub(ctx, r.repo.ToDomain(dao.Article(data)))  
       case domain.ArticleStatusPrivate.ToUint8():  
          err = r.repo.Cache().DelPub(ctx, data.Id)  
       }  
       if err != nil {  
          return err  
       }  
    }  
    return nil  
}
```

监控 binlog 的事件，如果 binlog 发生改变的时候，那接收到事件的时候，就自动更新缓存.

- 如果发布，就会更新

## Canal 的几个配置

1. 配置文件
2. docker compose
3. start 消费 binlog 事件
