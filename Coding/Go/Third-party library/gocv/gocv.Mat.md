#chatgpt #gocv #go #AI #第三方库 #opencv

## CopyMakeBorder

在 GoCV 中，可以使用 `gocv.CopyMakeBorder` 函数对 `gocv.Mat` 对象进行填充（padding）。该函数可以在图像的四个边缘添加指定数量的像素，以实现填充效果。

以下是使用 `gocv.CopyMakeBorder` 函数进行填充的示例：

```go
import (
	"gocv.io/x/gocv"
)

func main() {
	// 加载图像
	image := gocv.IMRead("image.jpg", gocv.IMReadColor)
	defer image.Close()

	// 指定填充的数量
	top := 10
	bottom := 10
	left := 20
	right := 20

	// 执行填充操作
	paddedImage := gocv.NewMat()
	gocv.CopyMakeBorder(image, &paddedImage, top, bottom, left, right, gocv.BorderConstant, gocv.NewScalar(0, 0, 0, 0))

	// 显示填充后的图像
	window := gocv.NewWindow("Padded Image")
	defer window.Close()
	window.IMShow(paddedImage)
	window.WaitKey(0)
}
```

在上述示例中，我们首先加载了一张图像，然后指定了上、下、左、右四个方向的填充数量。接下来，我们使用 `gocv.CopyMakeBorder` 函数对图像进行填充操作，并将结果保存在新创建的 `gocv.Mat` 对象 `paddedImage` 中。最后，我们使用 `gocv.NewWindow` 和 `window.IMShow` 函数显示填充后的图像。

请注意，上述示例中的填充方式为常数填充（BorderConstant），并使用零值像素（`gocv.NewScalar(0, 0, 0, 0)`）。你可以根据需求选择不同的填充方式和填充像素。

## Numpy Pad Function

NumPy 中的 `pad` 函数用于对数组进行填充操作，可以在数组的边界或指定位置添加额外的元素。

`np.pad(array, pad_width, mode='constant', **kwargs)`

该函数接受以下参数：

- `array`：需要进行填充操作的数组。
- `pad_width`：用于指定在每个维度上的填充宽度的元组或数组。
- `mode`：填充的方式，默认为 'constant'。
- `**kwargs`：可选参数，用于指定填充的值（当 `mode` 为 'constant' 时）或其他填充模式的参数。

`pad_width` 参数是一个元组或数组，用于指定在每个维度上的填充宽度。对于二维数组来说，`pad_width` 的形式为 `((before_1, after_1), (before_2, after_2), …)`，其中 `(before_i, after_i)` 表示**在第 `i` 维度的前面和后面分别填充的宽度。**

`mode` 参数用于指定填充的方式，常用的取值包括：

- `'constant'`：使用常数填充，默认填充值为 0。
- `'edge'`：使用数组边缘值进行填充。
- `'reflect'`：使用边缘值的镜像进行填充。
- `'symmetric'`：使用边缘值的对称镜像进行填充。

除了以上几种常用的填充方式，还可以通过指定 `mode` 为自定义的填充函数来实现更灵活的填充操作。

填充后的数组将在每个维度的两端添加额外的元素，使数组的维度增加。填充后的数组的形状将为原始数组的形状加上填充宽度。

以下是一个示例，展示了如何使用 `np.pad` 函数对二维数组进行填充：

```python
import numpy as np

# 原始数组
arr = np.array([[1, 2], [3, 4]])

# 在每个维度上填充1个元素
pad_width = ((1, 1), (1, 1))

# 使用常数0进行填充
padded_arr = np.pad(arr, pad_width, mode='constant')

print("原始数组：")
print(arr)
print("填充后的数组：")
print(padded_arr)
```

输出结果为：

```
原始数组：
[[1 2]
 [3 4]]
填充后的数组：
[[0 0 0]
 [0 1 2]
 [0 3 4]
 [0 0 0]]
```

可以看到，填充后的数组在每个维度的两端分别添加了 1 个宽度为 0 的元素。

## gocv.Mat 和 image.Image 之间的转换

```go
func cvtImageToMat(img image.Image) (gocv.Mat, error) {
	bounds := img.Bounds()
	x := bounds.Dx()
	y := bounds.Dy()
	bytes := make([]byte, 0, x*y*3)

	for j := bounds.Min.Y; j < bounds.Max.Y; j++ {
		for i := bounds.Min.X; i < bounds.Max.X; i++ {
			r, g, b, _ := img.At(i, j).RGBA()
			bytes = append(bytes, byte(b>>8), byte(g>>8), byte(r>>8))
		}
	}
	return gocv.NewMatFromBytes(y, x, gocv.MatTypeCV8UC3, bytes)
}
```

- [gocv.Mat类型和image.Image互相转化_cv mat转image_Freestyle Coding的博客-CSDN博客](https://blog.csdn.net/m0_55708805/article/details/116150660)

## gocv.Normalize

在 GoCV 中，`gocv.Normalize` 函数用于将图像数据归一化为特定的范围。该函数的签名如下：

```go
func Normalize(src gocv.Mat, dst *gocv.Mat, alpha, beta float64, normType gocv.NormType, dtype gocv.MatType)
```

参数说明：

- `src`: 输入的源图像，类型为 `gocv.Mat`。
- `dst`: 输出的归一化后的图像，类型为 `*gocv.Mat`。如果为 `nil`，则会创建一个新的 `gocv.Mat` 来保存结果。
- `alpha`: 归一化的缩放因子。
- `beta`: 归一化的偏移量。
- `normType`: 归一化的类型，可以是 `gocv.NormInf`、`gocv.NormL1`、`gocv.NormL2`、`gocv.NormMinMax` 中的一个。
- `dtype`: 输出的归一化图像的数据类型，一般保持与源图像相同。

下面是一个示例代码，展示如何使用 `gocv.Normalize` 函数对图像进行归一化：

```go
package main

import (
	"gocv.io/x/gocv"
)

func main() {
	// 读取图像文件
	img := gocv.IMRead("image.jpg", gocv.IMReadColor)
	if img.Empty() {
		panic("无法读取图像文件")
	}

	// 转换为灰度图像
	gray := gocv.NewMat()
	defer gray.Close()
	gocv.CvtColor(img, &gray, gocv.ColorBGRToGray)

	// 归一化图像
	normalized := gocv.NewMat()
	defer normalized.Close()
	gocv.Normalize(gray, &normalized, 0, 255, gocv.NormMinMax, gocv.MatTypeCV8U)

	// 显示归一化后的图像
	window := gocv.NewWindow("Normalized Image")
	defer window.Close()
	window.IMShow(normalized)
	window.WaitKey(0)
}
```

在上述代码中，我们首先读取一个彩色图像，并将其转换为灰度图像。然后，我们使用 `gocv.Normalize` 函数对灰度图像进行归一化，将像素值范围从 0 到 255 映射到 0 到 255 的整数范围。最后，我们创建一个窗口并显示归一化后的图像。

请确保将代码中的 `"image.jpg"` 替换为实际的图像文件路径和文件名。

## gocv.BlobFromImage

在 GoCV 中，`gocv.BlobFromImage` 函数用于从图像创建一个 4D blob。这个函数通常用于深度学习中的图像预处理，例如输入神经网络之前的图像转换。该函数的签名如下：

```go
func BlobFromImage(src gocv.Mat, scale float64, size image.Point, mean gocv.Scalar, swapRB bool, crop bool) gocv.Mat
```

参数说明：

- `src`: 输入的源图像，类型为 `gocv.Mat`。
- `scale`: 缩放因子，将图像像素值缩放到给定范围。
- `size`: 输出 blob 的大小，作为图像尺寸的目标大小。
- `mean`: 图像的均值，用于像素值的偏移。
- `swapRB`: 是否交换通道顺序。
- `crop`: 是否在中心裁剪图像。

下面是一个示例代码，展示如何使用 `gocv.BlobFromImage` 函数创建一个 4D blob：

```go
package main

import (
	"fmt"
	"gocv.io/x/gocv"
	"image"
)

func main() {
	// 读取图像文件
	img := gocv.IMRead("image.jpg", gocv.IMReadColor)
	if img.Empty() {
		panic("无法读取图像文件")
	}

	// 创建blob
	scale := 1.0 / 255.0
	size := image.Point{300, 300}
	mean := gocv.NewScalar(0, 0, 0, 0)
	swapRB := true
	crop := false
	blob := gocv.BlobFromImage(img, scale, size, mean, swapRB, crop)

	// 输出blob的形状
	shape := blob.Size3D()
	fmt.Println("Blob Shape:", shape)

	// 释放blob内存
	blob.Close()
}
```

在上述代码中，我们首先读取一个彩色图像。然后，我们使用 `gocv.BlobFromImage` 函数创建一个 4D blob，其中我们指定了缩放因子、目标大小、均值、通道交换和裁剪选项。最后，我们输出了 blob 的形状。

请确保将代码中的 `"image.jpg"` 替换为实际的图像文件路径和文件名。

在 GoCV 中，`gocv.BlobFromImage` 函数用于从图像创建一个 4D blob。这个函数通常用于深度学习中的图像预处理，例如输入神经网络之前的图像转换。该函数的签名如下：

```go
func BlobFromImage(src gocv.Mat, scale float64, size image.Point, mean gocv.Scalar, swapRB bool, crop bool) gocv.Mat
```

参数说明：

- `src`: 输入的源图像，类型为 `gocv.Mat`。
- `scale`: 缩放因子，将图像像素值缩放到给定范围。
- `size`: 输出 blob 的大小，作为图像尺寸的目标大小。
- `mean`: 图像的均值，用于像素值的偏移。
- `swapRB`: 是否交换通道顺序。
- `crop`: 是否在中心裁剪图像。

下面是一个示例代码，展示如何使用 `gocv.BlobFromImage` 函数创建一个 4D blob：

```go
package main

import (
	"fmt"
	"gocv.io/x/gocv"
	"image"
)

func main() {
	// 读取图像文件
	img := gocv.IMRead("image.jpg", gocv.IMReadColor)
	if img.Empty() {
		panic("无法读取图像文件")
	}

	// 创建blob
	scale := 1.0 / 255.0
	size := image.Point{300, 300}
	mean := gocv.NewScalar(0, 0, 0, 0)
	swapRB := true
	crop := false
	blob := gocv.BlobFromImage(img, scale, size, mean, swapRB, crop)

	// 输出blob的形状
	shape := blob.Size3D()
	fmt.Println("Blob Shape:", shape)

	// 释放blob内存
	blob.Close()
}
```

在上述代码中，我们首先读取一个彩色图像。然后，我们使用 `gocv.BlobFromImage` 函数创建一个 4D blob，其中我们指定了缩放因子、目标大小、均值、通道交换和裁剪选项。最后，我们输出了 blob 的形状。

请确保将代码中的 `"image.jpg"` 替换为实际的图像文件路径和文件名。

**其中 mean 是偏移量的意思**，我就说一个包中的图片的概念应该是对的少的。
