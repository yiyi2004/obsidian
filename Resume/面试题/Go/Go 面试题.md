- Time：2023-06-24 20:14
- Label： #go #面试题

## Abstract

Golang 面试题搜集，搜集那些你回答不上来的面试题。

## Content

### Go 有异常类型吗？

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

### 什么是 Goroutine

协程是用户态轻量级线程，它是线程调度的基本单位。通常在函数前加上 go 关键字就能实现并发。一个 Goroutine 会以一个很小的栈启动 2KB 或 4KB，当遇到栈空间不足时，栈会自动伸缩， 因此可以轻易实现成千上万个 goroutine 同时启动。

### 如何高效的拼接字符串

拼接字符串的方式有：`+` , `fmt.Sprintf` , `strings.Builder`, `bytes.Buffer`, `strings.Join`  
strings.Join ≈ strings.Builder > bytes.Buffer > "+" > fmt.Sprintf

示例代码我就不粘了。

### 什么是 Rune 类型

Rune ---> uint8 是 unicode

### Go 语言中的 Nil 是什么？

nil 不是关键字，是一个预先声明的**标识符**，指针、通道、函数、接口、map、切片的零值就是 nil，  

nil 是没有默认类型的，他的类型具有不确定性，我们在使用它时必须要提供足够的信息能够让编译器推断 nil 期望的类型；

两个 nil 不能进行比较，因为 nil 是无类型的；

1. 声明一个 nil 的 map，map 可以读数据，但是不能写数据
2. 关闭一个 nil 的 channel 会引发 panic
3. nil 切片不能进行索引访问，会引发 panic
4. 方法接收者为 nil 时，如果在方法内使用到了会引发 panic
5. 空指针一个没有任何值的指针

### Flag 库了解吗？有什么陷阱？

flag 是 Go 官方提供的标准包，用来实现命令行解析，flag 使开发命令行工具更为简单，有两个陷阱：

1. 当我们把 flag 放置在 cli 应用的最后面时，需要小心参数传递的顺序，flag 包的命令行参数的解析逻辑是：当碰到第一个非 flag 参数时，便停止解析，所以如果传入非法参数就会导致后面的参数解析错误；
2. 对于 bool 类型的 flag 参数，只支持以下两种方式

```shell
-arg
-arg=value
```

其他形式会出错  
其实你对 go 的 flag 包并不是很了解哦

## Reference

- [Go常见面试题【由浅入深】2022版](https://zhuanlan.zhihu.com/p/471490292)
- [2022 腾讯社招Golang后端面试经验分享](https://zhuanlan.zhihu.com/p/507820598)
- [Go Frequently Asked Questions (FAQ)](https://go.dev/doc/faq)
- [bregman-arie](https://github.com/bregman-arie)/**[devops-exercises](https://github.com/bregman-arie/devops-exercises)**
