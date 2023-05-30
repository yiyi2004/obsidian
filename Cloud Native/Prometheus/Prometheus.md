#chatgpt #cloud #basic #prometheus

Prometheus 是一个**开源的系统监控和警报工具**，用于收集、存储和查询各种系统和服务的指标数据。它最初由 **SoundCloud** 开发，并于 2012 年发布，现已成为**云原生环境下广泛使用的监控解决方案之一**。

Prometheus 的核心特点包括：

1. **数据模型**：Prometheus 使用一个多维度的数据模型，其中指标由具有标签的时间序列数据组成。这种灵活的数据模型允许用户灵活地对指标进行查询和分析。
2. 支持多种数据采集方式：Prometheus 支持多种方式进行数据采集，包括直接通过客户端库进行指标采集、通过 Pushgateway 进行推送式采集、或者使用各种第三方工具和插件进行数据采集。
3. 强大的查询语言：Prometheus 提供了 PromQL 查询语言，可以用于对指标数据进行灵活的查询、聚合和计算。用户可以根据自己的需求编写查询语句，从而获取所需的指标数据。
4. 高效存储和数据保留策略：Prometheus 使用本地存储来存储采集的指标数据，具有高效的数据写入和查询性能。它还支持根据用户定义的保留策略自动清理过时的数据，以节省存储空间。
5. 可视化和警报：Prometheus 提供了 Grafana 等可视化工具的集成，可以将指标数据以图表和仪表盘的形式展示出来。同时，Prometheus 还支持根据用户定义的警报规则进行实时警报，以及通知和集成其他告警系统。

通过这些特点，Prometheus 为用户提供了一个强大的监控平台，能够实时监测系统和服务的性能、状态和健康状况，帮助用户及时发现和解决问题，提高系统的可靠性和可用性。

## Basic Architerture

![[Snipaste/architecture.svg]]

Prometheus

## Reference

- [prometheus/prometheus: The Prometheus monitoring system and time series database. (github.com)](https://github.com/prometheus/prometheus)
- [Prometheus - Monitoring system & time series database](https://prometheus.io/)
