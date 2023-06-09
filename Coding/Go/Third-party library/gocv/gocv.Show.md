- Time：2023-06-09 09:49
- Label： #gocv #go #image

## Abstract

- 简要介绍 gocv 如何读取图片和显示图片的

## Content

```go
package main

import (
	"fmt"

	"gocv.io/x/gocv"
)

func main() {
	fmt.Println("Starting")
	//构建窗口
	image := gocv.IMRead("test.png", gocv.IMReadColor)

	window := gocv.NewWindow("img")
	window.ResizeWindow(500, 300)

	//在窗口展示图片
	window.IMShow(image)
	window.WaitKey(5000)
	window.Close()
}

```

## Reference

- [gocv图片读取并展示_gocv读取图片_图图是只猫的博客-CSDN博客](https://blog.csdn.net/qq_38929920/article/details/118603566)
