- Time：2023-07-04 19:32
- Label： #go #标准库

## Abstract

用 go 生成随机数

1. 设置种子：`rand.Seed(time.Now().UnixNano())`
2. 生成随机数：`randomInt := rand.Intn(100)`

## Content

在 Go 中，你可以使用 `math/rand` 包来生成随机数。下面是一些示例代码来演示如何生成随机数：

```go
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	// 设置随机种子
	rand.Seed(time.Now().UnixNano())

	// 生成一个随机整数
	randomInt := rand.Intn(100)
	fmt.Println(randomInt)

	// 生成一个随机浮点数
	randomFloat := rand.Float64()
	fmt.Println(randomFloat)
}
```

在上面的代码中，我们首先通过 `rand.Seed` 方法设置了随机种子，以确保每次程序运行时都会产生不同的随机序列。然后，使用 `rand.Intn` 方法生成一个指定范围内的随机整数，本例中是 0 到 100 之间的整数。另外，使用 `rand.Float64` 方法生成一个 0 到 1 之间的随机浮点数。

需要注意的是，`math/rand` 包生成的随机数是伪随机数，通过种子生成。如果需要更高质量的随机数，可以考虑使用 `crypto/rand` 包，它提供了加密级别的随机数生成方法。

## Reference
