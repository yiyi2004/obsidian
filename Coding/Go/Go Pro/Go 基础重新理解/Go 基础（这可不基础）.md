- Time：2023-06-23 19:45
- Label： #go #basic #gopro

## Abstract

抄写 + **高亮** 的模式是可靠的。加油捏。

## Content

### 数组、字符串和切片

- 可以结合 `append` 和 `copy` 函数去避免临时切片的构造

#### 切片内存技巧

```go
func TrimSpace(s []byte) []byte {
    b := s[:0]
    for _, x := range s {
        if x != ' ' {
            b = append(b, x)
        }
    }
    return b
}
```

不需要再分配一块内存地址了，确实实现的非常优雅。

删除切片元素的算法：

```go
func Filter(s []byte, fn func(x byte) bool) []byte {
    b := s[:0]
    for _, x := range s {
        if !fn(x) {
            b = append(b, x)
        }
    }
    return b
}
```

优雅！实在是太优雅辣！

切片高效操作的要点是要降低内存分配的次数，尽量保证 `append` 操作不会超出 `cap` 的容量，降低触发内存分配的次数和每次分配内存大小。

#### 避免切片内存泄漏

```go
func FindPhoneNumber(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    return regexp.MustCompile("[0-9]+").Find(b)
}
```

这段代码返回的 `[]byte` 指向保存整个文件的数组。因为切片引用了整个原始数组，导致自动垃圾回收器不能及时释放底层数组的空间。一个小的需求可能导致需要长时间保存整个文件数据。这虽然这并不是传统意义上的内存泄漏，但是可能会拖慢系统的整体性能。

要修复这个问题，可以将感兴趣的数据复制到一个新的切片中（**数据的传值是 Go 语言编程的一个哲学**，虽然传值有一定的代价，但是换取的好处是切断了对原始数据的依赖）：

```go
func FindPhoneNumber(filename string) []byte {
    b, _ := ioutil.ReadFile(filename)
    b = regexp.MustCompile("[0-9]+").Find(b)
    return append([]byte{}, b...)
}

// 也可以通过 copy 实现，但是我估计底层也是这样实现的
```

删除导致 GC 操作被阻碍

```go
var a []*int{ ... }
a = a[:len(a)-1]    // 被删除的最后一个元素依然被引用, 可能导致 GC 操作被阻碍
```

```go
var a []*int{ ... }
a[len(a)-1] = nil // GC 回收最后一个元素内存
a = a[:len(a)-1]  // 从切片删除最后一个元素
```

#### 切片类型的强制类型转换

为了安全，当两个切片类型 `[]T` 和 `[]Y` 的底层原始切片类型不同时，Go 语言是无法直接转换类型的。不过安全都是有一定代价的，有时候这种转换是有它的价值的——可以简化编码或者是提升代码的性能。比如在 64 位系统上，需要对一个 `[]float64` 切片进行高速排序，我们可以将它强制转为 `[]int` 整数切片，然后以整数的方式进行排序（因为 `float64` 遵循 IEEE754 浮点数标准特性，当浮点数有序时对应的整数也必然是有序的）。

下面的代码通过两种方法将 `[]float64` 类型的切片转换为 `[]int` 类型的切片：

```go
// +build amd64 arm64

import "sort"

var a = []float64{4, 2, 5, 7, 2, 1, 88, 1}

func SortFloat64FastV1(a []float64) {
    // 强制类型转换
    var b []int = ((*[1 << 20]int)(unsafe.Pointer(&a[0])))[:len(a):cap(a)]

    // 以 int 方式给 float64 排序
    sort.Ints(b)
}

func SortFloat64FastV2(a []float64) {
    // 通过 reflect.SliceHeader 更新切片头部信息实现转换
    var c []int
    aHdr := (*reflect.SliceHeader)(unsafe.Pointer(&a))
    cHdr := (*reflect.SliceHeader)(unsafe.Pointer(&c))
    *cHdr = *aHdr

    // 以 int 方式给 float64 排序
    sort.Ints(c)
}
```

第一种强制转换是先将切片数据的开始地址转换为一个较大的数组的指针，然后对数组指针对应的数组重新做切片操作。中间需要 `unsafe.Pointer` 来连接两个不同类型的指针传递。需要注意的是，Go 语言实现中非 0 大小数组的长度不得超过 2GB，因此需要针对数组元素的类型大小计算数组的最大长度范围（`[]uint8` 最大 2GB，`[]uint16` 最大 1GB，以此类推，但是 `[]struct{}` 数组的长度可以超过 2GB）。

第二种转换操作是分别取到两个不同类型的切片头信息指针，任何类型的切片头部信息底层都是对应 `reflect.SliceHeader` 结构，然后通过更新结构体方式来更新切片信息，从而实现 `a` 对应的 `[]float64` 切片到 `c` 对应的 `[]int` 类型切片的转换。

通过基准测试，我们可以发现用 `sort.Ints` 对转换后的 `[]int` 排序的性能要比用 `sort.Float64s` 排序的性能好一点。不过需要注意的是，这个方法可行的前提是要保证 `[]float64` 中没有 NaN 和 Inf 等非规范的浮点数（因为浮点数中 NaN 不可排序，正 0 和负 0 相等，但是整数中没有这类情形）。

### 函数、方法和接口

函数对应操作序列，是程序的基本组成元素。Go 语言中的函数有具名和匿名之分：具名函数一般对应于包级的函数，是匿名函数的一种特例，当匿名函数引用了外部作用域中的变量时就成了闭包函数，**闭包函数是函数式编程语言的核心**。方法是绑定到一个具体类型的特殊函数，Go 语言中的方法是依托于类型的，**必须在编译时静态绑定**。接口定义了方法的集合，**这些方法依托于运行时的接口对象**，因此接口对应的方法是在运行时**动态绑定**的。Go 语言通过隐式接口机制实现了**鸭子面向对象模型**。

> #chatgpt  
> "Go 语言中的方法是依托于类型的，必须在编译时静态绑定 " 这句话的意思是在 Go 语言中，方法与类型是紧密关联的，并且在编译时进行静态绑定。
> 
> 在 Go 语言中，方法是与特定类型关联的函数。方法可以在类型的定义中声明，然后通过该类型的实例调用。方法可以访问类型的数据，并对其进行操作。与函数不同，方法必须在类型的定义所在的包中定义。
> 
> 静态绑定意味着在编译时确定方法的调用。在调用方法时，编译器会根据方法所属的类型进行静态分派，找到适合的方法进行调用。这个过程是在编译阶段完成的，因此在运行时不会出现动态绑定的情况。
> 
> 因此，当你在 Go 语言中调用方法时，编译器会根据方法的接收者类型进行静态绑定，将方法与类型进行关联，并生成相应的调用代码。这种静态绑定的特性使得 Go 语言在性能上有一定的优势，并且保证了方法调用的可预测性和稳定性。

什么是静态的，什么又是运行时的。—— 这部分应该是属于编译原理部分的内容。

![[Snipaste/Pasted image 20230627104741.png]]

上图描述了 Go init 的是如何工作的，init() 函数是特殊的，多个 init() 函数会顺序调用。

#### 函数

闭包对捕获的外部变量并不是传值方式访问，而是以**引用**的方式访问。所以为什么会这样呢？

Go 语言函数的递归调用深度逻辑上没有限制，函数调用的栈是不会出现溢出错误的，因为 Go 语言运行时会根据需要动态地调整函数栈的大小。

```go
func twice(x []int) {
    for i := range x {
        x[i] *= 2
    }
}

type IntSliceHeader struct {
    Data []int
    Len  int
    Cap  int
}

func twice(x IntSliceHeader) {
    for i := 0; i < x.Len; i++ {
        x.Data[i] *= 2
    }
}
```

因为切片中的底层数组部分是通过隐式指针传递 (指针本身依然是传值的，但是指针指向的却是同一份的数据)，所以被调用函数是可以通过指针修改掉调用参数切片中的数据。除了数据之外，切片结构还包含了切片长度和切片容量信息，这 2 个信息也是传值的。如果被调用函数中修改了 `Len` 或 `Cap` 信息的话，就无法反映到调用参数的切片中，这时候我们一般会通过返回修改后的切片来更新之前的切片。这也是为何内置的 `append` 必须要返回一个切片的原因。

Go 语言中，函数还可以直接或间接地调用自己，也就是支持递归调用。Go 语言函数的递归调用深度逻辑上没有限制，函数调用的栈是不会出现溢出错误的，因为 Go 语言运行时会根据需要动态地调整函数栈的大小。每个 goroutine 刚启动时只会分配很小的栈（4 或 8KB，具体依赖实现），根据需要动态调整栈的大小，栈最大可以达到 GB 级（依赖具体实现，在目前的实现中，32 位体系结构为 250MB，64 位体系结构为 1GB）。在 Go1.4 以前，Go 的动态栈采用的是**分段式的动态栈**，通俗地说就是采用一个**链表**来实现动态栈，每个链表的节点内存位置不会发生变化。但是链表实现的动态栈对某些导致跨越链表不同节点的热点调用的性能影响较大，因为相邻的链表节点它们在内存位置一般不是相邻的，这会增加 **CPU 高速缓存命中失败的几率**。为了解决热点调用的 CPU 缓存命中率问题，Go1.4 之后改用连续的动态栈实现，也就是采用一个类似**动态数组的结构**来表示栈。不过连续动态栈也带来了新的问题：当连续栈动态增长时，需要将之前的数据移动到新的内存空间，这会导致之前栈中**全部变量的地址发生变化**。虽然 Go 语言运行时会自动更新引用了地址变化的栈变量的指针，但最重要的一点是要明白 **Go 语言中指针不再是固定不变**的了（因此不能随意将指针保持到数值变量中，Go 语言的地址也不能随意保存到不在 GC 控制的环境中，因此使用 CGO 时不能在 C 语言中长期持有 Go 语言对象的地址）。

因为，Go 语言函数的栈会自动调整大小，所以普通 Go 程序员已经很少需要关心栈的运行机制的。在 Go 语言规范中甚至故意没有讲到栈和堆的概念。我们无法知道函数参数或局部变量到底是保存在栈中还是堆中，我们只需要知道它们能够正常工作就可以了。看看下面这个例子：

```go
func f(x int) *int {
    return &x
}

func g() int {
    x := new(int)
    return *x
}
```

第一个函数直接返回了函数参数变量的地址——这似乎是不可以的，因为如果参数变量在栈上的话，函数返回之后栈变量就失效了，返回的地址自然也应该失效了。但是 Go 语言的编译器和运行时比我们聪明的多，它会保证指针指向的变量在合适的地方。第二个函数，内部虽然调用 `new` 函数创建了 `*int` 类型的指针对象，但是依然不知道它具体保存在哪里。对于有 C/C++ 编程经验的程序员需要强调的是：不用关心 Go 语言中函数栈和堆的问题，编译器和运行时会帮我们搞定；同样不要假设变量在内存中的位置是固定不变的，指针随时可能会变化，特别是在你不期望它变化的时候。

> 我感觉可以从里面学习到很多的知识捏

#### 方法

> 方法一般是面向对象编程 (OOP) 的一个特性，**在 C++ 语言中方法对应一个类对象的成员函数**，是关联到具体对象上的虚表中的。但是 Go 语言的方法却是关联到类型的，这样可以在编译阶段完成方法的静态绑定。一个面向对象的程序会用方法来表达其属性对应的操作，这样使用这个对象的用户就不需要直接去操作对象，而是借助方法来做这些事情。面向对象编程进入主流开发领域一般认为是从 C++ 开始的，C++ 就是在兼容 C 语言的基础之上支持了 class 等面向对象的特性。然后 Java 编程则号称是纯粹的面向对象语言，因为 Java 中函数是不能独立存在的，每个函数都必然是属于某个类的。

C File 包的面向对象思想

```c
// 文件对象
type File struct {
    fd int
}

// 打开文件
func OpenFile(name string) (f *File, err error) {
    // ...
}

// 关闭文件
func CloseFile(f *File) error {
    // ...
}

// 读文件数据
func ReadFile(f *File, offset int64, data []byte) int {
    // ...
}
```

将第一个函数参数移动到函数前面，从代码角度看虽然只是一个小的改动，但是从编程哲学角度来看，Go 语言已经是进入面向对象语言的行列了。**我们可以给任何自定义类型添加一个或多个方法。每种类型对应的方法必须和类型的定义在同一个包中，因此是无法给 `int` 这类内置类型添加方法的**（因为方法的定义和类型的定义不在一个包中）。对于给定的类型，每个方法的名字必须是唯一的，同时方法和函数一样也不支持重载。

Go 语言不支持传统面向对象中的继承特性，而是以自己特有的**组合方式**支持了**方法的继承**。Go 语言中，通过在结构体内置匿名的成员来实现继承：

```go
import "image/color"

type Point struct{ X, Y float64 }

type ColoredPoint struct {
    Point
    Color color.RGBA
}
```

通过嵌入匿名的成员，我们不仅可以继承匿名成员的内部成员，而且可以继承匿名成员类型所对应的方法。我们一般会将 Point 看作基类，把 ColoredPoint 看作是它的继承类或子类。不过这种方式继承的方法并**不能实现 C++ 中虚函数的多态特性**。所有继承来的方法的接收者参数依然是那个匿名成员本身，而不是当前的变量。

`Cache` 结构体类型通过嵌入一个匿名的 `sync.Mutex` 来继承它的 `Lock` 和 `Unlock` 方法. 但是在调用 `p.Lock()` 和 `p.Unlock()` 时, `p` 并不是 `Lock` 和 `Unlock` 方法的真正接收者, 而是会将它们展开为 `p.Mutex.Lock()` 和 `p.Mutex.Unlock()` 调用. 这种展开是**编译期完成的, 并没有运行时代价**.

> 这和 docker 中镜像和容器的概念是对应的，一个是静态概念，一个是动态的概念

在传统的面向对象语言（eg.C++ 或 Java）的继承中，**子类的方法是在运行时动态绑定到对象的**，因此基类实现的某些方法看到的 `this` 可能不是基类类型对应的对象，**这个特性会导致基类方法运行的不确定性**。而在 Go 语言通过嵌入匿名的成员来“继承”的基类方法，`this` 就是**实现该方法的类型的对象**，Go 语言中方法是**编译时静态绑定**的。如果需要**虚函数的多态特性**，我们需要借助 Go 语言**接口**来实现。

#### 接口

> Go 语言之父 _Rob Pike_ 曾说过一句名言：那些试图避免白痴行为的语言最终自己变成了白痴语言（Languages that try to disallow idiocy become themselves idiotic）。

Go 的接口类型是对其它类型行为的抽象和概括；因为接口类型不会和特定的实现细节绑定在一起，通过这种抽象的方式我们可以让对象更加灵活和更具有适应能力。很多面向对象的语言都有相似的接口概念，但 Go 语言中接口类型的独特之处在于它是满足隐式实现的鸭子类型。**所谓鸭子类型说的是**：只要走起路来像鸭子、叫起来也像鸭子，那么就可以把它当作鸭子。Go 语言中的面向对象就是如此，如果一个对象只要看起来像是某种接口类型的实现，那么它就可以作为该接口类型使用。**这种设计可以让你创建一个新的接口类型满足已经存在的具体类型却不用去破坏这些类型原有的定义**；当我们使用的类型来自于不受我们控制的包时这种设计尤其灵活有用。Go 语言的接口类型是**延迟绑定**，可以实现类似虚函数的多态功能。—— 不需要过早的抽象。

接口在 Go 语言中无处不在，在“Hello world”的例子中，`fmt.Printf` 函数的设计就是完全基于接口的，它的真正功能由 `fmt.Fprintf` 函数完成。用于表示错误的 `error` 类型更是内置的接口类型。在 C 语言中，`printf` 只能将几种有限的基础数据类型打印到文件对象中。但是 Go 语言灵活接口特性，`fmt.Fprintf` 却可以向任何自定义的输出流对象打印，可以打印到文件或标准输出、也可以打印到网络、甚至可以打印到一个压缩文件；同时，打印的数据也不仅仅局限于语言内置的基础类型，任意隐式满足 `fmt.Stringer` 接口的对象都可以打印，不满足 `fmt.Stringer` 接口的依然可以通过反射的技术打印。`fmt.Fprintf` 函数的签名如下：

> 我只能说，这里面的每段内容都在给我震撼。

```go
func Fprintf(w io.Writer, format string, args ...interface{}) (int, error)
```

其中 `io.Writer` 用于输出的接口，`error` 是内置的错误接口，它们的定义如下：

```go
type io.Writer interface {
    Write(p []byte) (n int, err error)
}

type error interface {
    Error() string
}
```

我们可以通过定制自己的输出对象，将每个字符转为大写字符后输出：

```go
type UpperWriter struct {
    io.Writer
}

// io.Writer 接口底层有实现对象
func (p *UpperWriter) Write(data []byte) (n int, err error) {
    return p.Writer.Write(bytes.ToUpper(data))
}

func main() {
    fmt.Fprintln(&UpperWriter{os.Stdout}, "hello, world")
}
```

当然，我们也可以定义自己的打印格式来实现将每个字符转为大写字符后输出的效果。对于每个要打印的对象，如果满足了 `fmt.Stringer` 接口，则默认使用对象的 `String` 方法返回的结果打印：

```go
type UpperString string

func (s UpperString) String() string {
    return strings.ToUpper(string(s))
}

type fmt.Stringer interface {
    String() string
}

func main() {
    fmt.Fprintln(os.Stdout, UpperString("hello, world"))
}
```

Go 语言中，对于基础类型（非接口类型）**不支持隐式的转换**，我们无法将一个 `int` 类型的值直接赋值给 `int64` 类型的变量，也无法将 `int` 类型的值赋值给底层是 `int` 类型的新定义命名类型的变量。Go 语言对**基础类型**的类型一致性要求可谓是**非常的严格**，但是 Go 语言对于**接口类型**的转换则**非常的灵活**。  

对象和接口之间的转换、接口和接口之间的转换都可能是隐式的转换。可以看下面的例子：

接口和对象之间的转换是灵活的。

```go
var (
    a io.ReadCloser = (*os.File)(f) // 隐式转换, *os.File 满足 io.ReadCloser 接口
    b io.Reader     = a             // 隐式转换, io.ReadCloser 满足 io.Reader 接口
    c io.Closer     = a             // 隐式转换, io.ReadCloser 满足 io.Closer 接口
    d io.Reader     = c.(io.Reader) // 显式转换, io.Closer 不满足 io.Reader 接口
)
```

有时候对象和接口之间太灵活了，导致我们需要人为地限制这种**无意之间的适配**。常见的做法是定义一个含**特殊方法**来区分接口。比如 `runtime` 包中的 `Error` 接口就定义了一个特有的 `RuntimeError` 方法，用于避免其它类型无意中适配了该接口：

```go
type runtime.Error interface {
    error

    // RuntimeError is a no-op function but
    // serves to distinguish types that are run time
    // errors from ordinary errors: a type is a
    // run time error if it has a RuntimeError method.
    RuntimeError()
}
```

在 protobuf 中，`Message` 接口也采用了类似的方法，也定义了一个特有的 `ProtoMessage`，用于避免其它类型无意中适配了该接口：

```go
type proto.Message interface {
    Reset()
    String() string
    ProtoMessage()
}
```

> 因为这上面介绍了 proto.Message 接口中有一个 ProtoMessage 方法，那你为什么不直接复制粘贴过来呢？

不过这种做法只是君子协定，如果有人刻意伪造一个 `proto.Message` 接口也是很容易的。再严格一点的做法是给接口定义一个私有方法。只有满足了这个**私有方法**的对象才可能满足这个接口，**而私有方法的名字是包含包的绝对路径名的**，因此只能在包内部实现这个私有方法才能满足这个接口。测试包中的 `testing.TB` 接口就是采用类似的技术：

> 我推测应该是编译的时候会将私有方法的变量名替换成“绝对路径 + 私有方法名”。这样是有效实现的。

```go
type testing.TB interface {
    Error(args ...interface{})
    Errorf(format string, args ...interface{})
    ...

    // A private method to prevent users implementing the
    // interface and so future additions to it will not
    // violate Go 1 compatibility.
    private()
}
```

不过这种通过私有方法禁止外部对象实现接口的做法也是有代价的：首先是这个接口只能**包内部使用**，外部包正常情况下是无法直接创建满足该接口对象的；其次，这种**防护措施也不是绝对的**，恶意的用户依然可以绕过这种保护机制。

在前面的方法一节中我们讲到，通过在结构体中嵌入匿名类型成员，可以继承匿名类型的方法。其实这个被嵌入的匿名成员不一定是普通类型，也可以是接口类型。我们可以通过嵌入匿名的 `testing.TB` 接口来伪造私有的 `private` 方法，因为接口方法是延迟绑定，编译时 `private` 方法是否真的存在并不重要。

```go
package main

import (
    "fmt"
    "testing"
)

type TB struct {
    testing.TB
}

func (p *TB) Fatal(args ...interface{}) {
    fmt.Println("TB.Fatal disabled!")
}

func main() {
    var tb testing.TB = new(TB)
    tb.Fatal("Hello, playground")
}
```

这段代码的输出是：

```text
TB.Fatal disabled!
```

我们在自己的 `TB` 结构体类型中重新实现了 `Fatal` 方法，然后通过将对象隐式转换为 `testing.TB` 接口类型（因为内嵌了匿名的 `testing.TB` 对象，因此是满足 `testing.TB` 接口的），然后通过 `testing.TB` 接口来调用我们自己的 `Fatal` 方法。

> 那么这样实现到底有什么意义呢？—— 意义在于可以用于在外部实现这种接口，用在其他地方。

这种通过嵌入匿名接口或嵌入匿名指针对象来实现继承的做法其实是一种**纯虚继承**，我们继承的只是接口指定的规范，真正的实现在运行的时候才被注入。比如，我们可以模拟实现一个 gRPC 的插件：

```go
type grpcPlugin struct {
    *generator.Generator
}

func (p *grpcPlugin) Name() string { return "grpc" }

func (p *grpcPlugin) Init(g *generator.Generator) {
    p.Generator = g
}

func (p *grpcPlugin) GenerateImports(file *generator.FileDescriptor) {
    if len(file.Service) == 0 {
        return
    }

    p.P(`import "google.golang.org/grpc"`)
    // ...
}
```

构造的 `grpcPlugin` 类型对象必须满足 `generate.Plugin` 接口（在 "github.com/golang/protobuf/protoc-gen-go/generator" 包中）：

```go
type Plugin interface {
    // Name identifies the plugin.
    Name() string
    // Init is called once after data structures are built but before
    // code generation begins.
    Init(g *Generator)
    // Generate produces the code generated by the plugin for this file,
    // except for the imports, by calling the generator's methods
    // P, In, and Out.
    Generate(file *FileDescriptor)
    // GenerateImports produces the import declarations for this file.
    // It is called after Generate.
    GenerateImports(file *FileDescriptor)
}
```

`generate.Plugin` 接口对应的 `grpcPlugin` 类型的 `GenerateImports` 方法中使用的 `p.P(…)` 函数却是通过 `Init` 函数注入的 `generator.Generator` 对象实现。这里的 `generator.Generator` 对应一个**具体类型**，但是如果 `generator.Generator` 是**接口类型**的话我们甚至可以**传入直接的实现**。

Go 语言通过几种简单特性的组合，就轻易就实现了鸭子面向对象和虚拟继承等高级特性，真的是不可思议。

### 面向并发的内存模型

这部分内容还需要和并发模型进行对比。我只能说，完全一致的。

#### Goroutine 和系统线程

#### 原子操作

#### 顺序一致性内存模型

#### 初始化的顺序

#### Goroutine 的创建

#### 基于 Channel 的通信

#### 不靠谱的同步

有时候真的能当人而让嘛？

## Reference
