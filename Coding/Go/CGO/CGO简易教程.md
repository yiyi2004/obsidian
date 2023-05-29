## 快速入门

```go
// hello.go
package main

/*
#include <stdio.h>

static void SayHello(const char* s) {
    puts(s);
}
*/
import "C"

func main() {
    C.SayHello(C.CString("Hello, World\n"))
}

```

- 分文件写

```c
// hello.c

#include <stdio.h>

void SayHello(const char* s) {
    puts(s);
}

```

```go
// hello.go
package main

//void SayHello(const char* s);
import "C"

func main() {
    C.SayHello(C.CString("Hello, World\n"))
}

```

既然 `SayHello` 函数已经放到独立的 C 文件中了，我们自然可以将对应的 C 文件编译打包为静态库或动态库文件供使用。如果是以静态库或动态库方式引用 `SayHello` 函数的话，需要将对应的 C 源文件移出当前目录（CGO 构建程序会自动构建当前目录下的 C 源文件，从而导致 C 函数名冲突）。关于静态库等细节将在稍后章节讲解。

## Go 静态编译 C 系统库的方法

#cgo #go #chatgpt  

Go 静态编译 C 系统库的方法：  
要在 Go 中实现静态编译和静态链接 C 的系统库，需要进行以下几个步骤：

1. 设置 CGO_ENABLED 环境变量为 0，这样 Go 就不会使用 CGO，从而避免使用 C 库时链接动态库。

```
export CGO_ENABLED=0
```

1. 设置编译器参数，以静态链接 C 的系统库。例如，对于 musl libc，可以使用以下编译器参数：

```
gcc -static-libgcc -static-libstdc++ -static -lpthread
```

其中，-static-libgcc 和 -static-libstdc++ 用于静态链接 C++ 的运行时库；-static 用于告诉编译器生成静态链接的二进制文件；-lpthread 用于链接 pthread 库。  
3. 在 go build 命令中添加 -ldflags 参数，以链接编译器参数。例如：

```
go build -ldflags '-s -w -extldflags "-static-libgcc -static-libstdc++ -static -lpthread"'
```

其中，-s 和 -w 用于删除二进制文件中的符号表和调试信息，减小文件大小。-extldflags 用于传递给外部链接器的参数，这里指定了静态链接的编译器参数。  
这样就可以在 Go 中实现静态编译和静态链接 C 的系统库了。

在 Go 中，可以使用 cgo 来链接 C 的标准库。cgo 是一个可以让 Go 调用 C 代码的工具，它能够在编译时将 C 代码链接到 Go 代码中。  
下面是使用 cgo 静态链接 C 的标准库的步骤：

1. 编写 C 代码并编译成静态库。将 C 代码编写为静态库，即生成 .a 文件。可以使用 gcc 等工具进行编译。
2. 在 Go 代码中使用 cgo 来链接静态库。在 Go 代码中，使用 cgo 的 #cgo 指令来链接 C 的标准库。可以在 Go 文件中使用 // #cgo 指令指定编译选项和链接库，例如：

```go
// #cgo CFLAGS: -I./include
// #cgo LDFLAGS: -L./lib -lfoo
// #include "foo.h"
import "C"
```

其中，-I 表示头文件的路径，-L 表示库文件的路径，-l 表示链接的库名。  
3. 在 Go 代码中调用 C 函数。在 Go 代码中，使用 C.xxx 的方式来调用 C 函数。例如：

```go
result := C.foo()
```

其中，foo 是 C 语言中的函数名，可以通过 #include "foo.h" 来包含头文件。  
4. 编译和链接 Go 代码。在编译 Go 代码时，需要使用 CGO_ENABLED=1 参数来启用 cgo。例如：

```sh
CGO_ENABLED=1 go build main.go
```

使用 cgo 静态链接 C 的标准库可以方便地在 Go 代码中调用 C 的函数，但需要注意一些细节，例如编译选项、头文件路径、库文件路径等。同时需要注意静态库的兼容性问题。

## Reference

- [yulong-ids-example](https://github1s.com/ysrc/yulong-hids-archived/blob/HEAD/agent/monitor/connection_linux.go)
- [快速入门 - Go语言高级编程 (chai2010.cn)](https://chai2010.cn/advanced-go-programming-book/ch2-cgo/ch2-01-hello-cgo.html)
- [MinGW-w64 - for 32 and 64 bit Windows - Browse /mingw-w64 at SourceForge.net](https://sourceforge.net/projects/mingw-w64/files/mingw-w64/)
- [cgo command - cmd/cgo - Go Packages](https://pkg.go.dev/cmd/cgo)
