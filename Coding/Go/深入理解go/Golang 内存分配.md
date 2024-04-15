- 减小锁的粒度，多级内存分配

![[Snipaste/Pasted image 20240414195924.png]]

1. 操作系统的存储模型的思路
2. 虚拟内存的思路 | 优化用户的体验、内存放大、冷热动态切换
3. 分页管理 page --- frame(物理)
	1. 提高空间的利用率
	2. 内部碎片是可控的

![[Snipaste/Pasted image 20240414200309.png]]

1. 切合虚拟内存和物理内存之间的对应关系

## Golang 的内存模型

1. 空间换时间，一次缓存多次使用，不是每次都向操作系统申请内存。
2. mheap

![[Snipaste/Pasted image 20240414200539.png]]

![[Snipaste/Pasted image 20240414200811.png]]

![[Snipaste/Pasted image 20240414201258.png]]

![[Snipaste/Pasted image 20240414201317.png]]

## 基本概念

![[Snipaste/Pasted image 20240414201542.png]]

1. startAddr
2. npages

不同等级的 mcentral 分别是一个链表

- mspan 是 Golang 内存管理的最小单元
- mspan 大小是 page 的整数倍（Go 中的 page 大小为 8KB），且内部的页是连续的（至少在虚拟内存的视角中是这样）
- 每个 mspan 根据空间大小以及面向分配对象的大小，会被划分为不同的等级（2.2 小节展开）
- 同等级的 mspan 会从属同一个 mcentral，最终会被组织成链表，因此带有前后指针（prev、next）
- 由于同等级的 mspan 内聚于同一个 mcentral，所以会基于同一把互斥锁管理
- mspan 会基于 bitMap 辅助快速找到空闲内存块（块大小为对应等级下的 object 大小），此时需要使用到 Ctz64 算法.  

![[Snipaste/Pasted image 20240414201916.png]]

除了上面谈及的根据大小确定的 mspan 等级外，每个 object 还有一个重要的属性叫做 nocan，标识了 object 是否包含指针，在 gc 时是否需要展开标记.

在 Golang 中，会将 span class + nocan 两部分信息组装成一个 uint8，形成完整的 spanClass 标识. 8 个 bit 中，高 7 位表示了上表的 span 等级（总共 67 + 1 个等级，8 个 bit 足够用了），最低位表示 nocan 信息.

### 线程缓存 Mcache

![[Snipaste/Pasted image 20240414203254.png]]

（1）mcache 是每个 P 独有的缓存，**因此交互无锁**  
（2）mcache 将每种 spanClass 等级的 mspan 各缓存了一个，总数为 2（**nocan** 维度） * 68（大小维度）= 136  
（3）mcache 中还有一个为对象分配器 **tiny allocator**，用于处理小于 16B 对象的内存分配，在 3.3 小节中详细展开.

### 中心缓存 Mcentral

![[Snipaste/Pasted image 20240414203519.png]]  
（1）每个 mcentral 对应一种 **spanClass**  
（2）每个 mcentral 下**聚合**了该 spanClass 下的 mspan  
（3）mcentral 下的 mspan 分为**两个链表**，分别为有空间 mspan 链表 **partial** 和满空间 mspan 链表 **full**  
（4）**每个 mcentral 一把锁**

### 全局堆缓存

- 对于 Golang 上层应用而言，堆是操作系统虚拟内存的抽象
- 以页（8KB）为单位，作为最小内存存储单元
- 负责将连续页组装成 mspan
- 全局内存基于 bitMap 标识其使用情况，每个 bit 对应一页，为 0 则自由，为 1 则已被 mspan 组装
- 通过 heapArena 聚合页，记录了页到 mspan 的映射信息（2.7 小节展开）
- 建立**空闲页基数树索引** radix tree index，辅助快速寻找空闲页（2.6 小节展开）
- 是 mcentral 的持有者，持有所有 spanClass 下的 mcentral，作为自身的缓存
- 内存不够时，向操作系统申请，申请单位为 heapArena（64M）
