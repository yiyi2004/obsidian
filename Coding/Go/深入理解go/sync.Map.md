## 数据结构

![[Snipaste/Pasted image 20240404160210.png]]

- 主线一：首先基于无锁操作访问 read map；倘若 read map 不存在该 key，则加锁并使用 dirty map 兜底；  
- 主线二：read map 和 dirty map 之间会交替轮换更新.
- amended

## Entry 的几种状态

- 存活态
- 软删除状态
- 硬删除状态

```
var expunged = unsafe.Pointer(new(any))
```

## readOnly

```go
type readOnly struct {
    m       map[any]*entry
    amended bool // true if the dirty map contains some key not in m.
}
```

## 读流程

![[Snipaste/Pasted image 20240404160917.png]]

## 写流程

![[Snipaste/Pasted image 20240404161019.png]]

1. 更新也是写流程

## 删流程

![[Snipaste/Pasted image 20240404161052.png]]

## 遍历流程

![[Snipaste/Pasted image 20240404161110.png]]

## Reference

- [Golang sync.Map 实现原理 (qq.com)](https://mp.weixin.qq.com/s/nMuCMA8ONnhs1lsTVMcNgA)
