
- Time：2023-06-08 09:06
- Label： #go #buildin

## Abstract

## Content

copy() 函数的使用格式如下：

```go
copy( destSlice, srcSlice []T) int
```

其中 srcSlice 为数据来源切片，destSlice 为复制的目标（也就是将 srcSlice 复制到 destSlice），目标切片必须分配过空间且足够承载复制的元素个数，并且来源和目标的类型必须一致，copy() 函数的返回值表示实际发生复制的元素个数。

## Reference
