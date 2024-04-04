- 商业化解决方案
- 分布式的流处理平台
- 特点  
![[Snipaste/Pasted image 20221024180558.png]]

- JMS
- AMQP
	- 队列
	- 信箱
	- 绑定
	- rabbit mq
- topic ---> partition 同一个主题可能有一个或者多个分区

![[Snipaste/Pasted image 20221024180808.png]]

- offset
- 不可变的提交日志

![[Snipaste/Pasted image 20221024180934.png]]

- 每个分区都有一个 broker(一般一个服务器上部署一个 broker) 作为 leader 另一个 broker 作为 follower
- 绿色代表主副本，红色代表副副本
- 读写请求，同步 par 保持数据一致 (ES 也是)
- segment 形式存储，后面会讲到
- 消费者保存 offset 记录消费位置
- 消费者主
- java 编写

## Go Client for Kafka

- github.com/Shopify/sarama

## Reference

- [监听器和内外部网络_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1h94y1Q7Xg/?p=6&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
