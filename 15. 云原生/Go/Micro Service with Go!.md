# Go 语言进阶

## 8. 并发编程进阶
- 我们要尽可能避免竟态的情况出现
- 要避免多个 goroutine 去操作变量的情况。
- **不要通过共享内存来通信，而是通过通信来共享内存。**
- 但这不是一种共享内存的机制嘛？这是怎么实现的呢？

# Go 微服务课程
## Front-end Code
- go template
- bootstrape

# 带你十天轻松搞定 Go 微服务系列
## 环境搭建
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

# Roadmap
## Building Microservices with GO

![[Pasted image 20220927225749.png]]
![[Pasted image 20220927225806.png]]
![[Pasted image 20220927225821.png]]
![[Pasted image 20220927225832.png]]
![[Pasted image 20220927225845.png]]
![[Pasted image 20220927225854.png]]
![[Pasted image 20220927225903.png]]

![[Pasted image 20220927225911.png]]
![[Pasted image 20220927225921.png]]

## Roadmap(zhihu)
  
Day1 - 微服务简介、单体应用、微服务方案、微服务实践问题
- 微服务简介 - 构建单体应用 / 互联网公司架构
- 单体应用困境 - 应用发展趋势 / 困难与困境
- 复杂问题解决方案 - [微服务架构](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E6%9E%B6%E6%9E%84&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / 系统扩展性 / 微服务的优点 / 微服务不足
- [微服务实践](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E5%AE%9E%E8%B7%B5&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) - 微服务的定义 / 微服务实践要解决的问题 / 常见的微服务架构

Day2 - Protobuf介绍、编程实现、Protobuf语法
- Protobuf介绍 - Protobuf简介 / Protobuf应用场景 / Protobuf 优点 / Protobuf 缺点
- 编程实现Protobuf传输 - 环境准备 / Protobuf 协议语法 / 使用Protobuf的步骤
- Protobuf语法 - Protobuf 协议语法 / Protobuf序列化原理
Day3 - [微服务管理](https://www.zhihu.com/search?q=%E5%BE%AE%E6%9C%8D%E5%8A%A1%E7%AE%A1%E7%90%86&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)

Day4 - 服务发现原理、Consul搭建及配置、服务的管理、[集群搭建](https://www.zhihu.com/search?q=%E9%9B%86%E7%BE%A4%E6%90%AD%E5%BB%BA&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)
- 服务发现 / 使用服务发现原因 / 服务发现方案 / Consul介绍 / 分布式与单点故障 / Consul环境配置 / Consul内部原理 / Consul启动 / Consul节点发现

Day5 - 定义微服务、服务查询、集群搭建

- 服务管理 / 服务的定义 / 服务的注册与发现 / 服务查询 / 注册多个服务 / 多节点服务集群 / Docker环境的搭建

Day6 - RPC介绍、RPC编程与实现、RPC与Protobuf结合
-   RPC介绍 - RPC简介及原理介绍 / 本地过程调用 / RPC技术实现
-   RPC编程与实现 - RPC官方库 / net/rpc库实现RPC调用编程
-   RPC与Protobuf结合 - 传输数据格式定义 / Protobuf格式数据与RPC结合

Day7 - gRPC远程过程调用

Day8 - gRPC介绍和安装、gRPC框架的使用
- gRPC介绍和安装 - 什么是gRPC / [grpc-go](https://www.zhihu.com/search?q=grpc-go&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)介绍
- gRPC框架使用 - 定义服务 / 编译.proto文件 / gRPC实现RPC编程

Day9 - gRPC编程使用、TLS验证和Token认证、拦截器及自定义拦截器的使用
- gRPC编程使用 - 服务端流RPC / 编译.protoc文件 / [服务端代码](https://www.zhihu.com/search?q=%E6%9C%8D%E5%8A%A1%E7%AB%AF%E4%BB%A3%E7%A0%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / 客户端代码生成 / 服务的注册监听处理 / 客户端数据接收 / 客户端流模式 / 双向流模式
- TLS验证和Token认证 - [授权认证](https://www.zhihu.com/search?q=%E6%8E%88%E6%9D%83%E8%AE%A4%E8%AF%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / SSL/TLS工作原理 / Token认证过程 / 自定义Token认证拦截器的使用 - Interceptor介绍 / 自定义UnaryServerInterceptor / 拦截器注册

Day10-13 - go-micro微服务框架

Day14 - micro框架介绍及使用、micro创建微服务
- micro框架介绍 - 背景 / micro概述介绍 / micro组成 / micro工具组件：API、Web、Sidecar、Bot / Go-Micro特性 / consul安装及环境准备
- 创建微服务 - 微服务的定义 / 初始化服务实例 / Options可选项配置 / 定义服务接口,实现服务业务逻辑 / 微服务调用 / 自定义指定服务发现组件

Day15 - 心跳机制与可选项配置、[事件驱动机制](https://www.zhihu.com/search?q=%E4%BA%8B%E4%BB%B6%E9%A9%B1%E5%8A%A8%E6%9C%BA%E5%88%B6&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)
- 心跳机制与可选项配置 - 心跳机制的由来 / consul心跳配置 / TTL和间隔时间
- 事件驱动机制 - 发布/订阅机制 / Broker组件设计 / go-plugins安装 / MQTT介绍及环境搭建 / 编程实现消息订阅和发布

Day16 - micro框架Selector机制
- Selector机制 - [负载均衡算法](https://www.zhihu.com/search?q=%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E7%AE%97%E6%B3%95&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D) / Mico的Selector / Selector的定义 / DefaultSelector / registrySelector

Day17 - RESTful设计和使用
- RESTful设计规范及使用 - Go-Micro API网关 / 安装Micro工具 / Micro API工作原理 / [反向代理](https://www.zhihu.com/search?q=%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A%222222497907%22%7D)的API服务启动 / REST 映射

Day18-20 - 微服务项目开发

# Reference
- [(606) Scalable Scripts - YouTube](https://www.youtube.com/channel/UCljAHzX-PBxv6WrXkI2rnQw):讲微服务的外国博主，当然还有其他视频哦。
- 好的就决定用购买的教程了，每天至少看一篇英文
- [Working with Microservices in Go (Golang) | Udemy](https://www.udemy.com/course/working-with-microservices-in-go/)
- [Go 语言如何进阶微服务？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/498359816/answer/2222497907)
- [带你十天轻松搞定 Go 微服务系列（一） | Go 技术论坛 (learnku.com)](https://learnku.com/articles/64566)
