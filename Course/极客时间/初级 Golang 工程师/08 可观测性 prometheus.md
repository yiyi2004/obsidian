- 可观测性的基本概念
- prometheus 入门
- prometheus 埋点技巧
- opentelemetry 入门
- 接入 otel
- 监控和告警

## 可观测性

1. logging
2. metrics 性能和行为
3. tracing 监测系统的请求与响应

Metrics 是就是可度量可聚合的数据。

![image-20240306202133371](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306202133371.png)

Tracing 链路追踪

![image-20240306202255637](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306202255637.png)

![image-20240306202341049](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306202341049.png)

- 如果很多空隙很长，则往往意味着需要补充打点

## Prometheus 入门

- prometheus 安装
- prometheus API
  - counter
  - gauge
  - histogram
  - summary

![image-20240306204253607](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306204253607.png)

1. prometheus client
2. server
3. database
4. grafana
5. 服务器主动轮询数据

![image-20240306204933618](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306204933618.png)

- prometheus 配置文件 + 启动方案

## Prometheus API 入门

指标类型

![image-20240306205213329](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205213329.png)

![image-20240306205537001](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205537001.png)

- 度量：可以增加，可以减少
- 统计当前正在执行的 HTTP 请求数量
- 统计当前本实例开启的数据库事务数量
- 统计下游服务的可用节点
- 统计当前在线人数等 (业务相关)

我说实话，我有点困哦，怎么回事呢。

![image-20240306205734598](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205734598.png)

![image-20240306205811392](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205811392.png)

按照百分位进行统计。有没有可能是重要的，我完善一下系统。

1. 安装 SDK：go get github.com/prometheus/client_golang/prometheus@latest

通用配置

![[Snipaste/Pasted image 20240307084917.png]]

- namespace
- subsystem
- name 采集数据的名字

![[Snipaste/Pasted image 20240307085131.png]]

- 分桶
- 根据自己的需求灵活的分配

summary

![[Snipaste/Pasted image 20240307085301.png]]

verctor 的使用方法

![[Snipaste/Pasted image 20240307090751.png]]

1. 根据业务特征来采集
2. Label  
	1. 固定 Label：所有的业务取值都一样
	2. 动态的 Label：根据业务来取值

## Prometheus 埋点技巧

- Gin Middleware 埋点
	- Summary 响应时间解读
- GORM 埋点
	- GORM 官方插件
	- 监控 SQL 执行时间
- 监控业务错误码
	- 错误码规范
- 监控第三方调用

在 Middleware 里面统计响应时间（最关键的指标，反应业务代码的性能）  
![[Snipaste/Pasted image 20240307091323.png]]

- 利用 Gin Middleware 来统计 HTTP 请求

![[Snipaste/Pasted image 20240307091831.png]]

- Summary 响应时间解读 #不懂

统计活跃请求数

![[Snipaste/Pasted image 20240307091947.png]]

- 通过 Gauge 来统计当前请求数量
- 在中间件中，defer 是一个常见的操作，执行完成业务代码之后回来执行 defer 中的内容
	- 可以用来处理进入一个 HTTP 请求的预处理和返回之后的处理。

## GORM 的 Plugin 统计数据

- prometheus

![[Snipaste/Pasted image 20240307092242.png]]

- 采集时间
- user defined metrics

GORM 插件自带的内容

![[Snipaste/Pasted image 20240307092400.png]]

- [Prometheus | GORM - The fantastic ORM library for Golang, aims to be developer friendly.](https://gorm.io/docs/prometheus.html)

![[Snipaste/Pasted image 20240307092520.png]]

- 解读 GORM 统计的数据 #不懂

统计 SQL 执行时间  
![[Snipaste/Pasted image 20240307101311.png]]

![[Snipaste/Pasted image 20240307101331.png]]

- 具体实现

错误码的设计

![[Snipaste/Pasted image 20240307101437.png]]

1. 特殊关注的错误才需要非常具体的错误码
2. 其他时候含糊使用系统错误活用户输入错误来表达

![[Snipaste/Pasted image 20240307101655.png]]

- 错误码示例

![[Snipaste/Pasted image 20240307101838.png]]

- 统一监控错误码

![[Snipaste/Pasted image 20240307101923.png]]

1. 监控第三方调用：短信服务、微信平台的 HTTP 接口
2. 装饰器模式
3. 可以考虑监控返沪 ide 错误码，深入实现细节，无法统一监控。

![[Snipaste/Pasted image 20240307102054.png]]

- 监控微信 API

引入监控模块，请求响应时间，并不是很难。

通过 Redis Hook API 监控缓存

![[Snipaste/Pasted image 20240307102341.png]]

## 升职加薪指南

![[Snipaste/Pasted image 20240307102609.png]]

1. 系统出入口，业务关键点，完善监控
