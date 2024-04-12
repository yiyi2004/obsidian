1. 随着自旋失败的次数增加，等待时间会增加，但是会有上限。并发竞争激烈
2. runtime.Gosched() P 的执行权让出来，然后投入到全局队列里面去调度。谦让的过程。
3. 私有变量，认为使用一定是先加锁再解锁的

## sync.Cond

并发协调器，并发调度协调。

![[Snipaste/Pasted image 20240412102351.png]]

- cond.Wait 会执行释放锁的操作，所以之前必须持有锁

![[Snipaste/Pasted image 20240412104512.png]]

1. 解锁
2. 阻塞
3. 释放锁

外部看来是状态是一致的。

## cond.Signal

![[Snipaste/Pasted image 20240412104755.png]]

1. Cond 首次使用后被拷贝，panic
2. notify 统计数 +1
3. 唤醒等待时间最长的 goroutine

broadcast

## sync.Pool

- 对象池

### 数据结构

- 上限是 P 的数量

![[Snipaste/Pasted image 20240412105628.png]]

1. private
2. sharedList  

- 有点类似于一个回收站 | 缓存的作用。
- 逻辑意义上是删除了的
- 不需要手动清理，GC 时刻
- 和 GMP 是相关的
- golang GMP

数组

- P 调度器的数量
- private P 私有的，不需要加锁，无锁化的操作
- sharedList 共有的
- 转移 victim
- New func() 创建对象

![[Snipaste/Pasted image 20240412154414.png]]

![[Snipaste/Pasted image 20240412154453.png]]

### Pin(高危操作)

将两个东西别在一起。goroutine 和一个调度器绑定在一起

- 将 goroutine 和 P 绑定在一起，防止其被调度到其他 p 上，访问 privite 的时候出现意外的情况
- 一定要有解绑的过程 unpin

### pool.Get

- 缓存复用

![[Snipaste/Pasted image 20240412154953.png]]

1. private
2. p 的 shared list 中拿
3. 其他 p 的 shared list
4. victim 中拿

![[Snipaste/Pasted image 20240412155104.png]]

- getslow 其他 p 偷
- 没有就执行 234

### Put

有借有还再借不难

![[Snipaste/Pasted image 20240412155526.png]]

### 回收机制

![[Snipaste/Pasted image 20240412155618.png]]

- 无感知的销毁
- 回收的过程

![[Snipaste/Pasted image 20240412155744.png]]

- golang 运行时
- 定时
- 内存
- 动态属性有关
- 时机不可控的

用户会创建多个 sync.Pool

oldpool 当前的 pool 放到全局的 pool 里面。

工程使用

1. gin 框架，每个链路 context，handler 串联，创建和销毁的量非常大。创建和销毁非常频繁
2. golang 协程池

## Ants

- 高性能，低损耗的协程池

底层实现

池子，频繁的创建和销毁，缓冲数据，缓和调度使用曲线。

1. 生产环境中不需要使用协程池
2. 如果 10000+ 的协程呢？
3. 协程执行业务逻辑
4. 不加节制，不控制。危险，成千上万 goroutine 出现问题。系统岌岌可危。
5. 并发调度的生命周期的控制 —— 协程池，全局的并发度的控制。
6. 预期的容量上限 1500 个。1501 会报错 | 阻塞、定量评估
7. 协程生命周期的控制

### Ants 数据结构

![[Snipaste/Pasted image 20240412162134.png]]

- workerArray goroutine
- pinMutex
- cond 并发协调器
- workerCache 协程对象池|回收站 底层是 sync.Poo

## GMP

- gmp 模型需要仔细学习一下
