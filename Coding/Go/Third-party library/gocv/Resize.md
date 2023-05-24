`gocv.Resize` 是 GoCV 库中用于调整图像大小的函数。它可以通过指定目标图像的宽度和高度来对输入图像进行缩放。

下面是一个使用 `gocv.Resize` 函数的简单示例：

```go
package main

import (
	"gocv.io/x/gocv"
)

func main() {
	// 打开输入图像文件
	img := gocv.IMRead("input.jpg", gocv.IMReadColor)

	// 检查图像是否成功加载
	if img.Empty() {
		panic("无法加载图像")
	}

	// 定义目标图像大小
	width := 800
	height := 600

	// 调整图像大小
	resized := gocv.NewMat()
	gocv.Resize(img, &resized, image.Point{X: width, Y: height}, 0, 0, gocv.InterpolationDefault)

	// 保存调整后的图像
	gocv.IMWrite("output.jpg", resized)

	// 释放资源
	img.Close()
	resized.Close()
}
```

在这个示例中，我们首先使用 `gocv.IMRead` 函数加载输入图像文件。然后，我们检查图像是否成功加载，如果图像为空，则会抛出错误。接下来，我们定义了目标图像的宽度和高度。

使用 `gocv.Resize` 函数，我们创建了一个新的 `Mat` 对象 `resized`，并将输入图像 `img` 调整为指定的目标大小。`gocv.Resize` 函数的参数依次为：输入图像，调整后的图像，目标大小（以 `image.Point` 类型表示），水平方向和垂直方向的缩放因子（默认为 0），以及插值方法（这里使用默认的插值方法 `gocv.InterpolationDefault`）。

最后，我们使用 `gocv.IMWrite` 函数将调整后的图像保存为输出文件。最后，我们释放了输入图像和调整后的图像对象的资源。

请注意，在运行此示例之前，请确保已正确安装并配置了 GoCV 库，并替换示例中的输入图像文件路径和输出图像文件路径。

#chatgpt #gocv #go
