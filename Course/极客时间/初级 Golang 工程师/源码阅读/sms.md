domain

async.go

```go
type AsyncSms struct {  
    Id      int64  
    TplId   string  
    Args    []string  
    Numbers []string  
    // 重试的配置  
    RetryMax int  
}
```

repository

```go
type AsyncSmsRepository interface {  
    // Add 添加一个异步 SMS 记录。  
    // 你叫做 Create 或者 Insert 也可以  
    Add(ctx context.Context, s domain.AsyncSms) error  
    PreemptWaitingSMS(ctx context.Context) (domain.AsyncSms, error)  
    ReportScheduleResult(ctx context.Context, id int64, success bool) error  
}
```

dao

设置重试时间和限制时间

- select for update
- 设置 1 分钟之内的发送失败的，需要重发。
- update 重试次数
- mark success
- mark failed

```go
func (g *GORMAsyncSmsDAO) GetWaitingSMS(ctx context.Context) (AsyncSms, error) {  
    // 如果在高并发情况下,SELECT for UPDATE 对数据库的压力很大  
    // 但是我们不是高并发，因为你部署N台机器，才有 N 个goroutine 来查询  
    // 并发不过百，随便写  
    var s AsyncSms  
    err := g.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {  
       // 为了避开一些偶发性的失败，我们只找 1 分钟前的异步短信发送  
       now := time.Now().UnixMilli()  
       endTime := now - time.Minute.Milliseconds()  
       err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).  
          Where("utime < ? and status = ?",  
             endTime, asyncStatusWaiting).First(&s).Error  
       // SELECT xx FROM xxx WHERE xx FOR UPDATE，锁住了  
       if err != nil {  
          return err  
       }  
  
       // 只要更新了更新时间，根据我们前面的规则，就不可能被别的节点抢占了  
       err = tx.Model(&AsyncSms{}).  
          Where("id = ?", s.Id).  
          Updates(map[string]any{  
             "retry_cnt": gorm.Expr("retry_cnt + 1"),  
             // 更新成了当前时间戳，确保我在发送过程中，没人会再次抢到它  
             // 也相当于，重试间隔一分钟  
             "utime": now,  
          }).Error  
       return err  
    })  
    return s, err  
}
```

简历还需要再优化一下

repository service

```go
type AsyncSmsRepository interface {  
    // Add 添加一个异步 SMS 记录。  
    // 你叫做 Create 或者 Insert 也可以  
    Add(ctx context.Context, s domain.AsyncSms) error  
    PreemptWaitingSMS(ctx context.Context) (domain.AsyncSms, error)  
    ReportScheduleResult(ctx context.Context, id int64, success bool) error  
}
```

腾讯短信服务

```go
type Service struct {  
    client   *sms.Client  
    appId    *string  
    signName *string  
}  
  
func NewService(c *sms.Client, appId string,  
    signName string) *Service {  
    return &Service{  
       client:   c,  
       appId:    ekit.ToPtr[string](appId),  
       signName: ekit.ToPtr[string](signName),  
    }  
}  
  
func (s *Service) Send(ctx context.Context, tplId string,  
    args []string, numbers ...string) error {  
    req := sms.NewSendSmsRequest()  
    req.PhoneNumberSet = toStringPtrSlice(numbers)  
    req.SmsSdkAppId = s.appId  
    // ctx 继续往下传  
    req.SetContext(ctx)  
    req.TemplateParamSet = toStringPtrSlice(args)  
    req.TemplateId = ekit.ToPtr[string](tplId)  
    req.SignName = s.signName  
    resp, err := s.client.SendSms(req)  
    zap.L().Debug("调用腾讯短信服务",  
       zap.Any("req", req),  
       zap.Any("resp", resp))  
    if err != nil {  
       return err  
    }  
    for _, status := range resp.Response.SendStatusSet {  
       if status.Code == nil || *(status.Code) != "Ok" {  
          return fmt.Errorf("发送失败，code: %s, 原因：%s",  
             *status.Code, *status.Message)  
       }  
    }  
    return nil  
}
```

```go
return tencent.NewService(c, "1400842696", "妙影科技")
```

- ratelimit 滑动窗口算法

```go
-- 1, 2, 3, 4, 5, 6, 7 这是你的元素  
-- ZREMRANGEBYSCORE key1 0 6  
-- 7 执行完之后  
  
-- 限流对象  
local key = KEYS[1]  
-- 窗口大小  
local window = tonumber(ARGV[1])  
-- 阈值  
local threshold = tonumber( ARGV[2])  
local now = tonumber(ARGV[3])  
-- 窗口的起始时间  
local min = now - window  
  
redis.call('ZREMRANGEBYSCORE', key, '-inf', min)  
local cnt = redis.call('ZCOUNT', key, '-inf', '+inf')  
-- local cnt = redis.call('ZCOUNT', key, min, '+inf')  
if cnt >= threshold then  
    -- 执行限流  
    return "true"  
else  
    -- 把 score 和 member 都设置成 now    redis.call('ZADD', key, now, now)  
    redis.call('PEXPIRE', key, window)  
    return "false"  
end
```

1. `local key = KEYS[1]`：从脚本的参数中获取键名。这里，`KEYS` 数组存放了 Lua 脚本执行时传递给 Redis 命令的键名。
2. `local window = tonumber(ARGV[1])`：获取窗口大小的参数，并将其转换为数字。窗口大小是指在限流策略中考虑的时间范围，以毫秒为单位。
3. `local threshold = tonumber(ARGV[2])`：获取阈值的参数，并将其转换为数字。阈值是指在窗口大小时间范围内允许的最大访问次数。
4. `local now = tonumber(ARGV[3])`：获取当前时间的参数，并将其转换为数字。这里的当前时间通常以 UNIX 时间戳的形式（毫秒为单位）表示。
5. `local min = now - window`：计算窗口的起始时间。
6. `redis.call('ZREMRANGEBYSCORE', key, '-inf', min)`：调用 Redis 的 `ZREMRANGEBYSCORE` 命令删除键为 `key` 的有序集合中，所有分数在负无穷到窗口起始时间之间的成员。这一步是清理过期的访问记录。
7. `local cnt = redis.call('ZCOUNT', key, '-inf', '+inf')`：调用 Redis 的 `ZCOUNT` 命令计算有序集合中成员的数量，这里计算的是从负无穷到正无穷，即集合中所有成员的数量，作为当前窗口内的访问次数。
8. `if cnt >= threshold then`：如果当前窗口内的访问次数大于或等于阈值，则执行限流逻辑。
9. `return "true"`：如果执行了限流，返回 "true"。
10. `redis.call('ZADD', key, now, now)`：如果没有达到阈值，则调用 Redis 的 `ZADD` 命令将当前时间作为分数和成员添加到有序集合中，记录这次访问。
11. `redis.call('PEXPIRE', key, window)`：设置键的过期时间为窗口大小，以毫秒为单位。这样可以保证存储在 Redis 中的访问记录不会无限增长。
12. `return "false"`：如果没有执行限流，返回 "false"。

- 本质利用 zset 实现限流算法
- score 和 val 都是时间
- zremrangebyscore 删除 score 范围内的 val
- 统计
- 大于阈值，限流
- 小于阈值，不用限流，加入，设置过期时间
- zadd
- 设置过期时间 pexpire

otel 监控 trace

```go
func (s *Service) Send(ctx context.Context,  
    tplId string,  
    args []string, numbers ...string) error {  
    ctx, span := s.tracer.Start(ctx, "sms_send")  
    defer span.End()  
    // 你也可以考虑拼接进去 span name 里面  
    span.SetAttributes(attribute.String("tplId", tplId))  
    err := s.svc.Send(ctx, tplId, args, numbers...)  
    if err != nil {  
       span.RecordError(err)  
    }  
    return err  
}
```

prometheus

```go
type PrometheusDecorator struct {  
    svc    service.Service  
    vector *prometheus.SummaryVec  
}  
  
func (p *PrometheusDecorator) Send(ctx context.Context, tplId string, args []string, numbers ...string) error {  
    start := time.Now()  
    defer func() {  
       duration := time.Since(start)  
       p.vector.WithLabelValues(tplId).  
          Observe(float64(duration.Milliseconds()))  
    }()  
    return p.svc.Send(ctx, tplId, args, numbers...)  
}  
  
func NewPrometheusDecorator(svc service.Service,  
    namespace string,  
    subsystem string,  
    instanceId string,  
    name string) *PrometheusDecorator {  
    vector := prometheus.NewSummaryVec(prometheus.SummaryOpts{  
       Namespace: namespace,  
       Subsystem: subsystem,  
       Name:      name,  
       ConstLabels: map[string]string{  
          "instance_id": instanceId,  
       },  
       Objectives: map[float64]float64{  
          0.9:   0.01,  
          0.95:  0.01,  
          0.99:  0.001,  
          0.999: 0.0001,  
       },  
       // 加个 tpl 用户就知道自己的业务究竟如何  
    }, []string{"tpl"})  
    prometheus.MustRegister(vector)  
    return &PrometheusDecorator{  
       vector: vector,  
       svc:    svc,  
    }  
}
```

failover 遍历各大短信运营商

验证 token string ---> 给登录过后的人用的

async 同步转异步

```go
type Service struct {  
    svc service.Service  
    // 转异步，存储发短信请求的 repository    repo repository.AsyncSmsRepository  
    l    logger.LoggerV1  
}  
  
func NewService(svc service.Service,  
    repo repository.AsyncSmsRepository,  
    l logger.LoggerV1) *Service {  
    res := &Service{  
       svc:  svc,  
       repo: repo,  
       l:    l,  
    }  
    go func() {  
       res.StartAsyncCycle()  
    }()  
    return res  
}  
  
// StartAsyncCycle 异步发送消息  
// 这里我们没有设计退出机制，是因为没啥必要  
// 因为程序停止的时候，它自然就停止了  
// 原理：这是最简单的抢占式调度  
func (s *Service) StartAsyncCycle() {  
    for {  
       s.AsyncSend()  
    }  
}  
  
func (s *Service) AsyncSend() {  
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
    // 抢占一个异步发送的消息，确保在非常多个实例  
    // 比如 k8s 部署了三个 pod，一个请求，只有一个实例能拿到  
    as, err := s.repo.PreemptWaitingSMS(ctx)  
    cancel()  
    switch err {  
    case nil:  
       // 执行发送  
       // 这个也可以做成配置的  
       ctx, cancel = context.WithTimeout(context.Background(), time.Second)  
       defer cancel()  
       err = s.svc.Send(ctx, as.TplId, as.Args, as.Numbers...)  
       if err != nil {  
          // 啥也不需要干  
          s.l.Error("执行异步发送短信失败",  
             logger.Error(err),  
             logger.Int64("id", as.Id))  
       }  
       res := err == nil  
       // 通知 repository 我这一次的执行结果  
       // mark success or fail
       err = s.repo.ReportScheduleResult(ctx, as.Id, res)  
       if err != nil {  
          s.l.Error("执行异步发送短信成功，但是标记数据库失败",  
             logger.Error(err),  
             logger.Bool("res", res),  
             logger.Int64("id", as.Id))  
       }  
    case repository.ErrWaitingSMSNotFound:  
       // 睡一秒。这个你可以自己决定  
       time.Sleep(time.Second)  
    default:  
       // 正常来说应该是数据库那边出了问题，  
       // 但是为了尽量运行，还是要继续的  
       // 你可以稍微睡眠，也可以不睡眠  
       // 睡眠的话可以帮你规避掉短时间的网络抖动问题  
       s.l.Error("抢占异步发送短信任务失败",  
          logger.Error(err))  
       time.Sleep(time.Second)  
    }  
}  
  
func (s *Service) Send(ctx context.Context, tplId string, args []string, numbers ...string) error {  
    if s.needAsync() {  
       // 需要异步发送，直接转储到数据库  
       err := s.repo.Add(ctx, domain.AsyncSms{  
          TplId:   tplId,  
          Args:    args,  
          Numbers: numbers,  
          // 设置可以重试三次  
          RetryMax: 3,  
       })  
       return err  
    }  
    return s.svc.Send(ctx, tplId, args, numbers...)  
}  
  
// 提前引导你们，开始思考系统容错问题  
// 你们面试装逼，赢得竞争优势就靠这一类的东西  
func (s *Service) needAsync() bool {  
    // 这边就是你要设计的，各种判定要不要触发异步的方案  
    // 1. 基于响应时间的，平均响应时间  
    // 1.1 使用绝对阈值，比如说直接发送的时候，（连续一段时间，或者连续N个请求）响应时间超过了 500ms，然后后续请求转异步  
    // 1.2 变化趋势，比如说当前一秒钟内的所有请求的响应时间比上一秒钟增长了 X%，就转异步  
    // 2. 基于错误率：一段时间内，收到 err 的请求比率大于 X%，转异步  
  
    // 什么时候退出异步  
    // 1. 进入异步 N 分钟后  
    // 2. 保留 1% 的流量（或者更少），继续同步发送，判定响应时间/错误率  
    return true  
}
```

1. new sevice 的时候开启异步调用
2. 不断的从数据库中取出是否有，如果有，发送数据
3. 如果没有，睡眠 1 s

- 同步转异步的方案是什么 (赢得竞争优势)

```go
// 提前引导你们，开始思考系统容错问题  
// 你们面试装逼，赢得竞争优势就靠这一类的东西  
func (s *Service) needAsync() bool {  
    // 这边就是你要设计的，各种判定要不要触发异步的方案  
    // 1. 基于响应时间的，平均响应时间  
    // 1.1 使用绝对阈值，比如说直接发送的时候，（连续一段时间，或者连续N个请求）响应时间超过了 500ms，然后后续请求转异步  
    // 1.2 变化趋势，比如说当前一秒钟内的所有请求的响应时间比上一秒钟增长了 X%，就转异步  
    // 2. 基于错误率：一段时间内，收到 err 的请求比率大于 X%，转异步  
  
    // 什么时候退出异步  
    // 1. 进入异步 N 分钟后  
    // 2. 保留 1% 的流量（或者更少），继续同步发送，判定响应时间/错误率  
    return true  
}
```
