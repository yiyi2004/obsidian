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

#### Paclaging

#### Mobile Packaging

#### Distribution

#### App Metadata

#### Cross Compiling

## Reference

- [Window Handling | Develop using Fyne](https://developer.fyne.io/started/windows)
