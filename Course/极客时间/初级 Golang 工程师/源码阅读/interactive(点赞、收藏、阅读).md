- article 和 interactive 的业务逻辑好难啊
- 同步的数据

## Event

### Article 文章读事件

```go
const topicReadEvent = "article_read_event"  
  
type ReadEvent struct {  
    Aid int64  
    Uid int64  
}  
  
var _ saramax.Consumer = &InteractiveReadEventConsumer{}  
  
type InteractiveReadEventConsumer struct {  
    client sarama.Client  
    repo   repository.InteractiveRepository  
    l      logger.LoggerV1  
}  
  
func NewInteractiveReadEventConsumer(  
    client sarama.Client,  
    l logger.LoggerV1,  
    repo repository.InteractiveRepository) *InteractiveReadEventConsumer {  
    ic := &InteractiveReadEventConsumer{  
       repo:   repo,  
       client: client,  
       l:      l,  
    }  
    return ic  
}  
  
// Start 这边就是自己启动 goroutine 了  
func (r *InteractiveReadEventConsumer) Start() error {  
    cg, err := sarama.NewConsumerGroupFromClient("interactive",  
       r.client)  
    if err != nil {  
       return err  
    }  
    go func() {  
       err := cg.Consume(context.Background(),  
          []string{topicReadEvent},  
          saramax.NewHandler[ReadEvent](r.l, r.Consume))  
       if err != nil {  
          r.l.Error("退出了消费循环异常", logger.Error(err))  
       }  
    }()  
    return err  
}  
  
func (r *InteractiveReadEventConsumer) StartBatch() error {  
    cg, err := sarama.NewConsumerGroupFromClient("interactive",  
       r.client)  
    if err != nil {  
       return err  
    }  
    go func() {  
       err := cg.Consume(context.Background(),  
          []string{topicReadEvent},  
          saramax.NewBatchHandler[ReadEvent](r.l, r.BatchConsume))  
       if err != nil {  
          r.l.Error("退出了消费循环异常", logger.Error(err))  
       }  
    }()  
    return err  
}  
  
func (r *InteractiveReadEventConsumer) Consume(msg *sarama.ConsumerMessage,  
    evt ReadEvent) error {  
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
    defer cancel()  
    err := r.repo.IncrReadCnt(ctx, "article", evt.Aid)  
    return err  
}  
  
func (r *InteractiveReadEventConsumer) BatchConsume(msgs []*sarama.ConsumerMessage,  
    evts []ReadEvent) error {  
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
    defer cancel()  
    bizs := make([]string, 0, len(msgs))  
    ids := make([]int64, 0, len(msgs))  
    for _, evt := range evts {  
       bizs = append(bizs, "article")  
       ids = append(ids, evt.Uid)  
    }  
    return r.repo.BatchIncrReadCnt(ctx, bizs, ids)  
}
```

Apache Kafka 的批处理策略是指生产者（Producers）和消费者（Consumers）在处理消息时，采取的将多个消息作为一个批次进行发送或接收的策略。这种策略对于提高 Kafka 系统的整体性能和效率非常关键。以下是 Kafka 批处理策略的主要好处：

#### 1. 提高吞吐量

通过将多个消息打包成一个批次发送，可以减少网络请求的次数，从而显著提高系统的吞吐量。对于消费者而言，一次性处理多个消息也能更高效地利用系统资源。

#### 2. 减少网络开销

网络通信是分布式系统中的一个重要瓶颈。批处理通过减少网络请求的次数，有效地降低了网络传输开销，特别是在高延迟的网络环境中，这种减少更为明显。

#### 3. 优化磁盘使用

Kafka 利用磁盘顺序写入的特性来优化性能。通过批处理，Kafka 能将多个消息一次性写入到磁盘中，这比频繁的小量写入操作更高效，因为它减少了磁盘寻址和文件系统元数据更新的开销。

#### 4. 提高资源利用率

批处理允许生产者和消费者更有效地使用 CPU 和内存资源。对于生产者而言，一次生成并发送多个消息可以减少消息构建和发送的开销；对于消费者而言，批量处理消息可以减少消息解析和处理的总开销。

#### 5. 减少延迟

虽然在某些场景下，批处理可能会引入额外的延迟（因为需要等待足够的消息积累成一个批次），但在高吞吐量场景下，通过合理配置批次大小和等待时间，可以实现在保持低延迟的同时大幅提高性能。

#### 6. 灵活的配置

Kafka 提供了多种与批处理相关的配置选项，允许开发者根据具体需求调整批次大小、批处理时间等参数，以达到最佳的性能和延迟平衡。

#### 结论

Kafka 的批处理策略提供了一种有效的方法来提高数据处理的性能和效率。通过合理配置，开发者可以在保证数据处理能力的同时，优化资源使用，降低系统开销。然而，为了充分利用批处理的优势，需要仔细考虑批次的大小和处理时间，避免过大的批次导致的内存压力和处理延迟。

- 批处理策略
- 减少网络请求次数，提高吞吐量
- Kafka 的批处理策略提供了一种有效的方法来提高数据处理的性能和效率。通过合理配置，开发者可以在保证数据处理能力的同时，优化资源使用，降低系统开销。然而，为了充分利用批处理的优势，需要仔细考虑批次的大小和处理时间，避免过大的批次导致的内存压力和处理延迟。

### Consumer

- 目前还没有用上

## Repository

### Cache

```go
local key = KEYS[1]  
local cntKey = ARGV[1]  
local delta = tonumber(ARGV[2])  
local exists = redis.call("EXISTS", key)  
if exists == 1 then  
    redis.call("HINCRBY", key, cntKey, delta)  
    -- 说明自增成功了  
    return 1  
else  
    return 0  
end
```

- 判断 key 是否存在，然后再进行操作，典型的先查找数据，然后操作数据，存在并发问题。然后使用 lua 脚本解决这个问题。

### Dao

- 双写模式
- 考虑冲突问题，如果 id 已经存在，那么更新，否则创建一个新的 Read Event

都是比较简单的操作

## Sservice
