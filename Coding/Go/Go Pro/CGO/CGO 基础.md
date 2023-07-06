- Time：2023-07-05 19:28
- Label： #go #cgo

## Abstract

> 我感觉最近应该是不会用到 cgo 的，但是怎么说呢，学都学了，那就学完叭。关注重点关照的部分。

## Content

要使用 CGO 特性，需要安装 C/C++ 构建工具链，在 macOS 和 Linux 下是要安装 **GCC**，在 windows 下是需要安装 **MinGW** 工具。同时需要保证环境变量 `CGO_ENABLED` 被设置为 1，这表示 CGO 是被启用的状态。在本地构建时 `CGO_ENABLED` 默认是启用的，**当交叉构建时 CGO 默认是禁止的**。比如要交叉构建 ARM 环境运行的 Go 程序，需要**手工设置好 C/C++ 交叉构建的工具链**，同时开启 `CGO_ENABLED` 环境变量。然后通过 `import "C"` 语句启用 CGO 特性。

### Import "C" 语句

如果在 Go 代码中出现了 `import "C"` 语句则表示使用了 CGO 特性，紧跟在这行语句前面的注释是一种特殊语法，里面包含的是正常的 C 语言代码。当确保 CGO 启用的情况下，还可以在当前目录中包含 C/C++ 对应的源文件。

举个最简单的例子：

```go
package main

/*
#include <stdio.h>

void printint(int v) {
    printf("printint: %d\n", v);
}
*/
import "C"

func main() {
    v := 42
    C.printint(C.int(v))
}
```

### \#cgo 语句

### Build Tag 条件编译

## Reference

- [CGO基础 - Go语言高级编程 (chai2010.cn)](https://chai2010.cn/advanced-go-programming-book/ch2-cgo/ch2-02-basic.html)
