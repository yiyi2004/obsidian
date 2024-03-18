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

- article_author
- article_reader
- entity
- gorm
- init
- mongo
- s3
- types

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
