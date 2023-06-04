- 04 Go 有异常类型吗？  
有。Go 用 error 类型代替 try…catch 语句，这样可以节省资源。同时增加代码可读性：

```go
 _, err := funcDemo()
if err != nil {
    fmt.Println(err)
    return
}
```

也可以用 errors.New() 来定义自己的异常。errors.Error() 会返回异常的字符串表示。只要实现 error 接口就可以定义自己的异常，

```go
 type errorString struct {
  s string
 }
 ​
 func (e *errorString) Error() string {
  return e.s
 }
 ​
 // 多一个函数当作构造函数
 func New(text string) error {
  return &errorString{text}
 }
```

- 什么是 Goroutine  
协程是用户态轻量级线程，它是线程调度的基本单位。通常在函数前加上 go 关键字就能实现并发。一个 Goroutine 会以一个很小的栈启动 2KB 或 4KB，当遇到栈空间不足时，栈会自动伸缩， 因此可以轻易实现成千上万个 goroutine 同时启动。

- 如何高效的拼接字符串  
拼接字符串的方式有：`+` , `fmt.Sprintf` , `strings.Builder`, `bytes.Buffer`, `strings.Join`  
strings.Join ≈ strings.Builder > bytes.Buffer > "+" > fmt.Sprintf
- 示例代码我就不粘了。

什么是 rune 类型

## Reference

- [Go常见面试题【由浅入深】2022版](https://zhuanlan.zhihu.com/p/471490292)
- [2022 腾讯社招Golang后端面试经验分享](https://zhuanlan.zhihu.com/p/507820598)
- [Go Frequently Asked Questions (FAQ)](https://go.dev/doc/faq)
- [bregman-arie](https://github.com/bregman-arie)/**[devops-exercises](https://github.com/bregman-arie/devops-exercises)**
