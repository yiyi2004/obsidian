- kafka 有什么优缺点？
	- 缺点，局部 topic 有序，无法保证全局有序。
- kafka 为什么快？
	- 顺序读写
	- Page Cache
		- write behind 和 read ahead 是什么东西啊
	- 零拷贝
	- 分区分段 + 索引
	- 批量读写
	- 批量压缩
	- Kafka 速度的秘诀在于，它把所有的消息都变成一个批量的文件，并且进行合理的批量压缩，减少网络 IO 损耗，通过 mmap 提高 I/O 速度，写入数据的时候由于单个 Partion 是末尾添加所以速度最优；读取数据的时候配合 sendfile 直接暴力输出。
- kafka 怎么做的选主？
	- Raft 算法
	- [美团面试：谈谈你对Kafka控制器及选举机制是如何理解的_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1NP411z7xN/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- kafka 副本数如何设置？
	- [replicationFactor]([Kafka 设置分区副本数 replication.factor_kafka replicationfactor-CSDN博客](https://blog.csdn.net/u010002184/article/details/113354392))
- **如果大批消息消费失败，怎么解决（消息堆积/没有消息堆积）**
	- 消费者端
	- 生产者端
	- 服务端 broker
- kafak 持久化内存满了除了迁移还能怎么办？
- 什么是 kafka connectors，它能做什么？
- 什么是 CDC，介绍下？
	- CDC (Change Data Capture) 是一种在数据库中捕获数据更改并将其传递给其他系统的技术。
- kafka、rabbitmq 和 rocketMQ 是什么？介绍下并说说它们之间的区别。
- rabbitmq 可以多个消费者订阅一个生产者吗，实现步骤详细说一下
- 什么是 zookeeper？
- zookeeper 在 kafka 中是什么作用，介绍下？
	- Broker 在 ZooKeeper 中的注册
	- Topic 在 ZooKeeper 中的注册
	- Consumer 在 ZooKeeper 中的注册
	- Consumer [负载均衡](https://cloud.tencent.com/product/clb?from_column=20065&from=20065)
	- 记录消费进度 Offset
	- 记录 Partition 与 Consumer 的关系
- 负载均衡策略
	- 轮询策略
	- 最小连接数策略
	- 最少响应时间 —— 但是会不会给网络造成拥塞
	- IP 哈希
	- 加权轮询

![[Snipaste/Pasted image 20231225210808.png]]

什么是 zookeeper

ZooKeeper 是一个开源的分布式协调服务，它是 Apache 软件基金会下的一个项目，旨在解决分布式系统中的协调和管理问题。ZooKeeper 提供了一个简单而强大的分布式环境，可以用于构建和管理大规模分布式系统。 ZooKeeper 的主要作用是为分布式系统提供高可用性、高性能和强一致性的数据存储和协调服务。在分布式系统中，多个节点协同工作，需要进行数据共享、状态同步和协调操作，这些都需要一致性和可靠性的支持。ZooKeeper 提供了以下核心功能来实现这些目标：

1. 配置管理： ZooKeeper 可以用来管理分布式系统的配置信息。各个节点可以从 ZooKeeper 中获取配置信息，这样当配置变化时，所有节点可以及时感知并进行相应调整。
2. 命名服务： ZooKeeper 可以用作命名服务，类似于分布式的文件系统。它允许应用程序在 ZooKeeper 上创建、删除和查找节点，从而实现简单的命名空间管理。
3. 分布式锁： ZooKeeper 提供了分布式锁的支持，允许多个节点在共享资源上进行协调，从而避免并发访问冲突。
4. 分布式队列： ZooKeeper 可以实现分布式队列，用于在多个节点之间传递消息和任务。
5. 分布式通知： ZooKeeper 的 Watcher 机制可以让客户端监视节点的变化，并在节点状态发生变化时接收通知，实现分布式的事件触发和通知机制。
6. Leader 选举： 在 ZooKeeper 集群中，ZAB（ZooKeeper Atomic Broadcast）协议用于选举 Leader 节点，Leader 负责处理所有客户端的写请求，并将更改广播给其他 Follower 节点。  

通过这些功能，ZooKeeper 可以帮助分布式系统实现一致性和可靠性的数据管理，以及实现分布式节点之间的协调和通信。它成为构建分布式系统和服务的重要基础设施，并被广泛用于诸如分布式数据库、分布式缓存、分布式计算等各种分布式应用中。

## Kafka 面试题

### 消费积压

产生原因：

1. 发送方发送消息过快、接收方处理消息太慢，导致消息积压
2. 处理格式问题，接收方不知道 | bug

解决方案

1. 提高消费者的消费能力，多个 goroutine 进行处理
2. 转发 其他 topic 多个 partition 然后多个消费者进行处理
3. 将消息转发到其他队列里面，然后进行分析

## 重复消费

产生原因：

1. 发送方发送消息，但是没有收到 ACK，导致又发了一条
2. 接收方手动提交

解决方案：

1. 消费幂等
	1. 分布式锁
	2. MySQL 主键判断

## 消息丢失

产生原因：

1. ack 参数
	1. ack = 0
	2. ack = 1 写入 | 从节点没同步，主节点挂了，消息丢失
	3. ack = -1 很少会丢数据
2. 消费端：自动提交，消费只要到了消费者这里，broker 就提交了，消费端宕机了，设置手动提交。

## 对比

1. Kafka
2. ActiveMQ
3. RabbitMQ
4. RocketMQ

![[Snipaste/Pasted image 20240404142332.png]]

## Kafka 的 Pull 和 Push 的优缺点

pull 不实时

push 实时的，消费者的压力很大  
![[Snipaste/Pasted image 20240404142513.png]]

## 高性能

1. 零拷贝
2. 顺序写

![[Snipaste/Pasted image 20240404142716.png]]

1. 零拷贝：
2. 顺序写：预读机制、磁头、磁盘

## Pull Push

![[Snipaste/Pasted image 20240404143120.png]]

1. pulll 可以控制速率
2. pull1 条 or 多条
3. 手动提交
4. kafka 没有数据，空循环，消耗资源
5. 通过参数配置，如果 consumer 拉去数据为空或者没有达到一定数量，会进行阻塞

push

1. 不会导致 consumer 循环等待
2. 速率不固定，consumer 消费能力不知道

## 消息丢失

1. 发送方从 ack 的三个角度去考虑
2. ISR zk 中
3. ack = 2 至少同步到一个从节点

![[Snipaste/Pasted image 20240404143641.png]]

- tries > 1
- 同步副本数量
- 不能从 OSR 中进行选举
- min.insync.replicas 最小同步数量
- 失败的 offset 单独处理

### 消费端

1. 先 offset，消息丢失
2. 先处理消息，再 commit，重复消费的情况 —— 消息幂等进行处理

保证接口的幂等性，保证处理是一致的。

### Broker 的刷盘

page cache ——

- 减小刷盘时间

## 高可靠的解决方案

![[Snipaste/Pasted image 20240404144407.png]]

![[Snipaste/Pasted image 20240404144624.png]]

## 事务消息

## Zk 的作用

集群的管理功能：

## 高性能原因

读写能力

## 副本同步机制

1. leader 处理读写请求
2. follower 只数据同步
3. LEO
4. HW 前面的可以被xiao'f
