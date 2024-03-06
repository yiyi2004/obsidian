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

## Prometheus  API 入门

指标类型

![image-20240306205213329](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205213329.png)

![image-20240306205537001](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205537001.png)

- 度量：可以增加，可以减少
- 统计当前正在执行的 HTTP 请求数量
- 统计当前本实例开启的数据库事务数量
- 统计下游服务的可用节点
- 统计当前在线人数等(业务相关)

我说实话，我有点困哦，怎么回事呢。

![image-20240306205734598](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205734598.png)

![image-20240306205811392](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240306205811392.png)

按照百分位进行统计。有没有可能是重要的，我完善一下系统。