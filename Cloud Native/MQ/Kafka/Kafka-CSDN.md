![[Snipaste/Pasted image 20221023221438.png]]

- 解耦合
- 异步处理
- 流量消峰

## 架构

![[Snipaste/Pasted image 20221023221552.png]]

### 基本概念

- Producer：消息生产者，向 Kafka 中发布消息的角色。
- Consumer：消息消费者，即从 Kafka 中拉取消息消费的客户端。
- Consumer Group：消费者组，消费者组则是一组中存在多个消费者，消费者消费 Broker 中当前 Topic 的不同分区中的消息，消费者组之间互不影响，所有的消费者都属于某个消费者组，即消费者组是逻辑上的一个订阅者。某一个分区中的消息只能够一个消费者组中的一个消费者所消费
- Broker：经纪人，一台 Kafka 服务器就是一个 Broker，一个集群由多个 Broker 组成，一个 Broker 可以容纳多个 Topic。
- Topic：主题，可以理解为一个队列，生产者和消费者都是面向一个 Topic
- Partition：分区，为了实现扩展性，一个非常大的 Topic 可以分布到多个 Broker 上，一个 Topic 可以分为多个 Partition，每个 Partition 是一个有序的队列 (分区有序，不能保证全局有序)
- Replica：副本 Replication，为保证集群中某个节点发生故障，节点上的 Partition 数据不丢失，Kafka 可以正常的工作，Kafka 提供了副本机制，一个 Topic 的每个分区有若干个副本，一个 Leader 和多个 Follower
- Leader：每个分区多个副本的主角色，生产者发送数据的对象，以及消费者消费数据的对象都是 Leader。
- Follower：每个分区多个副本的从角色，实时的从 Leader 中同步数据，保持和 Leader 数据的同步，Leader 发生故障的时候，某个 Follower 会成为新的 Leader。
- 流处理的功能
- 分布式的流处理平台，存储功能
- 版本
	- conluent platform
	- cloudera
	- 大数据
- AMQP 队列 信箱 绑定

![[Snipaste/Pasted image 20221023230957.png]]

- 每个主题有多个 partation 分区，同一个主题可以有一个或者多个分区

![[Snipaste/Pasted image 20221023231113.png]]

- offset —— id，消息一旦写入分区中就是不可变得。
- 分区可以理解为一个不可变得提交日志

## Reference

- [(141条消息) 看完这篇Kafka，你也许就会了Kafka_心的步伐的博客-CSDN博客_看完这篇kafka](https://blog.csdn.net/cao1315020626/article/details/112590786?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166653048816782428677886%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166653048816782428677886&biz_id=0&spm=1018.2226.3001.4187)
- [监听器和内外部网络_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1h94y1Q7Xg/?p=6&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
