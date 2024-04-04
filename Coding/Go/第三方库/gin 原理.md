- serveHTTP
- 内存池，公用

![[Snipaste/Pasted image 20240404133451.png]]

- 对象池进行优化

![[Snipaste/Pasted image 20240404133706.png]]

- abort index = abortIndex

## 中间件

- default log 和 recovery 中间价
- recovery 中间件中是一个大段的 defer ，先执行逻辑，如果出现错误，就会使用 recover 去捕获错误。

## Engine 对象初始化

1. 初始化 Engine 对象
2. 设置 sync.Pool 新建上下文对象对象函数

## 创建路由器组

1. 中间件处理器的数量最多是 63

![[Snipaste/Pasted image 20240404134752.png]]

## 注册路由

## 上下文

1. 对象池中获取 Context
2. 如果 Context 被传递给协程，那么一定要对 Context 进行拷贝  
![[Snipaste/Pasted image 20240404135746.png]]
3. 为什么要拷贝
4. 为了防止 context 在完成整个处理链条之后会被框架回收
5. 为了安全的让协程使用 context 的副本对象，所以要拷贝

- parm
- query

```go
type Context struct {
	writermem responseWriter
	// 请求对象
	Request   *http.Request
	// 响应对象
	Writer    ResponseWriter

	// /user/:id
	Params   Params
	// 中间件数组
	handlers HandlersChain
	// 当前中间件下标
	index    int8
	// 完整路径
	fullPath string

	// 引擎对象
	engine       *Engine
	params       *Params
	skippedNodes *[]skippedNode

	// This mutex protects Keys map.
	// map 不是线程安全的
	mu sync.RWMutex

	// Keys is a key/value pair exclusively for the context of each request.
	Keys map[string]any

	// Errors is a list of errors attached to all the handlers/middlewares who used this context.
	// 错误数组
	Errors errorMsgs

	// Accepted defines a list of manually accepted formats for content negotiation.
	Accepted []string

	// queryCache caches the query result from c.Request.URL.Query().
	// url 请求参数
	queryCache url.Values

	// formCache caches c.Request.PostForm, which contains the parsed form data from POST, PATCH,
	// or PUT body parameters.
	// form 参数
	formCache url.Values

	// SameSite allows a server to define a cookie attribute making it impossible for
	// the browser to send this cookie along with cross-site requests.
	sameSite http.SameSite
}
```

![[Snipaste/Pasted image 20240404140709.png]]

- [[go语言源码阅读] 50分钟搞定gin框架核心源码_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Hm4y1D7q8/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
