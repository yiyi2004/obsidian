>  不要通过共享内存的方式进行通信，而是应该通过通信的方式共享内存。

## 乐观锁和悲观锁

乐观锁和悲观锁是两种思想，用于解决并发场景下的数据竞争问题。

- 乐观锁：乐观锁在操作数据时非常乐观，**认为别人不会同时修改数据**。因此乐观锁不会上锁，只是在执行更新的时候判断一下在此期间别人是否修改了数据：如果别人修改了数据则放弃操作，否则执行操作。
- 悲观锁：悲观锁在操作数据时比较悲观，认为别人会同时修改数据。因此操作数据时直接把数据锁住，直到操作完成后才会释放锁；上锁期间其他人不能修改数据。
- 今天先读完第一小节。
- go channel 的部分还没学习捏。

## 原理

1. 使用场景
	1. 停止信号传递
	2. 定时任务
	3. 生产和消费解耦
	4. 控制并发数量
2. 底层数据结构
	1. hchan runtime/chan.go
		1. buf []array 有缓存的 channel 循环数组
		2. sendx 下一个要读取数据的下标
		3. recvx 下一个要写入数据的下标
		4. sendq 写等待队列
		5. recvq 读等待队列
		6. lock 线程安全的，保证操作是互斥的
3. 操作
	1. 创建 make
	2. 检查
		1. 元素大小不能超过 64KB
		2. 元素对齐大小不超过 maxAlign 也就是 8 字节
		3. 计算出的内存是否超过限制
	3. 创建时的策略 ![[Snipaste/Pasted image 20240129151451.png]]
	4. 发送操作 ![[Snipaste/Pasted image 20240129151716.png]]
	5. 接收操作 ![[Snipaste/Pasted image 20240129151921.png]]
	6. 关闭
4. 总结 ![[Snipaste/Pasted image 20240129152201.png]]

### 底层数据结构

```go
type hchan struct {
	qcount   uint           // total data in the queue
	dataqsiz uint           // size of the circular queue
	buf      unsafe.Pointer // points to an array of dataqsiz elements
	elemsize uint16
	closed   uint32
	elemtype *_type // element type
	sendx    uint   // send index
	recvx    uint   // receive index
	recvq    waitq  // list of recv waiters
	sendq    waitq  // list of send waiters

	// lock protects all fields in hchan, as well as several
	// fields in sudogs blocked on this channel.
	//
	// Do not change another G's status while holding this lock
	// (in particular, do not ready a G), as this can deadlock
	// with stack shrinking.
	lock mutex
}

type waitq struct {
	first *sudog
	last  *sudog
}

type sudog struct {
	// The following fields are protected by the hchan.lock of the
	// channel this sudog is blocking on. shrinkstack depends on
	// this for sudogs involved in channel ops.

	g *g

	next *sudog
	prev *sudog
	elem unsafe.Pointer // data element (may point to stack)

	// The following fields are never accessed concurrently.
	// For channels, waitlink is only accessed by g.
	// For semaphores, all fields (including the ones above)
	// are only accessed when holding a semaRoot lock.

	acquiretime int64
	releasetime int64
	ticket      uint32

	// isSelect indicates g is participating in a select, so
	// g.selectDone must be CAS'd to win the wake-up race.
	isSelect bool

	// success indicates whether communication over channel c
	// succeeded. It is true if the goroutine was awoken because a
	// value was delivered over channel c, and false if awoken
	// because c was closed.
	success bool

	parent   *sudog // semaRoot binary tree
	waitlink *sudog // g.waiting list or semaRoot
	waittail *sudog // semaRoot
	c        *hchan // channel
}
```

## Reference

- [Go 语言 Channel 实现原理精要 | Go 语言设计与实现 (draveness.me)](https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-channel/)
- [【BAT面试题系列】面试官：你了解乐观锁和悲观锁吗？ - 编程迷思 - 博客园 (cnblogs.com)](https://www.cnblogs.com/kismetv/p/10787228.html)
