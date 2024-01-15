## 多实例部署的 Session 问题

答案是 Gin 本身提供了很多的实现，包括:

- cookie：基于内存的实现
- gorm：基于 GORM 的实现
- memcached：基于 Memcached 的实现
- memstore：基于内存的实现
- mongo：基于 MongoDB 的实现
- postgres：基于 PostgreSQL 的实现
- redis：基于 Redis 的实现
- tester：用于测试的实现  

基于 Redis 实现

![[Snipaste/Pasted image 20240115162229.png]]

- **Authentication**：是指身份认证。
- **Encryption**：是指数据加密。  

这两者再加上授权（权限控制），就是信息安全的三个核心概念。

提供功能的时候需要考虑，**是否需要不同的实现**——面向接口编程

## 刷新 Session 的过期时间

举个例子：假如你设置为 10 分钟，那么用户登录了 9:59 秒之后，还能访问网站，结果过了两秒，他就被要求重新登录。

## JWT

## 初步保护系统
