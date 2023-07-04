- Time：2023-07-04 09:05
- Label： #go #泛型编程

## Abstract

1. 泛型编程基础
2. GopherChina 两场有关泛型编程的内容

## Content

### 基础泛型

```go
// Package constraints borrow from https://github.com/TheAlgorithms/Go/blob/master/constraints/constraints.go
package constraints

// Signed is a generic type constraint for all signed integers.
type Signed interface {
	~int | ~int8 | ~int16 | ~int32 | ~int64
}

// Unsigned is a generic type constraint for all unsigned integers.
type Unsigned interface {
	~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64
}

// Integer is a generic type constraint for all integers (signed and unsigned.)
type Integer interface {
	Signed | Unsigned
}

// Float is a generic type constraint for all floating point types.
type Float interface {
	~float32 | ~float64
}

// Number is a generic type constraint for all numeric types in Go except Complex types.
type Number interface {
	Integer | Float
}

// Ordered is a generic type constraint for all ordered data types in Go.
// Loosely speaking, in mathematics a field is an ordered field if there is a "total
// order" (a binary relation - in this case `<` symbol) such that we will always have
// if a < b then a + c < b + c and if 0 < a, 0 < b then 0 < a.b
// The idea in Go is quite similar, though only limited to Go standard types
// not user defined types.
type Ordered interface {
	Integer | ~string | Float
}
```

### 泛型理解

我们不应该去定义它的类型，让调用者定义它的类型。传进来的是形式类型。泛型函数  

![[Snipaste/Pasted image 20230704202918.png]]

#### 小结：泛型的作用

1. 泛型减少重复代码并提高类型安全性
2. 在下面情景的时候非常适合使用泛型：当你需要针对不同类型书写相同的逻辑，使用泛型来简化代码是最好的。

## Reference
