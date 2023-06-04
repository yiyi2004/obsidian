## Go 语言进阶

### 8. 并发编程进阶

- 我们要尽可能避免竟态的情况出现
- 要避免多个 goroutine 去操作变量的情况。
- **不要通过共享内存来通信，而是通过通信来共享内存。**
- 但这不是一种共享内存的机制嘛？这是怎么实现的呢？

## Go 微服务课程

### Front-end Code

- go template
- bootstrape

## 带你十天轻松搞定 Go 微服务系列

### 环境搭建

- `Golang` 1.15+
- `Etcd`
- `Redis`
- `Mysql`
- `Prometheus`
- `Grafana`
- `Jaeger`
- `DTM`

```shell
gonivinck
├── dtm                   # DTM 分布式事务管理器
│   ├── config.yml        # DTM 配置文件
│   └── Dockerfile
├── etcd                  # Etcd 服务注册发现
│   └── Dockerfile
├── golang                # Golang 运行环境
│   └── Dockerfile
├── grafana               # Grafana 可视化数据监控
│   └── Dockerfile
├── jaeger                # Jaeger 链路追踪
│   └── Dockerfile
├── mysql                 # Mysql 服务
│   └── Dockerfile
├── mysql-manage          # Mysql 可视化管理
│   └── Dockerfile
├── prometheus            # Prometheus 服务监控
│   ├── Dockerfile
│   └── prometheus.yml    # Prometheus 配置文件
├── redis                 # Redis 服务
│   └── Dockerfile
├── redis-manage          # Redis 可视化管理
│   └── Dockerfile
├── .env                  # env 配置
└── docker-compose.yml
```

- 原来使这样用 docker 搭建开发环境的。

## Roadmap

### Building Microservices with GO

![[Snipaste/Pasted image 20220927225749.png]]  
![[Snipaste/Pasted image 20220927225806.png]]  
![[Snipaste/Pasted image 20220927225821.png]]  
![[Snipaste/Pasted image 20220927225832.png]]  
![[Snipaste/Pasted image 20220927225845.png]]  
![[Snipaste/Pasted image 20220927225854.png]]  
![[Snipaste/Pasted image 20220927225903.png]]

![[Snipaste/Pasted image 20220927225911.png]]  
![[Snipaste/Pasted image 20220927225921.png]]

### Roadmap(zhihu)

Day1 - 微服务简介、单体应用、微服务方案、微服务实践问题

- 微服务简介 - 构建单体应用 / 互联网公司架构
- 单体应用困境 - 应用发展趋势 / 困难与困境
- 复杂问题解决方案 - [微服务架构](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E6%9E%B6%E6%9E%84&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / 系统扩展性 / 微服务的优点 / 微服务不足
- [微服务实践](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E5%AE%9E%E8%B7%B5&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) - 微服务的定义 / 微服务实践要解决的问题 / 常见的微服务架构

Day2 - Protobuf 介绍、编程实现、Protobuf 语法

- Protobuf 介绍 - Protobuf 简介 / Protobuf 应用场景 / Protobuf 优点 / Protobuf 缺点
- 编程实现 Protobuf 传输 - 环境准备 / Protobuf 协议语法 / 使用 Protobuf 的步骤
- Protobuf 语法 - Protobuf 协议语法 / Protobuf 序列化原理  
Day3 - [微服务管理](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E7%AE%A1%E7%90%86&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)

Day4 - 服务发现原理、Consul 搭建及配置、服务的管理、[集群搭建](https://www.zhihu.com/search?q=%E9%9B%86%E7%BE%A4%E6%90%AD%E5%BB%BA&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)

- 服务发现 / 使用服务发现原因 / 服务发现方案 / Consul 介绍 / 分布式与单点故障 / Consul 环境配置 / Consul 内部原理 / Consul 启动 / Consul 节点发现

Day5 - 定义微服务、服务查询、集群搭建

- 服务管理 / 服务的定义 / 服务的注册与发现 / 服务查询 / 注册多个服务 / 多节点服务集群 / Docker 环境的搭建

Day6 - RPC 介绍、RPC 编程与实现、RPC 与 Protobuf 结合

- RPC 介绍 - RPC 简介及原理介绍 / 本地过程调用 / RPC 技术实现
- RPC 编程与实现 - RPC 官方库 / net/rpc 库实现 RPC 调用编程
- RPC 与 Protobuf 结合 - 传输数据格式定义 / Protobuf 格式数据与 RPC 结合

Day7 - gRPC 远程过程调用

Day8 - gRPC 介绍和安装、gRPC 框架的使用

- gRPC 介绍和安装 - 什么是 gRPC / [grpc-go](https://www.zhihu.com/search?q=grpc-go&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) 介绍
- gRPC 框架使用 - 定义服务 / 编译.proto 文件 / gRPC 实现 RPC 编程

Day9 - gRPC 编程使用、TLS 验证和 Token 认证、拦截器及自定义拦截器的使用

- gRPC 编程使用 - 服务端流 RPC / 编译.protoc 文件 / [服务端代码](https://www.zhihu.com/search?q=%E6%9C%8D%E5%8A%A1%E7%AB%AF%E4%BB%A3%E7%A0%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / 客户端代码生成 / 服务的注册监听处理 / 客户端数据接收 / 客户端流模式 / 双向流模式
- TLS 验证和 Token 认证 - [授权认证](https://www.zhihu.com/search?q=%E6%8E%88%E6%9D%83%E8%AE%A4%E8%AF%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / SSL/TLS 工作原理 / Token 认证过程 / 自定义 Token 认证拦截器的使用 - Interceptor 介绍 / 自定义 UnaryServerInterceptor / 拦截器注册

Day10-13 - go-micro 微服务框架

Day14 - micro 框架介绍及使用、micro 创建微服务

- micro 框架介绍 - 背景 / micro 概述介绍 / micro 组成 / micro 工具组件：API、Web、Sidecar、Bot / Go-Micro 特性 / consul 安装及环境准备
- 创建微服务 - 微服务的定义 / 初始化服务实例 / Options 可选项配置 / 定义服务接口,实现服务业务逻辑 / 微服务调用 / 自定义指定服务发现组件

Day15 - 心跳机制与可选项配置、[事件驱动机制](https://www.zhihu.com/search?q=%E4%BA%8B%E4%BB%B6%E9%A9%B1%E5%8A%A8%E6%9C%BA%E5%88%B6&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)

- 心跳机制与可选项配置 - 心跳机制的由来 / consul 心跳配置 / TTL 和间隔时间
- 事件驱动机制 - 发布/订阅机制 / Broker 组件设计 / go-plugins 安装 / MQTT 介绍及环境搭建 / 编程实现消息订阅和发布

Day16 - micro 框架 Selector 机制

- Selector 机制 - [负载均衡算法](https://www.zhihu.com/search?q=%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E7%AE%97%E6%B3%95&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / Mico 的 Selector / Selector 的定义 / DefaultSelector / registrySelector

Day17 - RESTful 设计和使用

- RESTful 设计规范及使用 - Go-Micro API 网关 / 安装 Micro 工具 / Micro API 工作原理 / [反向代理](https://www.zhihu.com/search?q=%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) 的 API 服务启动 / REST 映射

Day18-20 - 微服务项目开发

## Reference

- [(606) Scalable Scripts - YouTube](https://www.youtube.com/channel/UCljAHzX-PBxv6WrXkI2rnQw): 讲微服务的外国博主，当然还有其他视频哦。
- 好的就决定用购买的教程了，每天至少看一篇英文
- [Working with Microservices in Go (Golang) | Udemy](https://www.udemy.com/course/working-with-microservices-in-go/)
- [Go 语言如何进阶微服务？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/498359816/answer/2222497907)
- [带你十天轻松搞定 Go 微服务系列（一） | Go 技术论坛 (learnku.com)](https://learnku.com/articles/64566)
