
- Time：2023-06-07 18:37
- Label：

## Abstract

通过**接口去定义数据结构的通用行为**是需要借鉴的操作，同时还抽象出了 Container 结构，真不错！

Lists 主要介绍链表有关内容，包含三个部分：

1. ArrayList
2. SinglyLinkedList
3. DoublyLinkedList

这个库的**接口设计**是非常精髓的，值得学习

1. Container
2. EnumerableWithIndex
3. EnumerableWithKey
4. ReverseIteratorWithKey
5. JSONSerializer
6. JSONDeserializer

接口的名字是接口中函数需要共同解决的问题，但其实也不是，它其实描述了一个**抽象的实体**所需要完成的功能。

但是这个抽象的实体是怎么抽象出来的呢？两个答案：

1. 自下而上
2. 自上而下

数据结构是划分**线程安全**和**线程不安全的**，那么应该如何实现线程安全呢？

在大型程序开发的一开始，需要定制数据结构，但是数据结构包含哪些行为呢？

数据结构的行为 ---> 接口的指定 ---> 实际场景 + 经验 ---> 阅读大量源码

> 可以添加到内容：我们为什么要阅读源码，阅读源代码可以给我们带来什么好处？

所以反过来阅读源码可以带来的好处

1. 代码审计
2. 架构设计
3. 接口设计
4. 数据结构和算法的应用
5. 如何对内存进行精细的规划
6. 大型的，复杂的系统是如何搭建起来的 <--- 你不能仅仅知道结果，但是不知道思维的过程，形成的原因

## Content

### List Interface

```go
type List interface {
	Get(index int) (interface{}, bool)
	Remove(index int)
	Add(values ...interface{})
	Contains(values ...interface{}) bool
	Sort(comparator utils.Comparator)
	Swap(index1, index2 int)
	Insert(index int, values ...interface{})
	Set(index int, value interface{})

	containers.Container
	// Empty() bool
	// Size() int
	// Clear()
	// Values() []interface{}
    // String() string
}
```

### ArrayList

#### 使用方法

A [list](https://github.com/emirpasic/gods#lists) backed by a dynamic array that grows and shrinks implicitly.

Implements [List](https://github.com/emirpasic/gods#lists), [ReverseIteratorWithIndex](https://github.com/emirpasic/gods#reverseiteratorwithindex), [EnumerableWithIndex](https://github.com/emirpasic/gods#enumerablewithindex), [JSONSerializer](https://github.com/emirpasic/gods#jsonserializer) and [JSONDeserializer](https://github.com/emirpasic/gods#jsondeserializer) interfaces.

```go
package main

import (
	"github.com/emirpasic/gods/lists/arraylist"
	"github.com/emirpasic/gods/utils"
)

func main() {
	list := arraylist.New()
	list.Add("a")                         // ["a"]
	list.Add("c", "b")                    // ["a","c","b"]
	list.Sort(utils.StringComparator)     // ["a","b","c"]
	_, _ = list.Get(0)                    // "a",true
	_, _ = list.Get(100)                  // nil,false
	_ = list.Contains("a", "b", "c")      // true
	_ = list.Contains("a", "b", "c", "d") // false
	list.Swap(0, 1)                       // ["b","a",c"]
	list.Remove(2)                        // ["b","a"]
	list.Remove(1)                        // ["b"]
	list.Remove(0)                        // []
	list.Remove(0)                        // [] (ignored)
	_ = list.Empty()                      // true
	_ = list.Size()                       // 0
	list.Add("a")                         // ["a"]
	list.Clear()                          // []
	list.Insert(0, "b")                   // ["b"]
	list.Insert(0, "a")                   // ["a","b"]
}
```

都是些简单的操作，数据结构是更重要的。

### SinglyLinkedList

### DoublyLinkedList

## Reference

- [emirpasic/gods: GoDS (Go Data Structures) - Sets, Lists, Stacks, Maps, Trees, Queues, and much more (github.com)](https://github.com/emirpasic/gods#lists)
