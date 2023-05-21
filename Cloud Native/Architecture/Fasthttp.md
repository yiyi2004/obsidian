#architecture
## Fasthttp
1. net/http 的架构
2. fasthttp 的架构
#tips
1. 通过 sync.Pool 去复用对象
2. 通过 `s  = s[:0]` 减少切片的多次创建
其实在实现上并没有什么操作，实际上是优化了内存分配、对象的复用等等。但是没有调查就没有发言权，你需要去看看 net/http 和 fasthttp 包具体实现是什么。

仅仅会使用是远远不够的

## Reference
- https://cloud.tencent.com/developer/article/1839675
- [valyala/fasthttp: Fast HTTP package for Go. Tuned for high performance. Zero memory allocations in hot paths. Up to 10x faster than net/http (github.com)](https://github.com/valyala/fasthttp)
