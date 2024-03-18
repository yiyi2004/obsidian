tag 和 search 是一个系列的。ES 相关的内容。

## Domain

```go
type Tag struct {
	Id   int64
	Name string
	Uid  int64
}
```

## Events

search.go

```go
type SyncDataEvent struct {  
    IndexName string  
    DocID     string  
    Data      string  
}  
  
type SyncDataEventConsumer struct {  
    svc    service.SyncService  
    client sarama.Client  
    l      logger.LoggerV1  
}
```

producer.go

```go
type Producer interface {
	ProduceSyncEvent(ctx context.Context, data BizTags) error
}

type SaramaSyncProducer struct {
	client sarama.SyncProducer
}

func (p *SaramaSyncProducer) ProduceSyncEvent(ctx context.Context, tags BizTags) error {
	data, _ := json.Marshal(tags)
	evt := SyncDataEvent{
		IndexName: "tags_index",
		DocID:     fmt.Sprintf("%d_%s_%d", tags.Uid, tags.Biz, tags.BizId),
		Data:      string(data),
	}
	data, _ = json.Marshal(evt)
	_, _, err := p.client.SendMessage(&sarama.ProducerMessage{
		Topic: "search_sync_data",
		Value: sarama.ByteEncoder(data),
	})
	return err
}

type BizTags struct {
	Uid   int64    `json:"uid"`
	Biz   string   `json:"biz"`
	BizId int64    `json:"biz_id"`
	Tags  []string `json:"tags"`
}
```

## Repository

### Cache

```go
var ErrKeyNotExist = redis.Nil

type TagCache interface {
	GetTags(ctx context.Context, uid int64) ([]domain.Tag, error)
	Append(ctx context.Context, uid int64, tags ...domain.Tag) error
	DelTags(ctx context.Context, uid int64) error
}

type RedisTagCache struct {
	client     redis.Cmdable
	expiration time.Duration
}

func (r *RedisTagCache) DelTags(ctx context.Context, uid int64) error {
	return r.client.Del(ctx, r.userTagsKey(uid)).Err()
}

func (r *RedisTagCache) Append(ctx context.Context, uid int64, tags ...domain.Tag) error {
	data := make([]any, 0, len(tags))
	for _, tag := range tags {
		val, err := json.Marshal(tag)
		if err != nil {
			return err
		}
		data = append(data, val)
	}
	key := r.userTagsKey(uid)
	// 利用 pipeline 来执行，性能好一点
	pip := r.client.Pipeline()
	pip.RPush(ctx, key, data)
	pip.Expire(ctx, key, r.expiration)
	_, err := pip.Exec(ctx)
	return err
}

func (r *RedisTagCache) GetTags(ctx context.Context, uid int64) ([]domain.Tag, error) {
	key := r.userTagsKey(uid)
	data, err := r.client.LRange(ctx, key, 0, -1).Result()
	if err != nil {
		return nil, err
	}
	res := make([]domain.Tag, 0, len(data))
	for _, ele := range data {
		var t domain.Tag
		err = json.Unmarshal([]byte(ele), &t)
		if err != nil {
			return nil, err
		}
		res = append(res, t)
	}
	return res, nil
}

func (r *RedisTagCache) userTagsKey(uid int64) string {
	return fmt.Sprintf("tag:user_tags:%d", uid)
}

func NewRedisTagCache(client redis.Cmdable) TagCache {
	return &RedisTagCache{
		client: client,
	}
}
```

### Dao

```go
type Tag struct {
	Id    int64  `gorm:"primaryKey,autoIncrement"`
	Name  string `gorm:"type=varchar(4096)"`
	Uid   int64  `gorm:"index"`
	Ctime int64
	Utime int64
}

type TagBiz struct {
	Id    int64  `gorm:"primaryKey,autoIncrement"`
	BizId int64  `gorm:"index:biz_type_id"`
	Biz   string `gorm:"index:biz_type_id"`
	// 冗余字段，加快查询和删除
	Uid   int64 `gorm:"index"`
	Tid   int64
	Tag   *Tag  `gorm:"ForeignKey:Tid;AssociationForeignKey:Id;constraint:OnDelete:CASCADE"`
	Ctime int64 `bson:"ctime,omitempty"`
	Utime int64 `bson:"utime,omitempty"`
}

type TagDAO interface {
	CreateTag(ctx context.Context, tag Tag) (int64, error)
	CreateTagBiz(ctx context.Context, tagBiz []TagBiz) error
	GetTagsByUid(ctx context.Context, uid int64) ([]Tag, error)
	GetTagsByBiz(ctx context.Context, uid int64, biz string, bizId int64) ([]Tag, error)
	GetTags(ctx context.Context, offset, limit int) ([]Tag, error)
	GetTagsById(ctx context.Context, ids []int64) ([]Tag, error)
}
```
