
- Time：2023-06-06 09:46
- Label： #fyne #demo #third-repository #go

## Abstract

这个 demo 里面包含了几乎所有需要用 fyne 涉及 UI 的组件，所以要认真学习捏。

- [ ] 研究整体效果，搞清楚包含哪些部分
- [ ] 研究每个模块是怎么写的

## Content

- container 是用来作为一个整体，一个单元
- 虽然我不知道什么是 tray，它的意思是托盘，比如用来装食物的盘子

### Fyne

### Fyne-demo

### Fyne Setting

### Hello

```go
// Package main loads a very basic Hello World graphical application.
package main

import (
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Hello")

	hello := widget.NewLabel("Hello Fyne!")
	w.SetContent(container.NewVBox(
		hello,
		widget.NewButton("Hi!", func() {
			hello.SetText("Welcome :)")
		}),
	))

	w.ShowAndRun()
}

```

## Reference

- [fyne/cmd at master · fyne-io/fyne (github.com)](https://github.com/fyne-io/fyne/tree/master/cmd)
- [[fyne-old]]
