- Time：2023-06-06 11:02
- Label：

## Abstract

- official tutorial
- 我认为 3 ~ 4 天就能学完，因为事实上，你知道框架是怎么写的就好了，其他的就是查文档，简简单单，需要看一些 demo ---> 然后就可以做

## Content

### QuickStart

#### Update Content

```go
package main

import (
	"time"

	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/widget"
)

func updateTime(clock *widget.Label) {
	formatted := time.Now().Format("Time: 03:04:05")
	clock.SetText(formatted)
}

func main() {
	a := app.New()
	w := a.NewWindow("Clock")

	clock := widget.NewLabel("")
	updateTime(clock)

	w.SetContent(clock)
	go func() {
		for range time.Tick(time.Second) {
			updateTime(clock)
		}
	}()
	w.ShowAndRun()
}
```

#### Window Handling

```go
package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Hello World")

	w.SetContent(widget.NewLabel("Hello World!"))
	w.Show()

	w2 := a.NewWindow("Larger")

	// create new window by click the button
	w2.SetContent(widget.NewButton("Open new", func() {
		w3 := a.NewWindow("Third")
		w3.SetContent(widget.NewLabel("Third"))
		w3.Show()
	}))

	w2.Resize(fyne.NewSize(100, 100))
	w2.Show()

	a.Run()
}
```

#### Unit Testing

We can demonstrate unit testing by extending our [Hello World](https://developer.fyne.io/started/hello) app to include space for users to input their name to be greeted. We start by updating the user interface to have two elements, a `Label` for the greeting and an `Entry` for the name input. We display them, one above another, using `container.NewVBox` (**a vertical box container**). The updated user interface code will look as follows:

```go
func makeUI() (*widget.Label, *widget.Entry) {
	return widget.NewLabel("Hello world!"),
		widget.NewEntry()
}

func main() {
	a := app.New()
	w := a.NewWindow("Hello Person")

	w.SetContent(container.NewVBox(makeUI()))
	w.ShowAndRun()
}


// or

func makeUI() (*widget.Label, *widget.Entry) {
	out := widget.NewLabel("Hello world!")
	in := widget.NewEntry()

	in.OnChanged = func(content string) {
		out.SetText("Hello " + content + "!")
	}
	return out, in
}
```

```go
package main

import (
	"testing"
)

func TestGreeting(t *testing.T) {
	out, in := makeUI()

	if out.Text != "Hello world!" {
		t.Error("Incorrect initial greeting")
	}

	// or
	test.Type(in, "Andy")
	if out.Text != "Hello Andy!" {
		t.Error("Incorrect user greeting")
	}
}
```

#### Packaging

```cmd
go install fyne.io/fyne/v2/cmd/fyne@latest
fyne package -os darwin -icon myapp.png
```

```
fyne package -os linux -icon myapp.png
fyne package -os windows -icon myapp.png
```

#### Mobile Packaging

#### Distribution

#### App Metadata

#### Cross Compiling

### Exploring Fyne

#### Canvas and CanvasObject

```go
package main

import (
	"image/color"
	"time"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/canvas"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Canvas")
	myCanvas := myWindow.Canvas()

	// blue color
	blue := color.NRGBA{R: 0, G: 0, B: 180, A: 255}

	// fill rect with blue color
	rect := canvas.NewRectangle(blue)

	// file canvas with rect
	myCanvas.SetContent(rect)

	go func() {
		time.Sleep(5*time.Second)

		// prepare the green color
		green := color.NRGBA{R: 0, G: 180, B: 0, A: 255}

		// change the rect color
		rect.FillColor = green

		// refresh the rect
		rect.Refresh()
	}()

	myWindow.Resize(fyne.NewSize(100, 100))

	// exit untile close the window
	myWindow.ShowAndRun()
}
```

We can draw many different drawing elements in the same way, such as circle and text.

```go
func setContentToText(c fyne.Canvas) {
	green := color.NRGBA{R: 0, G: 180, B: 0, A: 255}
	text := canvas.NewText("Text", green)
	text.TextStyle.Bold = true
	c.SetContent(text)
}

func setContentToCircle(c fyne.Canvas) {
	red := color.NRGBA{R: 0xff, G: 0x33, B: 0x33, A: 0xff}
	circle := canvas.NewCircle(color.White)
	circle.StrokeWidth = 4
	circle.StrokeColor = red
	c.SetContent(circle)
}
```

##### Widget

A `fyne.Widget` is a special type of canvas object that has interactive elements associated with it. In widgets the logic is separate from the way that it looks (also called the `WidgetRenderer`).

Widgets are also types of `CanvasObject` and so we can set the content of our window to a single widget. See how we create a new `widget.Entry` and set it as the content of the window in this example.

```go
package main

import (
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/widget"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Widget")

	myWindow.SetContent(widget.NewEntry())
	myWindow.ShowAndRun()
}
```

## Reference

- [Window Handling | Develop using Fyne](https://developer.fyne.io/started/windows)
