- golang mongodb 的问题
- MapReduce 大数据工具

- document json string
- 介于关系型数据库和非关系型数据库之间
- 事务 ACID，redis，es
- mongodb 你可以当作 关系型数据库来做，存储的是 bson
- 关系型数据库需要更改表结构，而 mongo 不需要，加一个字段 version 区分版本
- 面向对象查询
- 文档 row 的概念

![[Snipaste/Pasted image 20221025220543.png]]

- 为什么选择 mongodb
	- 敏捷式的快速开发
		- 业务变化非常大
		- social
		- 如果是关系型数据库需要重新建表，逻辑修改。
	- 非常的清晰灵活
	- 高可用、高水平扩展能力
		- 延迟备份
		- replica set
		- 自恢复 raft
		- 多中心容灾能力
	- 分片，2TB，水平扩展
	- 需要时无限扩容 mongos 无限代理

- mongodb 的应用场景
	- 游戏场景
		- 装备信息
	- 物流场景 经常变化
	- 社交：地址空间索引
	- 物联网
	- 日志采集
	- 视频直播
	- 大数据

![[Snipaste/Pasted image 20221025221248.png]]

- 服务拆分，每个服务可能会用到不同的数据库。

![[Snipaste/Pasted image 20221025221408.png]]

# mongodb 使用
- 文档里面有安装的方式哦，mongo 的安装蛮简单的哦。如何才能写出这样一个数据库呢？
- 表结构，权限控制，分布式功能等等，是如何实现的呢？
- linux 配置环境变量，你需要一个 ubuntu 的开发环境
- ps -ef | grep mongo 查看 mongo 运行状态 use admin; db.shutdownServer()
- 
# Golang 操作 mongodb


# mongo-express
- [mongo-express/mongo-express: Web-based MongoDB admin interface, written with Node.js and express (github.com)](https://github.com/mongo-express/mongo-express)
- mongodb 的 web 管理界面
- 可以用 docker-compose,yml 启动


# Reference
- [2022B站最新的MongoDB视频教程，一节课带你从0基础到实战操作，保姆级教学！！！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1CS4y1e7Pb/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)