- Time：2023-07-05 18:15
- Label： #标准库 #go #chatgpt

## Abstract

## Content

### Transport 的作用

在 Go 语言中，`http.Transport` 接口是用于控制 HTTP 客户端的底层传输行为的接口。它提供了一些配置选项，可以用于设置 HTTP 请求的超时、连接池管理、代理等功能。

`http.Transport` 接口的作用包括但不限于：

1. 控制连接的重用和连接池管理：`http.Transport` 内部维护了一个连接池，可以复用 TCP 连接，减少连接建立的开销。
2. 设置连接的超时和保活机制：可以设置连接的超时时间，以及控制连接在空闲状态下的保活时间。
3. 配置代理：可以设置代理服务器来进行 HTTP 请求的转发。
4. 控制重定向：可以设置是否允许自动重定向，并可以自定义重定向策略。
5. 配置 TLS：可以设置 TLS 相关的选项，如根证书、客户端证书等。

通过创建自定义的 `http.Transport` 对象，你可以根据需求对 HTTP 请求的底层传输进行配置和调整。例如，可以设置超时时间，调整连接池的大小，或者使用自定义的 TLS 配置。

在使用 `http.Client` 时，默认情况下会使用默认的 `http.Transport` 对象，你也可以通过 `Transport` 字段来指定自定义的 `http.Transport` 对象。

下面是一个用 Transport 测试本地数据的例子，只会获取本地的数据：

```go
type RoundTripFunc func(req *http.Request) *http.Response

func (f RoundTripFunc) RoundTrip(req *http.Request) (*http.Response, error) {
	return f(req), nil
}

// transport
func NewTestClient(fn RoundTripFunc) *http.Client {
	return &http.Client{
		Transport: fn,
	}
}

var client = NewTestClient(func(req *http.Request) *http.Response {
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(bytes.NewBufferString(jsonToReture)),
		Header:     make(http.Header),
	}
})
```

这里面有几个值得注意的点：  
there are several key points worth studying

1. http transport
2. http Transport RoundTripper
3. io.NopCloser
4. bytes.NewBufferString <-- why this

- RoundTripper 的定义

some questions

1. how to ensure concurrency safe
2. you can use the machinem to handle the response data, but why? ---> for go test?

```go
// RoundTripper is an interface representing the ability to execute a
// single HTTP transaction, obtaining the Response for a given Request.
//
// A RoundTripper must be safe for concurrent use by multiple
// goroutines.
type RoundTripper interface {
	// RoundTrip executes a single HTTP transaction, returning
	// a Response for the provided Request.
	//
	// RoundTrip should not attempt to interpret the response. In
	// particular, RoundTrip must return err == nil if it obtained
	// a response, regardless of the response's HTTP status code.
	// A non-nil err should be reserved for failure to obtain a
	// response. Similarly, RoundTrip should not attempt to
	// handle higher-level protocol details such as redirects,
	// authentication, or cookies.
	//
	// RoundTrip should not modify the request, except for
	// consuming and closing the Request's Body. RoundTrip may
	// read fields of the request in a separate goroutine. Callers
	// should not mutate or reuse the request until the Response's
	// Body has been closed.
	//
	// RoundTrip must always close the body, including on errors,
	// but depending on the implementation may do so in a separate
	// goroutine even after RoundTrip returns. This means that
	// callers wanting to reuse the body for subsequent requests
	// must arrange to wait for the Close call before doing so.
	//
	// The Request's URL and Header fields must be initialized.
	RoundTrip(*Request) (*Response, error)
}
```

## Reference
