- canalx canal 结构体定义
- cronjobx 定时任务
- ginx gin 的 middleware 和请求包装
- gormx 双写实现，源码比较多和难哦
- grpcx grpc server 的封装、负载均衡、监控日志等功能的封装
- logger 日志模块的封装
- migrator 不懂诶
- netx 获取 outbound 的 IP
- ratelimit 滑动窗口算法的封装
- redisx 给 redis 封装监控 通过 redis.ProcessHook
- seramax 批处理的方案
- wego 定义 APP grpcServer 和 WebServer
- 你可以做到的，晚上发简历

## Ginx

### Accessslog

这段 Go 代码实现了一个用于 Gin 框架的自定义中间件生成器 `MiddlewareBuilder`，其主要目的是为了在处理 HTTP 请求时生成和记录访问日志（`AccessLog`）。通过这个中间件，开发者可以灵活地配置是否需要记录请求体（`Request Body`）和响应体（`Response Body`），以及自定义日志记录的方式。

#### 功能概述

1. **日志记录**：自定义函数 `logFunc` 负责日志的记录工作，它在请求处理完毕后执行，记录包括请求方法、路径、请求体、持续时间、状态码和响应体等信息。
2. **请求体记录**：通过 `AllowReqBody` 方法开启请求体记录功能。当启用时，中间件会读取请求体内容并保存到日志对象 `AccessLog` 中。
3. **响应体记录**：通过 `AllowRespBody` 方法开启响应体记录功能。当启用时，中间件会替换 Gin 的默认响应写入器（`ResponseWriter`），以便捕获并记录响应体内容。
4. **链式调用**：`MiddlewareBuilder` 设计为支持链式调用，可以灵活地配置中间件。

#### 代码流程解析

- `NewMiddlewareBuilder`：初始化一个 `MiddlewareBuilder` 实例，接受一个用于日志记录的函数。
- `AllowReqBody` 和 `AllowRespBody`：分别开启请求体和响应体的记录功能。
- `Build`：构建并返回一个实际执行日志记录任务的 Gin 中间件。该中间件在每次请求处理前后进行操作，以实现访问日志的记录。
- `responseWriter`：一个自定义的 `gin.ResponseWriter`，用于拦截和记录响应状态码和响应体。它重写了 `WriteHeader`、`Write` 和 `WriteString` 方法，以便在写入响应时同时更新 `AccessLog` 对象。

#### 用途和优势

这个中间件生成器非常适合需要详细访问日志记录的 Web 应用。它提供了灵活的配置选项，比如根据需求选择是否记录请求/响应体，而且通过自定义日志记录函数，可以轻松地将日志集成到已有的日志系统中，如 ELK、Loki 等。

此外，通过记录请求处理的持续时间、状态码等信息，这个中间件还有助于监控和分析 API 的性能和健康状况。

#### 核心代码

```go
// AccessLog 你可以打印很多的信息，根据需要自己加
type AccessLog struct {
	Method     string `json:"method"`
	Path       string `json:"path"`
	ReqBody    string `json:"req_body"`
	Duration   string `json:"duration"`
	StatusCode int    `json:"status_code"`
	RespBody   string `json:"resp_body"`
}

type responseWriter struct {
	al *AccessLog
	gin.ResponseWriter
}

func (r responseWriter) WriteHeader(statusCode int) {
	r.al.StatusCode = statusCode
	r.ResponseWriter.WriteHeader(statusCode)
}

func (r responseWriter) Write(data []byte) (int, error) {
	r.al.RespBody = string(data)
	return r.ResponseWriter.Write(data)
}

func (r responseWriter) WriteString(data string) (int, error) {
	r.al.RespBody = data
	return r.ResponseWriter.WriteString(data)
}
```

### Metrics

```go
// PrometheusBuilder 主要是统计响应时间
type PrometheusBuilder struct {
	// 除了一个 Name 是必选的，其它都是可选的
	// 如果暴露 New 方法，那么就需要考虑暴露其他的方法来允许用户配置 Namespace 等
	// 所以我直接做成了公开字段
	Namespace string
	Subsystem string
	Name      string
	Help      string
	// 这一个实例名字，你可以考虑使用 本地 IP，
	// 又或者在启动的时候配置一个 ID
	InstanceID string
}

func (p *PrometheusBuilder) BuildResponseTime() gin.HandlerFunc {
	// pattern 是命中路由
	labels := []string{"method", "pattern", "status"}
	vector := prometheus.NewSummaryVec(prometheus.SummaryOpts{
		Namespace: p.Namespace,
		Subsystem: p.Subsystem,
		Name:      p.Name + "_resp_time",
		Help:      p.Help,
		ConstLabels: map[string]string{
			"instance_id": p.InstanceID,
		},
		Objectives: map[float64]float64{
			0.5:   0.01,
			0.75:  0.01,
			0.90:  0.01,
			0.99:  0.001,
			0.999: 0.0001,
		},
	}, labels)
	prometheus.MustRegister(vector)
	return func(ctx *gin.Context) {
		method := ctx.Request.Method
		start := time.Now()
		defer func() {
			// 最后我们再来统计一下
			vector.WithLabelValues(
				method, ctx.FullPath(),
				strconv.Itoa(ctx.Writer.Status()),
				// 执行时间
			).Observe(float64(time.Since(start).Milliseconds()))
		}()
		ctx.Next()
	}
}

func (p *PrometheusBuilder) BuildActiveRequest() gin.HandlerFunc {
	// 一般我们只关心总的活跃请求数
	gauge := prometheus.NewGauge(prometheus.GaugeOpts{
		Namespace: p.Namespace,
		Subsystem: p.Subsystem,
		Name:      p.Name + "_active_req",
		Help:      p.Help,
		ConstLabels: map[string]string{
			"instance_id": p.InstanceID,
		},
	})
	prometheus.MustRegister(gauge)
	return func(ctx *gin.Context) {
		gauge.Inc()
		defer gauge.Dec()
		ctx.Next()
	}
}
```

1. 统计响应事件
2. 统计活跃请求数

### Ratelimit

```go
type Builder struct {
	prefix   string
	cmd      redis.Cmdable
	interval time.Duration
	// 阈值
	rate int
}

//go:embed slide_window.lua
var luaScript string

func NewBuilder(cmd redis.Cmdable, interval time.Duration, rate int) *Builder {
	return &Builder{
		cmd:      cmd,
		prefix:   "ip-limiter",
		interval: interval,
		rate:     rate,
	}
}

func (b *Builder) Prefix(prefix string) *Builder {
	b.prefix = prefix
	return b
}

func (b *Builder) Build() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		limited, err := b.limit(ctx)
		if err != nil {
			log.Println(err)
			// 这一步很有意思，就是如果这边出错了
			// 要怎么办？
			ctx.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		if limited {
			log.Println(err)
			ctx.AbortWithStatus(http.StatusTooManyRequests)
			return
		}
		ctx.Next()
	}
}

func (b *Builder) limit(ctx *gin.Context) (bool, error) {
	key := fmt.Sprintf("%s:%s", b.prefix, ctx.ClientIP())
	return b.cmd.Eval(ctx, luaScript, []string{key},
		b.interval.Milliseconds(), b.rate, time.Now().UnixMilli()).Bool()
}
```

1. 实现基于 IP 和滑动窗口算法的限流

```lua
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
    -- 把 score 和 member 都设置成 now
    redis.call('ZADD', key, now, now)
    redis.call('PEXPIRE', key, window)
    return "false"
end
```

1. 先删除当前时间窗口之前的请求
2. 计算一共有多少请求
3. 如果数量 > 阈值
	1. return true 执行限流
4. 如果数量 < 阈值
	1. return false

### 包装请求

### 封装统一数据结构

```go
type Server struct {
	*gin.Engine
	Addr string
}

func (s *Server) Start() error {
	return s.Engine.Run(s.Addr)
}

// Result 你可以通过在 Result 里面定义更加多的字段，来配合 Wrap 方法
type Result struct {
	Code int    `json:"code"`
	Msg  string `json:"msg"`
	Data any    `json:"data"`
}

type UserClaims struct {
	Id        int64
	UserAgent string
	Ssid      string
	jwt.RegisteredClaims
}
```

## Gormx

### 基于 Prometheus 统计各种 SQL 的执行时间

```go
type Callbacks struct {
	Namespace  string
	Subsystem  string
	Name       string
	InstanceID string
	Help       string
	vector     *prometheus.SummaryVec
}

func (c *Callbacks) Register(db *gorm.DB) error {
	vector := prometheus.NewSummaryVec(
		prometheus.SummaryOpts{
			Name:      c.Name,
			Subsystem: c.Subsystem,
			Namespace: c.Namespace,
			Help:      c.Help,
			ConstLabels: map[string]string{
				"db_name":     db.Name(),
				"instance_id": c.InstanceID,
			},
			Objectives: map[float64]float64{
				0.9:  0.01,
				0.99: 0.001,
			},
		},
		[]string{"type", "table"})
	prometheus.MustRegister(vector)
	c.vector = vector

	// Querys
	err := db.Callback().Query().Before("*").
		Register("prometheus_query_before", c.before("query"))
	if err != nil {
		return err
	}

	err = db.Callback().Query().After("*").
		Register("prometheus_query_after", c.after("query"))
	if err != nil {
		return err
	}

	err = db.Callback().Raw().Before("*").
		Register("prometheus_raw_before", c.before("raw"))
	if err != nil {
		return err
	}

	err = db.Callback().Query().After("*").
		Register("prometheus_raw_after", c.after("raw"))
	if err != nil {
		return err
	}

	err = db.Callback().Create().Before("*").
		Register("prometheus_create_before", c.before("create"))
	if err != nil {
		return err
	}

	err = db.Callback().Create().After("*").
		Register("prometheus_create_after", c.after("create"))
	if err != nil {
		return err
	}

	err = db.Callback().Update().Before("*").
		Register("prometheus_update_before", c.before("update"))
	if err != nil {
		return err
	}

	err = db.Callback().Update().After("*").
		Register("prometheus_update_after", c.after("update"))
	if err != nil {
		return err
	}

	err = db.Callback().Delete().Before("*").
		Register("prometheus_delete_before", c.before("delete"))
	if err != nil {
		return err
	}

	err = db.Callback().Delete().After("*").
		Register("prometheus_delete_after", c.after("delete"))
	if err != nil {
		return err
	}
	return nil
}

// before 这里就是为了保持风格统一
func (c *Callbacks) before(typ string) func(db *gorm.DB) {
	return func(db *gorm.DB) {
		start := time.Now()
		db.Set("start_time", start)
	}
}

func (c *Callbacks) after(typ string) func(db *gorm.DB) {
	return func(db *gorm.DB) {
		val, _ := db.Get("start_time")
		// 如果上面没找到，这边必然断言失败
		start, ok := val.(time.Time)
		if !ok {
			// 没必要记录，有系统问题，可以记录日志
			return
		}
		duration := time.Since(start)
		c.vector.WithLabelValues(typ, db.Statement.Table).
			Observe(float64(duration.Milliseconds()))
	}
}
```

1. before set
2. after get and since record
3. 统计各种查询的执行时间
4. Register

## Redisx

### Hook

```go
type (
	DialHook            func(ctx context.Context, network, addr string) (net.Conn, error)
	ProcessHook         func(ctx context.Context, cmd Cmder) error
	ProcessPipelineHook func(ctx context.Context, cmds []Cmder) error
)
```

```go
type PrometheusHook struct {
	vector *prometheus.SummaryVec
}

func NewPrometheusHook(
	namespace string,
	subsystem string,
	instanceId string,
	name string,
) *PrometheusHook {
	vector := prometheus.NewSummaryVec(prometheus.SummaryOpts{
		Namespace: namespace,
		Subsystem: subsystem,
		Name:      name,
		ConstLabels: map[string]string{
			"instance_id": instanceId,
		},
	}, []string{"cmd", "key_exist"})
	return &PrometheusHook{
		vector: vector,
	}
}

func (p *PrometheusHook) ProcessHook(next redis.ProcessHook) redis.ProcessHook {
	return func(ctx context.Context, cmd redis.Cmder) error {
		start := time.Now()
		var err error
		defer func() {
			duration := time.Since(start)
			keyExist := err == redis.Nil
			// 集群下可以考虑使用 FullName
			p.vector.WithLabelValues(cmd.Name(),
				strconv.FormatBool(keyExist)).
				Observe(float64(duration.Milliseconds()))
		}()
		err = next(ctx, cmd)
		return err
	}
}

```

1. 利用 Prometheus 统计 Redis 时间

## Saramax

### batch_handler_func

干好自己的事，多关注自己，少研究别人

### consumer_handler_func

### handler_func

### Types
