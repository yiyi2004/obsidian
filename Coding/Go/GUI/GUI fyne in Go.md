- Time：2023-07-02 21:00
- Label：

## Abstract

![[Snipaste/Pasted image 20230702210027.png]]

## Content

### Fyne 应用程序结构

- tidy() 函数，在主程序结束之后清理一些临时文件，或者做一些后处理的操作。

### Markdown

![[Snipaste/Pasted image 20230703150751.png]]

```go
package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

type Config struct {
	EditWidget    *widget.Entry
	PreviewWidget *widget.RichText
	CurrentFile   fyne.URI
	SaveMenuItem  *fyne.MenuItem
}

var cfg Config

func main() {
	// create fyne app
	a := app.New()
	// create the window for app
	win := a.NewWindow("Markdown Editor")
	// get the user interface
	edit, preview := cfg.makeUI()
	// set the content for the window
	win.SetContent(container.NewHSplit(edit, preview))
	win.Resize(fyne.NewSize(1000.0, 1000.0))

	// how to set the utf-8 encoding

	// show the window with the app
	win.ShowAndRun()
}

func (app *Config) makeUI() (*widget.Entry, *widget.RichText) {
	edit := widget.NewMultiLineEntry()
	preview := widget.NewRichTextFromMarkdown("")

	app.EditWidget = edit
	app.PreviewWidget = preview

	edit.OnChanged = preview.ParseMarkdown

	return edit, preview
}
```

![[Snipaste/Pasted image 20230705180339.png]]  

- [ ] 解决中文乱码的问题 [Creating a Custom Theme | Develop using Fyne](https://developer.fyne.io/extend/custom-theme)

## Reference

- [2022 Go语言实战课程 用Go Fyne框架快速开发GUI程序课程[用Go开发桌面、移动端程序]_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1uB4y1n7gF/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
