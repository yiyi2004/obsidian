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

