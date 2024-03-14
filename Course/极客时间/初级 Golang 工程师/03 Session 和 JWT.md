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
- 授权：权限控制

这两者再加上授权（权限控制），就是信息安全的三个核心概念。

提供功能的时候需要考虑，**是否需要不同的实现**——面向接口编程

## 刷新 Session 的过期时间

> 举个例子：假如你设置为 10 分钟，那么用户登录了 9:59 秒之后，还能访问网站，结果过了两秒，他就被要求重新登录。

**需要在用户使用网站的时候刷新过期时间**，不然会被要求重新登录网站，体验不好。

几种策略：  

1. 用户每次访问，我都刷新。
	1. 性能差，对 Redis 之类的影响很大。
2. 快要过期了我再刷新，比如说 10 分钟过期。当用户第 9 分钟访问过来的时候，我就刷新。
	1. 万一我在第 9 分钟以后都没再访问过呢？——正好是 8.59 或者 10.01 访问呢？
3. **固定间隔时间刷新，比如说每分钟内第一次访问我都刷新。**
4. **使用长短 token。这个我们在后面接入微信登录的时候再深入讨论。**

在 Middleware 中进行刷新，登录校验的时候进行刷新。  

登录状态保持多久比较好？  
也就是，一次登录之后，要隔多久才需要继续登录？ 答案是取决于你的**产品经理**，也取决于你系统其它方面的安全措施。 简单来说，就是如果你有别的验证用户身份的机制，那么你就可以让用户长时间不需要登录。

## JWT

组成：  

- **Header**：头部，JWT 的**元数据**，也就是描述这个 token 本身的数据，一个 JSON 对象。
- **Payload**：负载，**数据内容**，一个 JSON 对象。
- **Signature**：签名，**根据 header 和 token 生成**。

```shell
go get github.com/golang-jwt/jwt/v5
```

登录过程中使用 JWT 的两步：

1. JWT 加密和解密数据
2. 登录校验

JWT 的基本使用方法

![[Snipaste/Pasted image 20240115163432.png]]

一定要进行跨域的设置

![[Snipaste/Pasted image 20240115163521.png]]

![[Snipaste/Pasted image 20240115163659.png]]

前端每次访问，携带 token  
![[Snipaste/Pasted image 20240115163738.png]]

JWT Token 的总结  

![[Snipaste/Pasted image 20240115164402.png]]

**JWT Token**

JWT（JSON Web Token）是一种开放标准（RFC 7519），用于在各方之间以 JSON 对象的形式安全地传输信息。由于其信息是数字签名的，因此可以被验证和信任。JWT 通常用于身份验证和信息交换，特别是在 Web 应用中用于实现无状态的认证机制。

JWT 的结构主要包含三个部分，它们之间以点（`.`）分隔：

1. **头部（Header）**：头部通常包含两部分信息，令牌的类型（即 "JWT"）和所使用的签名算法，如 HMAC SHA256 或 RSA。
2. **负载（Payload）**：负载部分包含所要传递的声明（Claim），声明是关于实体（通常指的是用户）和其他数据的声明。这些声明可以包含用户的身份信息、权限等，但应避免放入敏感数据，因为负载部分在客户端是可解码的。
3. **签名（Signature）**：为了创建签名部分，你必须采用编码后的头部、编码后的负载、一个密钥，使用头部中指定的算法进行签名。签名用于验证消息的发送者是谁以及消息在传输途中未被篡改。

### JWT 的使用流程大致如下

1. 用户使用用户名和密码登录。
2. 服务器验证用户的信息，如果验证成功，服务器将创建一个 JWT，然后把它发送回用户。
3. 客户端接收 JWT 并将其存储在本地，通常是在 localStorage 或 sessionStorage 中。
4. 客户端在之后的每个请求中将 JWT 发送给服务器。
5. 服务器验证 JWT 的签名，并从中提取用户信息来完成认证或其他操作。

### JWT 的优点包括

- **无状态和可扩展性**：服务器不需要保存用户的认证信息或会话状态，从而易于扩展。
- **安全性**：JWT 支持对称加密（HMAC）和非对称加密（RSA），确保了数据的安全性。
- **自包含**：JWT 包含了所有用户认证所需的信息，避免了多次查询数据库。

### 注意事项

尽管 JWT 在 Web 开发中非常流行，它也有一些潜在的安全问题，比如：

- 如果不使用 **HTTPS**，JWT **可能被拦截**。
- 一旦 JWT 被盗用，直到它过期之前，攻击者都可以使用它来访问系统资源。
- 默认情况下，JWT 的 Payload 是 Base64 编码的，而不是加密的，因此不应在 JWT 中放置任何敏感数据。

因此，使用 JWT 时需要谨慎处理安全相关的问题，确保通信渠道的安全，并合理设置 JWT 的过期时间。

---

和 Session 比起来，优点：

- 不依赖于第三方存储。
- 适合在分布式环境下使用。
- **提高性能**（因为没有 Redis 访问之类的）。  
缺点：
- **对加密依赖非常大**，比 Session 容易泄密。
- **最好不要在 JWT 里面放置敏感信息。**

**如何混用 session 和 JWT**

- 前面 JWT 限制了我们不能使用敏感数据，那么你真有类似需求的时候，就可以考虑将数据放在 “Session”里面。  
- 基本的思路就是：你在 JWT 里面存储你的 userId，然后用 userId 来组成 key，比如说 **user.info:123** 这 种 key，然后用这个 key 去 **Redis** 里面取数据，也可以考虑使用本地缓存数据。

## 初步保护系统

- 正常用户会不会搞崩你的系统？
- 如果有人攻击你的系统，你能撑住吗？  

对于中小型公司来说，第一条不会是问题。对于大公司来说，就要两条都考虑。  

- Redis + Gin 插件 + IP 限流 + 滑动窗口限流算法 + wrk 压测得到的。

泛型工具库的开发

1、课件见附件，APP 用户请前往网页版下载~

2、课程代码仓库：  
 https://gitee.com/geektime-geekbang_admin/geektime-basic-go

3、课上提及的所有链接汇总：  
 https://doc.weixin.qq.com/doc/w3_ABcA7QZGABw3IxUpG54SnyyLJiNUX?scode=ACQADQdwAAoZYCg124

Debug 的方式

1. 确定真正的入口在哪
2. 业务上打断点
   1. 停下来表示进入和业务
   2. 如果没进入，前面的 middleware 出错了
3. 层次鲜明，在每一层的入口打一个断点

**建立一个知识星球的库是不错的选择。**

![image-20240108091905057](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240108091905057.png)

## 深入讨论 Session

- 基于 cookie 的实现，基本不考虑
- gorm 可以帮助你存储到数据库种
- memcache
- memstore 基于内存的实现

基于 Redis 的实现。

HTTP 本身是无状态的，分布式环境的。

刷新登录状态：

1. 用户每次访问，都刷新 —— 性能差，对 Redis 之类的影响很大
2. 快要过期再刷新 —— 万一 9 分钟之后没有再访问过，浏览器缓存问题
3. 固定时间间隔刷新 —— 没分钟内第一次访问都刷新
4. **长短** token，接入微信
   1. 一个星期 长 token
   2. 如果长 token 存在，利用长 token 生成一 个短 token

redis.NewStore 更好的方式是将客户端传进来

Secure

![image-20240111101514454](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240111101514454.png)

生产环境要开启

- MaxAge 退出登录

定时刷新

- 配置中心，动态调整。

脑子中要有两份服务器，两个实例

>  使用毫秒数更加好一点，time.Time 不一定支持

gob.Register go object binary —— go 的方式编码为二进制

**gob.Register(time.Now())**——加上之后使用 time.Now 的使用

**gob** 是什么鬼？

gin session 插件的吐槽时间

session.Reflash —— 需要自己提供

gob 提前解析元数据，会非常的快。

### JWT Token

JSON Web Token

你用的加密算要足够的强

- Header
- Payload
- Signature —— 验证是否被篡改。

Gin JWT 不好用

- github.com/golang-jwt/jwt
- claims 代表的是数据
- 签名方法 signingMethod 代表了各种加密和签名方法
- 参数是 []byte

通过 ctx.Header 传递数据，将 x-jwt-token 保存在 Header 中。

 ![image-20240111144148688](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240111144148688.png)

- ExposeHeaders 要加上 []string{"x-jwt-token"} 前端才能拿到 jwt token
- 所以在 Header 里面返回给前端东西的时候，**要记得配置跨域选项**。

### LoginJWT

JWT 登录校验

1. 从 Authorization 中拿出来 token
2. 解析 JWT token

abort with status

user id 从哪里来呢？改造 login

携带用户的数据

- jwt.RegisterClaims

```go
type User struct {
	// 组合的结构体
    jwt.RegisterClaims
    
    Uid int64
}
```

- ParseWithClaims 里面一定要传指针
- 设置的值可以放在 gin.Context 里面
- 代码的问题，系统错误

JWT 的优缺点

- redis 布隆过滤器去实现 JWT 退出登录功能
- 基于 Redis 记录 token

UserClaims 的有效期

token 的续约关系。err 可以记录日志，需要日志组件。干好自己的事情。

 ![image-20240112095128278](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240112095128278.png)

JWT 续约代码

- 面向面试功能

### 保护系统

- 系统的漏洞
  - 注册和登录是关键的业务

限流：

1. 限流算法
2. 微服务的部分
   1. 限流 + 负载均衡
   2. 限流降级 + 特色部分

IP 只能代表一个出口，更好的使用 mac 地址。APP 可以拿到设备序列号。

压测得到的。共享 IP。IP 代理服务，肉鸡。

Gin 里面有很多的限流插件 Limit

- 单机限流
- 集群限流 基于 Redis 的

> 滑动串口算法，需要分布式锁
> 先检查、做某事 ---> 最容易出现并发问题的场景

限流算法，实现基于 redis 的 ip 限流，要求没有并发问题。

```lua
通过 lua 解决这种问题
```

部署多个实例

redis 统计数量 | **滑动窗口机制**

- HTTPS
- 识别攻击者和正常用户 —— **二次验证**

浏览器指纹信息

硬件信息相关的

IP 归属地的问题，token 的泄露问题，要求重新登录。—— 网络服务商

- User-Agent

浏览器升级，可以重新登录。

尽可能采集前端信息。—— 需要前端的同学配合

![image-20240116100104655](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240116100104655.png)

- 设置 mock

![image-20240116100228878](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240116100228878.png)

- 限流算法的实现

### 面试要点

![image-20240116100312964](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240116100312964.png)

## Kubernetes 部署入门

- Kubernetes 的二次开发 ---> 云原生的课程
- OCI 实现统一的 API

科学上网

- 交叉编译
- make 命令
- Dockerfile
- 用户只负责配置，kubernetes 知道如何解析这些配置
- apiVersion 指定如何解析这个配置
- spec 规格说明
- selector
  - matchLabels
  - matchExpresssions 表达式的时候。
- template 不同的 kind 对应不同的内容
  - containers：想不开可以多跑几个 container
- image

docker 符合 OCI 标准

- service
- spec
  - type: NodePort | LoadBalancer 暂时用负载均衡器

```she
kubectl apply -f xxx.yaml
```

- 配置文件 + 最佳实践

刚接触 kubernetes 的同学。

- HTTPS 的配置

domain 上定义不同的行为，验证邮箱应该在 domain 中

service 只关心我有这个数据就可以了

代码生成技术

- 反射
- 模板编程
- AST 抽象语法树的编程

builder 要保证你的**链式调用**

Build() 返回最终数据

中间方法，构建部分数据

**在 docker 里面编译很慢**

## 第三节

不要仅仅纠结在一个问题上。

部署 MySQL——考虑持久化的问题

PO persist object

![image-20240123160915061](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240123160915061.png)

![image-20240123161000429](C:\Users\zhang\AppData\Roaming\Typora\typora-user-images\image-20240123161000429.png)

```shel
go build -tags=k8s -o webook .
```

## 总结

先不要进行下面的内容了，先完成自己的系统。
