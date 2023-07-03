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

常见的并行编程有多种模型，主要有**多线程、消息传递**等。从理论上来看，多线程和基于消息的并发编程是等价的。由于多线程并发模型可以自然对应到多核的处理器，主流的操作系统因此也都提供了系统级的多线程支持，同时从概念上讲多线程似乎也更直观，因此多线程编程模型逐步被吸纳到主流的编程语言特性或语言扩展库中。而主流编程语言对基于消息的并发编程模型支持则相比较少，**Erlang** 语言是支持基于消息传递并发编程模型的代表者，它的并发体之间不共享内存。Go 语言是**基于消息并发模型的集大成者**，它将基于 **CSP 模型**的并发编程内置到了语言中，通过一个 go 关键字就可以轻易地启动一个 Goroutine，**与 Erlang 不同的是 Go 语言的 Goroutine 之间是共享内存的**。

> 在实际生产环境中是否会使用原生的 goroutine 呢？这要画上一个问号，因为并发是不好控制的，context 或者对 goroutine 进行一定的封装是有效的解决方案，这部分还需要深入了解和讨论。

#### Goroutine 和系统线程

Goroutine 是 Go 语言特有的**并发体**，是一种轻量级的线程，由 go 关键字启动。在真实的 Go 语言的实现中，**goroutine 和系统线程也不是等价的**。尽管两者的**区别实际上只是一个量的区别**，但正是这个**量**变引发了 Go 语言**并发编程质的飞跃**。

首先，每个系统级线程都会有一个固定大小的栈（一般默认可能是 2MB），这个栈主要用来保存函数递归调用时参数和局部变量。固定了栈的大小导致了两个问题：一是对于很多只需要很小的栈空间的线程来说是一个巨大的浪费，二是对于少数需要巨大栈空间的线程来说又面临栈溢出的风险。针对这两个问题的解决方案是：要么降低固定的栈大小，提升空间的利用率；要么增大栈的大小以允许更深的函数递归调用，但这两者是没法同时兼得的。相反，一个 Goroutine 会以一个很小的栈启动（可能是 2KB 或 4KB），当遇到深度递归导致当前栈空间不足时，Goroutine 会根据需要**动态地伸缩栈**的大小（主流实现中栈的最大值可达到 1GB）。因为启动的代价很小，所以我们可以轻易地启动成千上万个 Goroutine。

Go 的**运行时还包含了其自己的调度器**，这个调度器使用了一些技术手段，可以在 n 个操作系统线程上多工调度 m 个 Goroutine。Go 调度器的工作和内核的调度是相似的，但是这个调度器只关注单独的 Go 程序中的 Goroutine。Goroutine 采用的是**半抢占式的协作调度**，只有在当前 **Goroutine 发生阻塞时**才会导致调度；同时发生在用户态，调度器会根据具体函数只保存必要的寄存器，切换的代价要比系统线程低得多。运行时有一个 **`runtime.GOMAXPROCS`** 变量，用于控制当前运行正常非阻塞 Goroutine 的系统线程数目。

> 也就是说：
> 1. 可以通过 runtime 包自行的调度 goroutine，这是一个好消息，因为可以通过 setMemroy 等操作对 goroutine 的资源使用进行限制。

在 Go 语言中启动一个 Goroutine 不仅和调用函数一样简单，而且 Goroutine 之间调度代价也很低，这些因素极大地促进了并发编程的流行和发展。

#### 原子操作

所谓的原子操作就是并发编程中“**最小的且不可并行化**”的操作。通常，如果多个并发体对同一个共享资源进行的操作是原子的话，那么同一时刻最多只能有一个并发体对该资源进行操作。从线程角度看，在当前线程修改共享资源期间，其它的线程是不能访问该资源的。原子操作对于多线程并发编程模型来说，不会发生有别于单线程的意外情况，共享资源的完整性可以得到保证。

一般情况下，原子操作都是通过“**互斥**”访问来保证的，通常由**特殊的 CPU 指令**提供保护。当然，如果仅仅是想模拟下粗粒度的原子操作，我们可以借助于 `sync.Mutex` 来实现。

用互斥锁来保护一个数值型的共享资源，麻烦且效率低下。标准库的 **`sync/atomic`** 包对原子操作提供了丰富的支持。我们可以重新实现上面的例子：

```go
import (
    "sync"
    "sync/atomic"
)

var total uint64

func worker(wg *sync.WaitGroup) {
    defer wg.Done()

    var i uint64
    for i = 0; i <= 100; i++ {
	    // atomic 提供的原子操作
        atomic.AddUint64(&total, i)
    }
}

func main() {
    var wg sync.WaitGroup
    wg.Add(2)

    go worker(&wg)
    go worker(&wg)
    wg.Wait()
}
```

`atomic.AddUint64` 函数调用保证了 `total` 的读取、更新和保存是一个原子操作，因此在多线程中访问也是安全的。

原子操作配合互斥锁可以实现非常高效的**单件模式**。互斥锁的代价比普通整数的原子读写高很多，在性能敏感的地方可以增加一个数字型的标志位，通过原子检测标志位状态降低互斥锁的使用次数来提高性能。

```go
type singleton struct {}

var (
    instance    *singleton
    initialized uint32
    mu          sync.Mutex
)

func Instance() *singleton {
    if atomic.LoadUint32(&initialized) == 1 {
        return instance
    }

    mu.Lock()
    defer mu.Unlock()

    if instance == nil {
        defer atomic.StoreUint32(&initialized, 1)
        instance = &singleton{}
    }
    return instance
}
```

我们可以将通用的代码提取出来，就成了标准库中 `sync.Once` 的实现：

```go
type Once struct {
    m    Mutex
    done uint32
}

func (o *Once) Do(f func()) {
    if atomic.LoadUint32(&o.done) == 1 {
        return
    }

    o.m.Lock()
    defer o.m.Unlock()

    if o.done == 0 {
        defer atomic.StoreUint32(&o.done, 1)
        f()
    }
}
```

基于 `sync.Once` 重新实现单件模式（单件模式就是单例模式叭）：

```go
var (
    instance *singleton
    once     sync.Once
)

func Instance() *singleton {
    once.Do(func() {
        instance = &singleton{}
    })
    return instance
}
```

`sync/atomic` 包对基本的数值类型及复杂对象的读写都提供了原子操作的支持。`atomic.Value` 原子对象提供了 `Load` 和 `Store` 两个原子方法，分别用于加载和保存数据，返回值和参数都是 `interface{}` 类型，**因此可以用于任意的自定义复杂类型**。

```go
var config atomic.Value // 保存当前配置信息

// 初始化配置信息
config.Store(loadConfig())

// 启动一个后台线程, 加载更新后的配置信息
go func() {
    for {
        time.Sleep(time.Second)
        config.Store(loadConfig())
    }
}()

// 用于处理请求的工作者线程始终采用最新的配置信息
for i := 0; i < 10; i++ {
    go func() {
        for r := range requests() {
            c := config.Load()
            // ...
        }
    }()
}
```

> 以上实现了静态资源的动态更新，上面演示的是对配置文件的实时动态加载。但是我不清楚后台线程锁占资源是多少。

这是一个简化的生产者消费者模型：后台线程生成最新的配置信息；前台多个工作者线程获取最新的配置信息。所有线程共享配置信息资源。

#### 顺序一致性内存模型

#chatgpt

```text
顺序一致性内存模型是一种对并发程序中内存访问的行为进行定义和规范的模型。它确保多线程或多处理器系统中的内存操作表现出一种“看起来像是按照程序顺序执行”的行为。

在顺序一致性内存模型下，所有线程或处理器看到的内存操作顺序都与全局的执行顺序一致。也就是说，多个线程或处理器之间的内存操作不能发生重排序或乱序执行。

这意味着，对共享变量的读写操作在各个线程之间都具有全局的顺序一致性。例如，如果一个线程在写入共享变量后，另一个线程在读取该变量，那么第二个线程将看到第一个线程的写入结果。

顺序一致性内存模型为并发程序提供了一种简化的视图，因为程序员可以将内存操作的行为视为按照编写的程序顺序执行。这种模型简化了并发程序的开发和调试过程，并避免了一些常见的并发问题，如数据竞争和乱序执行的结果不确定性。

需要注意的是，并发环境中的实际硬件执行可能会采用更强或更弱的内存模型，因此在编写并发程序时，仍然需要考虑和处理内存一致性的问题。
```

如果只是想简单地在线程之间进行数据同步的话，原子操作已经为编程人员提供了一些同步保障。不过这种保障有一个前提：**顺序一致性的内存模型**。要了解顺序一致性，我们先看看一个简单的例子：

```go
var a string
var done bool

func setup() {
    a = "hello, world"
    done = true
}

func main() {
    go setup()
    for !done {}
    print(a)
}
```

我们创建了 `setup` 线程，用于对字符串 `a` 的初始化工作，初始化完成之后设置 `done` 标志为 `true`。`main` 函数所在的主线程中，通过 `for !done {}` 检测 `done` 变为 `true` 时，认为字符串初始化工作完成，然后进行字符串的打印工作。

但是 Go 语言**并不保证**在 `main` 函数中观测到的对 `done` 的写入操作发生在对字符串 `a` 的写入的操作之后，因此程序很可能打印一个空字符串。更糟糕的是，因为两个线程之间**没有同步事件**，`setup` 线程对 `done` 的写入操作甚至无法被 `main` 线程看到，`main` 函数有可能**陷入死循环中**。

在 Go 语言中，同一个 Goroutine 线程内部，顺序一致性内存模型是得到保证的。但是不同的 Goroutine 之间，并不满足顺序一致性内存模型，需要通过明确定义的同步事件来作为同步的参考。如果两个事件不可排序，那么就说这两个事件是并发的。为了最大化并行，Go 语言的**编译器和处理器**在不影响上述规定的前提下可能会对执行语句**重新排序**（CPU 也会对一些指令进行乱序执行）。

因此，如果在一个 Goroutine 中顺序执行 `a = 1; b = 2;` 两个语句，虽然在当前的 Goroutine 中可以认为 `a = 1;` 语句先于 `b = 2;` 语句执行，但是在另一个 Goroutine 中 `b = 2;` 语句可能会先于 `a = 1;` 语句执行，甚至在另一个 Goroutine 中无法看到它们的变化（**可能始终在寄存器中**）。也就是说在另一个 Goroutine 看来, `a = 1; b = 2;` 两个语句的执行顺序是不确定的。如果一个并发程序无法确定事件的顺序关系，那么程序的运行结果往往会有不确定的结果。比如下面这个程序：

```go
func main() {
    go println("你好, 世界")
}
```

根据 Go 语言规范，`main` 函数退出时程序结束，**不会等待任何后台线程**。因为 Goroutine 的执行和 `main` 函数的返回事件是并发的，谁都有可能先发生，所以什么时候打印，能否打印都是未知的。

用前面的原子操作并不能解决问题，因为我们无法确定两个原子操作之间的顺序。解决问题的**办法**就是**通过同步原语**来给两个事件明确排序：

```go
func main() {
    done := make(chan int)

    go func(){
        println("你好, 世界")
        done <- 1
    }()

    <-done
}
```

#### 初始化的顺序

Go 程序的初始化和执行总是从 `main.main` 函数开始的。但是如果 `main` 包里导入了其它的包，则会按照顺序将它们包含进 `main` 包里（这里的导入顺序依赖具体实现，一般可能是以文件名或包路径名的字符串顺序导入）。如果某个包被多次导入的话，在执行的时候只会导入一次。当一个包被导入时，如果它还导入了其它的包，则先将其它的包包含进来，然后创建和初始化这个包的常量和变量。然后就是调用包里的 `init` 函数，如果一个包有多个 `init` 函数的话，实现可能是以文件名的顺序调用，同一个文件内的多个 `init` 则是以出现的顺序依次调用（**`init` 不是普通函数，可以定义有多个，所以不能被其它函数调用**）。最终，在 `main` 包的所有包常量、包变量被创建和初始化，并且 `init` 函数被执行后，才会进入 `main.main` 函数，程序开始正常执行。下图是 Go 程序函数启动顺序的示意图：  

![[Snipaste/Pasted image 20230702194040.png]]

> **系统线程**通常用于执行底层的系统操作，如处理硬件中断、处理文件系统、网络通信等。它们可以直接访问操作系统的资源和服务，并具有较高的权限级别。
> 
> 系统线程的创建和销毁是由操作系统自动管理的，应用程序无法显式地创建或销毁系统线程。操作系统会根据系统负载和调度策略来决定何时创建或终止系统线程，以保持系统的稳定性和性能。
> 
> 与系统线程相对应的是用户线程，用户线程是由应用程序或用户代码创建和管理的线程。用户线程的创建和调度是由应用程序控制的，它们运行在操作系统提供的系统线程之上。用户线程通常用于执行应用程序的业务逻辑和任务。  
> 
> 需要注意的是，系统线程和用户线程的具体实现和行为可能因操作系统和编程语言的不同而有所差异。因此，在编写多线程应用程序时，需要了解目标操作系统和编程语言的线程模型和特性，并按照相应的规范和指导进行开发。

要注意的是，**在 `main.main` 函数执行之前所有代码都运行在同一个 Goroutine 中**，也是运行在程序的**主系统线程**中。如果某个 `init` 函数内部用 go 关键字启动了新的 Goroutine 的话，新的 Goroutine 和 `main.main` 函数是**并发执行的**。  

因为所有的 `init` 函数和 `main` 函数都是在主线程完成，它们也是满足顺序一致性模型的。

> 说实话我这里有点没有看懂。

#### Goroutine 的创建

`go` 语句**会在当前 Goroutine 对应函数返回前**创建新的 Goroutine。例如:

```go
var a string

func f() {
    print(a)
}

func hello() {
    a = "hello, world"
    go f()
}
```

执行 `go f()` 语句创建 Goroutine 和 `hello` 函数是在同一个 Goroutine 中执行, 根据语句的书写顺序可以确定 Goroutine 的创建发生在 `hello` 函数返回之前, 但是新创建 Goroutine 对应的 `f()` 的执行事件和 `hello` 函数返回的事件则是不可排序的，也就是并发的。**调用 `hello` 可能会在将来的某一时刻打印 `"hello, world"`，也很可能是在 `hello` 函数执行完成后才打印**。

#### 基于 Channel 的通信

Channel 通信是在 Goroutine 之间进行同步的主要方法。在无缓存的 Channel 上的每一次发送操作都有与其对应的接收操作相配对，发送和接收操作通常发生在不同的 Goroutine 上（在同一个 Goroutine 上执行两个操作很容易导致死锁）。**无缓存的 Channel 上的发送操作总在对应的接收操作完成前发生.**

> 这种解读是重要的，这其实就代表了一种并发的顺序，虽然有的时候会侥幸的将程序写对，但是我并不清楚如何正确并规范的退出 goroutine，应该去调研退出代码的范式。

```go
var done = make(chan bool)
var msg string

func aGoroutine() {
    msg = "你好, 世界"
    done <- true
}

func main() {
    go aGoroutine()
    <-done
    println(msg)
}
```

可保证打印出“你好, 世界”。该程序首先对 `msg` 进行写入，然后在 `done` 管道上发送同步信号，随后从 `done` 接收对应的同步信号，最后执行 `println` 函数。

若在关闭 Channel 后继续从中接收数据，**接收者就会收到该 Channel 返回的零值**。因此在这个例子中，用 `close(c)` 关闭管道代替 `done <- false` 依然能保证该程序产生相同的行为。

```go
var done = make(chan bool)
var msg string

func aGoroutine() {
    msg = "你好, 世界"
    close(done)
}

func main() {
    go aGoroutine()
    <-done
    println(msg)
}
```

**对于从无缓冲 Channel 进行的接收，发生在对该 Channel 进行的发送完成之前。**

基于上面这个规则可知，交换两个 Goroutine 中的接收和发送操作也是可以的（但是很危险）：

```go
var done = make(chan bool)
var msg string

func aGoroutine() {
    msg = "hello, world"
    <-done
}
func main() {
    go aGoroutine()
    done <- true
    println(msg)
}
```

也可保证打印出“hello, world”。因为 `main` 线程中 `done <- true` 发送完成前，后台线程 `<-done` 接收已经开始，这保证 `msg = "hello, world"` 被执行了，所以之后 `println(msg)` 的 msg 已经被赋值过了。简而言之，后台线程首先对 `msg` 进行写入，然后从 `done` 中接收信号，随后 `main` 线程向 `done` 发送对应的信号，最后执行 `println` 函数完成。但是，**若该 Channel 为带缓冲的**（例如，`done = make(chan bool, 1)`），**`main` 线程的 `done <- true` 接收操作将不会被后台线程的 `<-done` 接收操作阻塞**，该程序将无法保证打印出“hello, world”。

> 阻塞 channel，done <- true 是会被后台的 <-done 操作阻塞的  
> 这我还是第一次知道

对于带缓冲的 Channel，**对于 Channel 的第 `K` 个接收完成操作发生在第 `K+C` 个发送操作完成之前，其中 `C` 是 Channel 的缓存大小。** 如果将 `C` 设置为 0 自然就对应无缓存的 Channel，也即使第 K 个接收完成在第 K 个发送完成之前。因为无缓存的 Channel 只能同步发 1 个，也就简化为前面无缓存 Channel 的规则：**对于从无缓冲 Channel 进行的接收，发生在对该 Channel 进行的发送完成之前。**

我们可以根据控制 Channel 的缓存大小来控制并发执行的 Goroutine 的最大数目, 例如:

```go
var limit = make(chan int, 3)
var work = []func(){
    func() { println("1"); time.Sleep(1 * time.Second) },
    func() { println("2"); time.Sleep(1 * time.Second) },
    func() { println("3"); time.Sleep(1 * time.Second) },
    func() { println("4"); time.Sleep(1 * time.Second) },
    func() { println("5"); time.Sleep(1 * time.Second) },
}

func main() {
    for _, w := range work {
        go func(w func()) {
            limit <- 1
            w()
            <-limit
        }(w)
    }
    select{}
}
```

> 在 Go 中，`select{}` 操作会阻塞当前 goroutine 的执行。`select{}` 语句用于多路复用（multiplexing）多个通道的操作，它可以同时监听多个通道的读写操作，并在其中任意一个通道准备就绪时执行相应的代码块。  
> 
> **当 `select{}` 语句没有任何 `case` 分支时，它会永久阻塞当前 goroutine 的执行**，因为没有可执行的代码块。这意味着当前 goroutine 不会继续往下执行其他代码，也不会退出。
> 
> `select{}` 的主要用途是创建一个永久的循环，用于等待通道的读写事件。在这种情况下，一般会在 `case` 分支中执行相应的操作，比如读取通道的数据或向通道写入数据。当没有任何通道准备就绪时，`select{}` 会一直阻塞，直到有通道就绪为止。
> 
> 通过在 `select{}` 语句中使用 `default` 分支，可以实现非阻塞的多路复用。当没有任何通道就绪时，会执行 `default` 分支中的代码块，而不是阻塞在 `select{}` 语句上。
> 
> 需要注意的是，在使用 `select{}` 时应确保至少有一个通道的读写操作能够触发，否则会导致永久阻塞。在某些情况下，可能需要结合使用超时或退出信号等机制，以避免无限阻塞的情况发生。
>

在循环创建 `Goroutine` 过程中，使用了匿名函数并在函数中引用了循环变量 `w`，由于 `w` 是引用传递的而非值传递，因此无法保证 `Goroutine` 在运行时调用的 `w` 与循环创建时的 `w` 是同一个值，为了解决这个问题，我们可以利用函数传参的值复制来为每个 `Goroutine` 单独复制一份 `w`。

循环创建结束后，在 `main` 函数中最后一句 `select{}` 是一个空的管道选择语句，该语句会导致 `main` 线程阻塞，从而避免程序过早退出。还有 `for{}`、`<-make(chan int)` 等诸多方法可以达到类似的效果。因为 `main` 线程被阻塞了，如果需要程序正常退出的话可以通过调用 **`os.Exit(0)`** 实现。

#### 不靠谱的同步

前面我们已经分析过，下面代码无法保证正常打印结果。实际的运行效果也是大概率不能正常输出结果。

```go
func main() {
    go println("你好, 世界")
}
```

刚接触 Go 语言的话，可能希望通过加入一个随机的休眠时间来保证正常的输出：

```go
func main() {
    go println("hello, world")
    time.Sleep(time.Second)
}
```

因为主线程休眠了 1 秒钟，因此这个程序大概率是可以正常输出结果的。因此，很多人会觉得这个程序已经没有问题了。但是这个程序是不稳健的，依然有失败的可能性。我们先假设程序是可以稳定输出结果的。因为 Go 线程的启动是非阻塞的，`main` 线程显式休眠了 1 秒钟退出导致程序结束，我们可以近似地认为程序总共执行了 1 秒多时间。现在假设 `println` 函数内部实现休眠的时间大于 `main` 线程休眠的时间的话，就会导致矛盾：后台线程既然先于 `main` 线程完成打印，那么执行时间肯定是小于 `main` 线程执行时间的。当然这是不可能的。

严谨的并发程序的正确性不应该是依赖于 CPU 的执行速度和休眠时间等**不靠谱的因素**的。严谨的并发也应该是可以静态推导出结果的：**根据线程内顺序一致性**，结合 Channel 或 `sync` 同步事件的**可排序性**来推导，最终完成各个线程各段代码的**偏序关系排序**。如果两个事件无法根据此规则来排序，那么它们就是并发的，也就是执行先后顺序不可靠的。

解决同步问题的思路是相同的：**使用显式的同步**。

#### 小结

可以的，已经快忘没来，今天晚上 8.30 要总结一下

### 常见的并发模式

Go 语言最吸引人的地方是它内建的并发支持。Go 语言并发体系的理论是 _C.A.R Hoare_ 在 1978 年提出的 CSP（Communicating Sequential Process，通讯顺序进程）。CSP 有着精确的数学模型，并实际应用在了 Hoare 参与设计的 T9000 通用计算机上。从 NewSqueak、Alef、Limbo 到现在的 Go 语言，对于对 CSP 有着 20 多年实战经验的 _Rob Pike_ 来说，他更关注的是将 CSP 应用在通用编程语言上产生的潜力。作为 Go 并发编程核心的 CSP 理论的核心概念只有一个：同步通信。关于同步通信的话题我们在前面一节已经讲过，本节我们将简单介绍下 Go 语言中常见的并发模式。

首先要明确一个概念：并发不是并行。**并发更关注的是程序的设计层面，并发的程序完全是可以顺序执行的**，只有在真正的多核 CPU 上才可能真正地同时运行。并行更关注的是程序的运行层面，并行一般是简单的大量重复，例如 GPU 中对图像处理都会有大量的并行运算。为更好的编写并发程序，从设计之初 Go 语言就注重如何在编程语言层级上设计一个简洁安全高效的抽象模型，让程序员专注于**分解问题和组合方案**，**而且不用被线程管理和信号互斥这些繁琐的操作分散精力**。

在并发编程中，对共享资源的正确访问需要精确的控制，在目前的绝大多数语言中，都是通过加锁等线程同步方案来解决这一困难问题，而 Go 语言却另辟蹊径，它将共享的值通过 Channel 传递 (实际上多个独立执行的线程很少主动共享资源)。在任意给定的时刻，最好**只有一个 Goroutine 能够拥有该资源**。**数据竞争从设计层面上就被杜绝了**。为了提倡这种思考方式，Go 语言将其并发编程哲学化为一句口号：

> Do not communicate by sharing memory; instead, share memory by communicating.

> 不要通过共享内存来通信，而应通过通信来共享内存。

这是更高层次的并发编程哲学 (通过管道来传值是 Go 语言推荐的做法)。虽然像引用计数这类简单的并发问题通过原子操作或互斥锁就能很好地实现，但是通过 Channel 来控制访问能够让你**写出更简洁正确的**程序。

#### 并发版本的 Hello, World

```go
func main() {
    done := make(chan int, 10) // 带 10 个缓存

    // 开 N 个后台打印线程
    for i := 0; i < cap(done); i++ {
        go func(){
            fmt.Println("你好, 世界")
            done <- 1
        }()
    }

    // 等待 N 个后台线程完成
    for i := 0; i < cap(done); i++ {
        <-done
    }
}
```

WaitGroup 重写上述代码

```go
func main() {
    var wg sync.WaitGroup

    // 开 N 个后台打印线程
    for i := 0; i < 10; i++ {
        wg.Add(1)

        go func() {
            fmt.Println("你好, 世界")
            wg.Done()
        }()
    }

    // 等待 N 个后台线程完成
    wg.Wait()
}
```

#### 生产者消费者模型

并发编程中最常见的例子就是**生产者消费者模式**，该模式主要通过**平衡**生产线程和消费线程的工作能力来提高程序的整体处理数据的速度。简单地说，就是生产者生产一些数据，然后放到成果队列中，同时消费者从成果队列中来取这些数据。这样就让生产消费变成了异步的两个过程。当成果队列中没有数据时，消费者就进入饥饿的等待中；而当成果队列中数据已满时，生产者则面临因产品挤压导致 CPU 被剥夺的下岗问题。

```go
// 生产者: 生成 factor 整数倍的序列
func Producer(factor int, out chan<- int) {
    for i := 0; ; i++ {
        out <- i*factor
    }
}

// 消费者
func Consumer(in <-chan int) {
    for v := range in {
        fmt.Println(v)
    }
}
func main() {
    ch := make(chan int, 64) // 成果队列

    go Producer(3, ch) // 生成 3 的倍数的序列
    go Producer(5, ch) // 生成 5 的倍数的序列
    go Consumer(ch)    // 消费生成的队列

    // 运行一定时间后退出
    time.Sleep(5 * time.Second)
	// 这种睡眠的方式是不可靠的
}

func main() {
    ch := make(chan int, 64) // 成果队列

    go Producer(3, ch) // 生成 3 的倍数的序列
    go Producer(5, ch) // 生成 5 的倍数的序列
    go Consumer(ch)    // 消费 生成的队列

    // Ctrl+C 退出
    sig := make(chan os.Signal, 1)
    signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
    fmt.Printf("quit (%v)\n", <-sig)
}
```

#### 发布订阅模型

发布订阅（publish-and-subscribe）模型通常被简写为 pub/sub 模型。在这个模型中，消息生产者成为发布者（publisher），而消息消费者则成为订阅者（subscriber），生产者和消费者是 **M:N** 的关系。在传统生产者和消费者模型中，是将消息发送到**一个队列**中，而发布订阅模型则是将消息发布给**一个主题**。

为此，我们构建了一个名为 `pubsub` 的发布订阅模型支持包：

```go
// Package pubsub implements a simple multi-topic pub-sub library.
package pubsub

import (
    "sync"
    "time"
)

type (
    subscriber chan interface{}         // 订阅者为一个管道
    topicFunc  func(v interface{}) bool // 主题为一个过滤器
)

// 发布者对象
type Publisher struct {
    m           sync.RWMutex             // 读写锁
    buffer      int                      // 订阅队列的缓存大小
    timeout     time.Duration            // 发布超时时间
    subscribers map[subscriber]topicFunc // 订阅者信息
}

// 构建一个发布者对象, 可以设置发布超时时间和缓存队列的长度
func NewPublisher(publishTimeout time.Duration, buffer int) *Publisher {
    return &Publisher{
        buffer:      buffer,
        timeout:     publishTimeout,
        subscribers: make(map[subscriber]topicFunc),
    }
}

// 添加一个新的订阅者，订阅全部主题
func (p *Publisher) Subscribe() chan interface{} {
    return p.SubscribeTopic(nil)
}

// 添加一个新的订阅者，订阅过滤器筛选后的主题
func (p *Publisher) SubscribeTopic(topic topicFunc) chan interface{} {
    ch := make(chan interface{}, p.buffer)
    p.m.Lock()
    p.subscribers[ch] = topic
    p.m.Unlock()
    return ch
}

// 退出订阅
func (p *Publisher) Evict(sub chan interface{}) {
    p.m.Lock()
    defer p.m.Unlock()

    delete(p.subscribers, sub)
    close(sub)
}

// 发布一个主题
func (p *Publisher) Publish(v interface{}) {
    p.m.RLock()
    defer p.m.RUnlock()

    var wg sync.WaitGroup
    for sub, topic := range p.subscribers {
        wg.Add(1)
        go p.sendTopic(sub, topic, v, &wg)
    }
    wg.Wait()
}

// 关闭发布者对象，同时关闭所有的订阅者管道。
func (p *Publisher) Close() {
    p.m.Lock()
    defer p.m.Unlock()

    for sub := range p.subscribers {
        delete(p.subscribers, sub)
        close(sub)
    }
}

// 发送主题，可以容忍一定的超时
func (p *Publisher) sendTopic(
    sub subscriber, topic topicFunc, v interface{}, wg *sync.WaitGroup,
) {
    defer wg.Done()
    if topic != nil && !topic(v) {
        return
    }

    select {
    case sub <- v:
    case <-time.After(p.timeout):
    }
}
```

> 过早的顶层抽象是不好的，而且很多时候是不必要的。

下面的例子中，有两个订阅者分别订阅了全部主题和含有 "golang" 的主题：

```go
import "path/to/pubsub"

func main() {
    p := pubsub.NewPublisher(100*time.Millisecond, 10)
    defer p.Close()

    all := p.Subscribe()
    golang := p.SubscribeTopic(func(v interface{}) bool {
        if s, ok := v.(string); ok {
            return strings.Contains(s, "golang")
        }
        return false
    })

    p.Publish("hello,  world!")
    p.Publish("hello, golang!")

    go func() {
        for  msg := range all {
            fmt.Println("all:", msg)
        }
    } ()

    go func() {
        for  msg := range golang {
            fmt.Println("golang:", msg)
        }
    } ()

    // 运行一定时间后退出
    time.Sleep(3 * time.Second)
}
```

在发布订阅模型中，每条消息都会传送给多个订阅者。**发布者通常不会知道、也不关心哪一个订阅者正在接收主题消息**。订阅者和发布者可以在运行时动态添加，是一种**松散的耦合关系**，这使得系统的复杂性可以随时间的推移而增长。在现实生活中，像天气预报之类的应用就可以应用这个并发模式。

> 仅仅是因为当初我并不知道怎么学习而已

#### 控制并发数

#### 赢者为王

#### 素数筛

#### 并发的安全退出

#### Context 包 (这个包是一个重点内容，需要扩种)

#### 小结

这部分内容需要结合 golang 并发编程食用更佳。

### 错误和异常

#### 错误处理策略

#### 获取错误的上下文

#### 错误的错误返回

#### 刨析异常

#### 小结

## Reference
