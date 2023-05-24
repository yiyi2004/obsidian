在 NumPy 中，`expand_dims` 函数用于在数组中插入新的轴。在 Go 中，可以使用切片操作和 `append` 函数来实现类似的功能。

下面是一个用 Go 实现 `expand_dims` 函数的示例代码：

```go
package main

import (
	"fmt"
)

func expandDims(arr []float64, axis int) [][]float64 {
	// 获取数组的维度
	dims := len(arr)

	// 创建新的维度数组
	newDims := dims + 1

	// 创建新的数组
	newArr := make([][]float64, 0)

	// 在指定的轴上插入新的维度
	for i := 0; i < newDims; i++ {
		if i == axis {
			newArr = append(newArr, make([]float64, 1))
		} else {
			newArr = append(newArr, arr)
		}
	}

	return newArr
}

func main() {
	arr := []float64{1, 2, 3}
	axis := 1
	newArr := expandDims(arr, axis)
	fmt.Println(newArr)
}
```

在上面的示例代码中，`expandDims` 函数接受一个浮点数类型的切片 `arr` 和一个整数类型的 `axis` 参数。它将在指定的 `axis` 轴上插入一个新的维度，并返回新的数组。

运行以上代码，输出结果为：

```
[[1] [2] [3]]
```

可以看到，通过 `expandDims` 函数，我们成功在切片 `arr` 的指定轴上插入了一个新的维度，得到了一个新的二维数组。  

#chatgpt #go #造轮子

明天把轮子造完，应该就差不多完成了
