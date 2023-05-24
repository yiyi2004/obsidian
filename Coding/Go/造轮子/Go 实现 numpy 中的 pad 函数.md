在 NumPy 中，`pad` 函数用于在数组的边界或指定维度的两侧添加填充值。它可以通过指定填充宽度和填充值来实现。

下面是一个使用 Go 实现类似功能的简单示例：

```go
package main

import (
	"fmt"
)

func PadArray(arr [][]int, padWidth [][]int, padValue int) [][]int {
	// 获取原始数组的形状
	rows := len(arr)
	cols := len(arr[0])

	// 计算填充后的数组的形状
	paddedRows := rows + padWidth[0][0] + padWidth[0][1]
	paddedCols := cols + padWidth[1][0] + padWidth[1][1]

	// 创建填充后的数组
	paddedArr := make([][]int, paddedRows)
	for i := 0; i < paddedRows; i++ {
		paddedArr[i] = make([]int, paddedCols)
	}

	// 在填充后的数组中拷贝原始数组的值
	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			paddedArr[i+padWidth[0][0]][j+padWidth[1][0]] = arr[i][j]
		}
	}

	// 填充顶部和底部的边界
	for i := 0; i < padWidth[0][0]; i++ {
		for j := 0; j < paddedCols; j++ {
			paddedArr[i][j] = padValue
			paddedArr[paddedRows-i-1][j] = padValue
		}
	}

	// 填充左侧和右侧的边界
	for i := 0; i < paddedRows; i++ {
		for j := 0; j < padWidth[1][0]; j++ {
			paddedArr[i][j] = padValue
			paddedArr[i][paddedCols-j-1] = padValue
		}
	}

	return paddedArr
}

func main() {
	// 原始数组
	arr := [][]int{
		{1, 2, 3},
		{4, 5, 6},
	}

	// 填充宽度
	padWidth := [][]int{
		{1, 2},
		{2, 3},
	}

	// 填充值
	padValue := 0

	// 调用 PadArray 函数进行填充
	paddedArr := PadArray(arr, padWidth, padValue)

	// 打印填充后的数组
	for _, row := range paddedArr {
		fmt.Println(row)
	}
}
```

在上面的示例中，我们定义了 `PadArray` 函数，该函数接受原始数组 `arr`、填充宽度 `padWidth` 和填充值 `padValue` 作为参数，并返回填充后的数组。

函数首先计算填充后的数组的形状，然后创建一个与形状匹配的填充后的数组 `paddedArr`。

接下来，函数使用两个嵌套循环将

原始数组的值复制到填充后的数组的适当位置。

然后，函数使用循环填充顶部、底部、左侧和右侧的边界，将填充值 `padValue` 赋给相应位置的元素。

最后，函数返回填充后的数组。

在示例中，我们传递了一个原始数组 `arr`、填充宽度 `padWidth` 和填充值 `padValue` 给 `PadArray` 函数，并打印填充后的数组。

请注意，此示例仅为演示目的，并未对输入进行严格的错误检查和边界情况处理。在实际使用中，需要根据需求进行适当的错误处理和边界条件检查。

#chatgpt #go #造轮子
