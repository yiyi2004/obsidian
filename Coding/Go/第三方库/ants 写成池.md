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
