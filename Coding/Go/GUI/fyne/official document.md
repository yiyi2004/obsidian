- Time：2023-07-07 07:46
- Label： #fyne #gui #go #document

## Abstract

## Content

### Getting Started

#### Updating Content

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
	w2.SetContent(widget.NewLabel("More content"))
	w2.Resize(fyne.NewSize(100, 100))
	w2.Show()

	a.Run()
}
```

```go
	w2.SetContent(widget.NewButton("Open new", func() {
		w3 := a.NewWindow("Third")
		w3.SetContent(widget.NewLabel("Third"))
		w3.Show()
	}))
```

- ShowMaster()

#### Unit Testing

#### Packaging

- [Packaging | Develop using Fyne](https://developer.fyne.io/started/packaging)

### Exploring Fyne

#### Canvas and CanvasObject

In Fyne a `Canvas` is the area within which an application is drawn. Each window has a canvas which you can access with `Window.Canvas()` but usually you will find functions on `Window` that avoid accessing the canvas.

Everything that can be drawn in Fyne is a type of `CanvasObject`. The example here opens a new window and then shows different types of primitive graphical element by setting the content of the window canvas. There are many ways that each type of object can be customised as shown with the text and circle examples.

As well as changing the content shown using `Canvas.SetContent()` it is possible to change the content that is currently visible. If, for example, you change the `FillColour` of a rectangle you can request a refresh of this existing component using `rect.Refresh()`.

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

	blue := color.NRGBA{R: 0, G: 0, B: 180, A: 255}
	rect := canvas.NewRectangle(blue)
	myCanvas.SetContent(rect)

	go func() {
		time.Sleep(time.Second)
		green := color.NRGBA{R: 0, G: 180, B: 0, A: 255}
		rect.FillColor = green
		rect.Refresh()
	}()

	myWindow.Resize(fyne.NewSize(100, 100))
	myWindow.ShowAndRun()
}
```

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
Widg
```

#### Container and Layout

n the previous example we saw how to set a `CanvasObject` to the content of a `Canvas`, but it is not very useful to only show one visual element. To show more than one item we use the `Container` type.

As the `fyne.Container` also is a `fyne.CanvasObject`, we can set it to be the content of a `fyne.Canvas`. In this example we create 3 text objects and then place them in a container using the `container.NewWithoutLayout()` function. As there is no layout set we can move the elements around like you see with `text2.Move()`.

```go
package main

import (
	"image/color"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/canvas"
	"fyne.io/fyne/v2/container"
	//"fyne.io/fyne/v2/layout"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Container")
	green := color.NRGBA{R: 0, G: 180, B: 0, A: 255}

	text1 := canvas.NewText("Hello", green)
	text2 := canvas.NewText("There", green)
	text2.Move(fyne.NewPos(20, 20))
	content := container.NewWithoutLayout(text1, text2)
	// content := container.New(layout.NewGridLayout(2), text1, text2)

	myWindow.SetContent(content)
	myWindow.ShowAndRun()
}
```

A `fyne.Layout` implements a method for organising items within a container. By uncommenting the `container.New()` line in this example you alter the container to use a grid layout with 2 columns. Run this code and try resizing the window to see how the layout automatically configures the contents of the window. Notice also that the manual position of `text2` is ignored by the layout code.

To see more you can check out the [`Layout list`](https://developer.fyne.io/explore/layouts).

#### Widget List

- [Widget List | Develop using Fyne](https://developer.fyne.io/explore/widgets)
- There are three types of widget
	- Standard Widgets
	- Collection Widgets(more complex constructor)
	- Container Widgets

> you will be the GOAT and you are a GOAT

##### Standard Widgets

- [Accordion](https://developer.fyne.io/explore/widgets#accordion) displays a list of AccordionItems. Each item is represented by a button that reveals a detailed view when tapped.
- [Button](https://developer.fyne.io/widget/button) widget has a text label and icon, both are optional.
- [Card](https://developer.fyne.io/explore/widgets#card) widget groups elements with a header and subheader, all are optional.
- [Check](https://developer.fyne.io/explore/widgets#check) widget has a text label and a checked (or unchecked) icon.
- [Entry](https://developer.fyne.io/widget/entry) widget allows simple text to be input when focused.
- FileIcon provides helpful standard icons for various types of file. It displays the type of file as an indicator icon and shows the extension of the file type.
- [Form](https://developer.fyne.io/widget/form) widget is two column grid where each row has a label and a widget (usually an input). The last row of the grid will contain the appropriate form control buttons if any should be shown.
- Hyperlink widget is a text component with appropriate padding and layout. When clicked, the URL opens in your default web browser.
- Icon widget is a basic image component that load’s its resource to match the theme.
- [Label](https://developer.fyne.io/widget/label) widget is a label component with appropriate padding and layout.
- [ProgressBar](https://developer.fyne.io/widget/progressbar) widget creates a horizontal panel that indicates progress. | 进度条 ---> 有用捏
- RadioGroup widget has a list of text labels and radio check icons next to each.
- Select widget has a list of options, with the current one shown, and triggers an event function when clicked.
- Select entry widget adds an editable component to the select widget. Users can select an option or enter their own value.
- Separator widget shows a dividing line between other elements.
- Slider if a widget that can **slide** between two fixed values.
- TextGrid is a monospaced grid of characters. This is designed to be used by a text editor, code preview or terminal emulator.
- [Toolbar](https://developer.fyne.io/widget/toolbar) widget creates a horizontal list of tool buttons.

##### Collection Widgets

Collection widgets provide advanced caching functionality to provide high performance rendering of massive data. This does lead to a **more complex constructor**, but is a good balance for the outcome it enables. Each of these widgets uses a series of callbacks, the minimum set is defined by their constructor function, which includes the data size, the creation of template items that can be re-used and finally the function that applies data to a widget as it is about to be added to the display.

- [List](https://developer.fyne.io/collection/list) provides a high performance vertical scroll of many sub-items.
- [Table](https://developer.fyne.io/collection/table) provides a high performance scrolled two dimensional display of many sub-items.
- [Tree](https://developer.fyne.io/collection/tree) provides a high performance vertical scroll of items that can be expanded to reveal child elements..

##### Container Widgets

- [AppTabs](https://developer.fyne.io/container/apptabs) widget allows switching visible content from a list of TabItems. Each item is represented by a button at the top of the widget.
- ScrollContainer defines a container that is smaller than the Content.
- SplitContainer defines a container whose size is split between two children.

#### Layout List

- [Layout List | Develop using Fyne](https://developer.fyne.io/explore/layouts)

##### Standard Layout

- Horizontal Box arranges items in a horizontal row. Every element will have the same height (the height of the tallest item in the container) and objects will be left-aligned at their minimum width.
- Vertical Box arranges items in a vertical column. Every element will have the same width (the width of the widest item in the container) and objects will be top-aligned at their minimum height.
- Center layout positions all container elements in the center of the container. Every object will be set to it’s minimum size.
- Form layout arranges items in pairs where the first column is at minimum width. This is normally useful for labelling elements in a form, where the label is in the first column and the item it describes is in the second. You should always add an even number of elements to a form layout.
- Grid layout arranges items equally in the available space. A number of columns is specified, with objects being positioned horizontally until the number of columns is reached at which point a new row is started. All objects have the same size, that is width divided by column total and the height will be total height divided by the number of rows required. Minus padding.
- GridWrap layout arranges all items to flow along a row, wrapping to a new row if there is insufficient space. All objects will be set to the same size, which is the size passed to the layout. This layout may not respect item MinSize to manage this uniform layout. Often used in file managers or image thumbnail lists.
- Border layout supports positioning of items at the outside of available space. The border is passed pointers to the objects for (top, left, bottom, right). All items in the container that are not positioned on a border will fill the remaining space.
- Max layout positions all container elements to fill the available space. The objects will all be full-sized and drawn in the order they were added to the container (last-most is on top).
- Padded layout positions all container elements to fill the available space but with a small padding around the outside. The size of the padding is theme specific. The objects will all be drawn in the order they were added to the container (last-most is on top).

##### Conbined Layout

- It is possible to build up more complex application structures by using multiple layouts. Multiple containers that each have their own layout can be nested to create complete user interface arrangements using only the standard layouts listed above. For example a horizontal box for a header, a vertical box for a left side file panel and a grid wrap layout in the content area - all inside a container using **a border layout** can build the result illustrated below.  
![[Snipaste/Pasted image 20230707082835.png]]

事实上，你真的有趣吗？

#### Dialog List

- [Dialog List | Develop using Fyne](https://developer.fyne.io/explore/dialogs)

##### Standard Dialog

- Color Allow users to pick a colour from a standard set (or any color in advanced mode).
- Confirm Ask for conformation of an action.
- FileOpen Present this to ask user to choose a file to use inside the app. The actual dialog displayed will depend on the current operating system.
- Form Get various input elements in a dialog, with **validation**.
- Information A simple way to present some information to the app user.
- Custom Present any content inside a dialog container.

#### Icon List

Each of the following icons is available via the `theme` package as a function. For example `theme.InfoIcon()`.

The icons are also available via their source icon name by using the `ThemeIconName` with the `Icon` method on a struct implementing `fyne.Theme`. For example `theme.Icon(theme.IconNameInfo)`.

- [Theme Icons | Develop using Fyne](https://developer.fyne.io/explore/icons)
- Icons

#### Using other Color Set

Each icon can be used as a source for a particular themed color using the various public helper methods:

- `NewDisabledThemedResource`
- `NewErrorThemedResource`
- `NewInvertedThemedResource`
- `NewPrimaryThemedResource`

By default, all icons adapt to the current theme foreground using `NewThemedResource` which uses the theme foreground color. All Icons are SVG `width="24"`, `height="24"`.

#### Handling Shourtcuts

- Nothing, you can use this at the end of project

#### Using the Preferences API

- Preferences ---> 首选项 | 设置
- [Using the Preferences API | Develop using Fyne](https://developer.fyne.io/explore/preferences)

```go
spackage main

import (
    "time"

    "fyne.io/fyne/v2/app"
    "fyne.io/fyne/v2/widget"
)

func main() {
    a := app.NewWithID("com.example.tutorial.preferences")
    w := a.NewWindow("Timeout")

    var timeout time.Duration

    timeoutSelector := widget.NewSelect([]string{"10 seconds", "30 seconds", "1 minute"}, func(selected string) {
        switch selected {
        case "10 seconds":
            timeout = 10 * time.Second
        case "30 seconds":
            timeout = 30 * time.Second
        case "1 minute":
            timeout = time.Minute
        }

        a.Preferences().SetString("AppTimeout", selected)
    })

    timeoutSelector.SetSelected(a.Preferences().StringWithFallback("AppTimeout", "10 seconds"))

    go func() {
        time.Sleep(timeout)
        a.Quit()
    }()

    w.SetContent(timeoutSelector)
    w.ShowAndRun()
}
```

#### System Tray

- [System Tray Menu | Develop using Fyne](https://developer.fyne.io/explore/systray)

```go
package main

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/driver/desktop"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("SysTray")

	if desk, ok := a.(desktop.App); ok {
		m := fyne.NewMenu("MyApp",
			fyne.NewMenuItem("Show", func() {
				w.Show()
			}))
		desk.SetSystemTrayMenu(m)
	}

	w.SetContent(widget.NewLabel("Fyne System Tray"))
	w.SetCloseIntercept(func() {
		w.Hide()
	})
	w.ShowAndRun()
}
```

#### Data Binding

Data binding was introduced in Fyne v2.0.0 and makes it easier to **connect many widgets to a data source** that will update over time. the `data/binding` package has many helpful bindings that can manage most standard types that will be used in an application. A data binding can be managed using the binding API (for example `NewString`) or it can be connected to an external item of data like (`BindInt(*int)`).

Widgets that support binding typically have a `…WithData` constructor to set up the binding when creating the widget. You can also call `Bind()` and `Unbind()` to manage the data of an existing widget. The following example shows how you can manage a `String` data item that is bound to a simple `Label` widget.

```go
package main

import (
	"time"

	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/data/binding"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Hello")

	str := binding.NewString()
	go func() {
		dots := "....."
		for i := 5; i >= 0; i-- {
			str.Set("Count down" + dots[:i])
			time.Sleep(time.Second)
		}
		str.Set("Blast off!")
	}()

	w.SetContent(widget.NewLabelWithData(str))
	w.ShowAndRun()
}
```

#### Compile Options

- [Compile Options | Develop using Fyne](https://developer.fyne.io/explore/compiling)

### Drawing and Animation

#### Box

As discussed in [Container and Layouts](https://developer.fyne.io/explore/container) elements within a container can be arranged using a layout. This section explores the builtin layouts and how to use them.

The most commonly used layout is `layout.BoxLayout` and it has two variants, horizontal and vertical. A box layout arranges all elements in a single row or column with optional spaces to assist alignment.

A horizontal box layout, created with `layout.NewHBoxLayout()` creates an arrangement of items in a single row. Every item in the box will have its width set to its `MinSize().Width` and the height will be equal for all items, the largest of all the `MinSize().Height` values. The layout can be used in a container or you can use the box widget `widget.NewHBox()`.

A vertical box layout is similar but it arranges items in a column. Each item will have its height set to minimum and all the widths will be equal, set to the largest of the minimum widths.

To create an expanding space between elements (so that some are left aligned and the others right aligned, for example) add a `layout.NewSpacer()` as one of the items. A spacer will expand to fill all available space. Adding a spacer at the beginning of a vertical box layout will cause all items to be bottom aligned. You can add one to the beginning and end of a horizontal arrangement to create a center alignment.

```go
package main

import (
	"image/color"

	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/canvas"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Box Layout")

	text1 := canvas.NewText("Hello", color.White)
	text2 := canvas.NewText("There", color.White)
	text3 := canvas.NewText("(right)", color.White)
	content := container.New(layout.NewHBoxLayout(), text1, text2, layout.NewSpacer(), text3)

	text4 := canvas.NewText("centered", color.White)
	centered := container.New(layout.NewHBoxLayout(), layout.NewSpacer(), text4, layout.NewSpacer())
	myWindow.SetContent(container.New(layout.NewVBoxLayout(), content, centered))
	myWindow.ShowAndRun()
}
```

#### Grid

- now, you are going to learn how to practice you fyne skills, following the tutorial video.

#### Grid Wrap

#### Border

#### Form

#### Center

#### Max

#### AppTabs

### Containers and Layouts

### Widgets

### Collections

### Data Binding

### Extending Fyne

### Architecture

### FAQ

### API Document

## Reference
