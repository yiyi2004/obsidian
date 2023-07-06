- Time：2023-06-24 16:34
- Label： #architecture #tips

## Abstract

总结 fasthttp 的架构特点，对内存精细的规划实现性能的提升，减少内存分配。

## Content

### Fasthttp

1. net/http 的架构
2. fasthttp 的架构  
3. 通过 sync.Pool 去复用对象
4. 通过 `s  = s[:0]` 减少切片的多次创建  

其实在实现上并没有什么操作，实际上是优化了内存分配、对象的复用等等。但是没有调查就没有发言权，你需要去看看 net/http 和 fasthttp 包具体实现是什么。

![[Snipaste/Pasted image 20230624163433.png]]  
![[Snipaste/Pasted image 20230624163507.png]]  
![[Snipaste/Pasted image 20230624163511.png]]

### 小结

1. 控制异步 Goroutine 的同时处理数量，最大模式是 256 \* 1024 个
2. 使用 sync.Pool 来大量的复用对象和切片，减少内存的分配
3. 尽量的避免 `[]byte` 到 `string` 转换时带来的内存分配和拷贝带来的消耗 #不懂

## Reference

- https://cloud.tencent.com/developer/article/1839675
- [valyala/fasthttp: Fast HTTP package for Go. Tuned for high performance. Zero memory allocations in hot paths. Up to 10x faster than net/http (github.com)](https://github.com/valyala/fasthttp)
