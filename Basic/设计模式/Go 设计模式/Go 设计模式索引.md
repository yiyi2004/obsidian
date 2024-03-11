- Time：2023-06-23 21:14
- Label： #go #设计模式

## Abstract

- 设计模式挺简单的，不要有畏难情绪捏。
- XMind 整理了有那些设计模式，并且标有重点喔。

## Content

![[Snipaste/Pasted image 20230623213512.png]]

## 常用设计模式及例子

Go 语言因其简洁的语法和强大的标准库而受到广泛欢迎。虽然 Go 不是一种面向对象的语言（它不支持类和继承等传统的面向对象特性），但它通过接口（interfaces）、组合（composition）等机制支持了丰富的设计模式。以下是在 Go 语言开发中常用的一些设计模式，以及它们的简要说明和示例：

### 1. 工厂模式（Factory）

工厂模式用于创建对象，特别是当创建对象的过程较为复杂时，如需要进行初始化设置或依赖注入等。在 Go 中，工厂模式通常通过一个工厂函数来实现。

**示例**：

```go
type Animal interface {
    Speak() string
}

type Dog struct{}

func (d Dog) Speak() string {
    return "Woof!"
}

type Cat struct{}

func (c Cat) Speak() string {
    return "Meow"
}

// AnimalFactory 是一个工厂函数，根据参数创建并返回 Animal 类型。
func AnimalFactory(animalType string) Animal {
    switch animalType {
    case "dog":
        return Dog{}
    case "cat":
        return Cat{}
    default:
        return nil
    }
}
```

### 2. 单例模式（Singleton）

单例模式确保一个类只有一个实例，并提供一个全局访问点。在 Go 中，单例通常通过 `sync.Once` 来实现，保证实例化操作仅执行一次。

**示例**：

```go
import "sync"

type singleton struct{}

var instance *singleton
var once sync.Once

func GetInstance() *singleton {
    once.Do(func() {
        instance = &singleton{}
    })
    return instance
}
```

### 3. 观察者模式（Observer）

观察者模式定义了对象之间的一对多依赖，当一个对象改变状态时，其所有依赖者都会收到通知并自动更新。在 Go 中，观察者模式可以通过接口和切片实现。

**示例**：

```go
type Subject struct {
    observers []Observer
}

type Observer interface {
    Notify(string)
}

func (s *Subject) AddObserver(o Observer) {
    s.observers = append(s.observers, o)
}

func (s *Subject) NotifyObservers(msg string) {
    for _, observer := range s.observers {
        observer.Notify(msg)
    }
}

type ConcreteObserver struct {
    ID int
}

func (co *ConcreteObserver) Notify(msg string) {
    fmt.Printf("Observer %d: received %s\n", co.ID, msg)
}
```

### 4. 装饰器模式（Decorator）

装饰器模式允许向一个现有的对象添加新的功能，同时又不改变其结构。这个模式在 Go 的 HTTP 中间件中得到了广泛应用。

**示例**：

```go
type HttpHandler func(w http.ResponseWriter, r *http.Request)

func LoggingDecorator(handler HttpHandler) HttpHandler {
    return func(w http.ResponseWriter, r *http.Request) {
        log.Println("Before executing handler")
        handler(w, r)
        log.Println("After executing handler")
    }
}

func MyHandler(w http.ResponseWriter, r *http.Request) {
    // handler logic
}

func main() {
    http.HandleFunc("/", LoggingDecorator(MyHandler))
    http.ListenAndServe(":8080", nil)
}
```

### 5. 策略模式（Strategy）

策略模式定义了一系列的算法，并将每一个算法封装起来，使它们可以互换。该模式让算法的变化独立于使用算法的客户。在 Go 中，策略模式可以通过接口来实现。

**示例**：

```go
type SortStrategy interface {
    Sort([]int)
}

type BubbleSort struct{}

func (b BubbleSort) Sort(data []int) {
    // 实现冒泡排序
}

type QuickSort struct{}

func (q QuickSort) Sort(data []int) {
    // 实现快速排序
}

func SortData(data []int, strategy SortStrategy) {
    strategy.Sort(data)
}
```

这些设计模式在 Go 语言中的应用展示了 Go 的灵活性和强大功能，即使在不使用传统面向对象编程范式的情况下，也能有效地组织和设计代码。

## Reference

- [Easy搞定Golang设计模式 (yuque.com)](https://www.yuque.com/aceld/lfhu8y/rg6nsf)
- [aceld/EasySJMS: Easy搞定Golang设计模式 (github.com)](https://github.com/aceld/EasySJMS)
