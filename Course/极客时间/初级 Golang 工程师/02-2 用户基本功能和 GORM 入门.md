## GORM 入门

安装 GORM 依赖：

- 安装本体：go get -u gorm.io/gorm
- 安装对应数据库的驱动，注意 GORM 做了二次封装：go get -u gorm.io/driver/mysql

基本使用步骤：

- 初始化 DB 实例
- （可选）初始化表结构
- 发起查询

![[Snipaste/Pasted image 20240112104820.png]]

gorm 的标签每次复制，https://gorm.io/zhCN/docs/modelshtmlNocsm。

docker-compose 构建开发环境，编写配置文件，不比一点一点搭建开发环境容易多了？

**数据库相关代码放在那里？**

Handler 只负责和 HTTP 相关的东西。我们需要一个代表数据库抽象的东西。

![[Snipaste/Pasted image 20240112105949.png]]

- internal 代表内部代码
	- domain
	- repository
		- dao —— 数据库操作
		- cache 等等
	- service 代表一个业务的处理过程
	- web handler HTTP 相关代码
- pkg 项目中沉淀出的代码

深度理解这些内容：  

- 为什么有 repository 之后，还要有 dao？repository 是一个整体抽象，它里面既可以考虑用 ElasticSearch，也可以考虑使用 MySQL，还可以考虑用 MongoDB。所以它只代表数据存储，但是不 代表数据库。
- service 是拿来干嘛的？简单来说，就是组合各种 repository、domain，偶尔也会组合别的 service，来共同完成一个业务功能。
- domain 又是什么？它被认为是业务在系统中的直接反应，或者你直接理解为一个业务对象，又或者就是一个现实对象在程序中的反应。

![[Snipaste/Pasted image 20240112131540.png]]

改造代码：

```go
type UserService struct {
	repo *repository.UserRepository
}

type UserRepository struct {
	dao *dao.UserDAO
}

type UserDAO struct {
	db *gorm.DB
}

// 对吧
func (ud *UserDAO)Insert(ctx context.Context, u User) error {

}
```

![[Snipaste/Pasted image 20240112132739.png]]

domain.User 是**业务概念**，它不一定和数据库中表或者列完全对应得上。而 dao.User 则是直接映射到表里面的。

dao.User 对应数据库中的 User 表。

怎么建表呢？表结构的变更要走审批流程，leader 看，DBA 看。

![[Snipaste/Pasted image 20240112133030.png]]

main 函数应该如何组织呢？依赖注入方式

![[Snipaste/Pasted image 20240112133256.png]]

## 密码加密

密码是敏感信息，需要加密存储。**敏感信息应该是连日志都打不开**。

安全性依次升高：

1. md5 之类的 hash 算法
2. 1 + salt | 多次 hash
3. PBKDF2、BCrypt 这一类随机盐值加密算法，**同样的文本加密后的结果都不同**。

bcrypt 是一个号称最安全的加密算法。优点：

- 不需要你**自己去生成**盐值。
- 不需要**额外**存储盐值。
- 可以通过控制 **cost** 来控制加密性能。
- **同样的文本，加密后的结果不同**。
- golang.org/x/crypto

处理相同邮件的错误

![[Snipaste/Pasted image 20240112135249.png]]

传导错误与检测

![[Snipaste/Pasted image 20240112135500.png]]

## 登录和登录检验

两个重要的功能：

- 登录
- 登录校验

cookie 相关配置

- Domain: 也就是 Cookie 可以用在什么域名下，按照最小化原则来设定。example.com
- Path：Cookie 可以用在什么路径下，同样按照最小化原则来设定。 www.example.com/blog/article
- Max-Age 和 Expires：过期时间，只保留必要时间。  
- Http-Only：设置为 true 的话，那么**浏览器上的 JS 代码**将无法使用这个 Cookie。永远设置为 true。  
- Secure：只能用于 **HTTPS** 协议，**生产环境永远设置为 true**。  
- SameSite：是否允许跨站发送 Cookie，尽量避免。

sess_id 的存放位置

- cookie
- header
- 查询参数，太幽默了

Gin 的 session 插件：https://github.com/gin-contrib/sessions

session 的使用：

- 一个是在 middleware 里面接入，它会帮你从 Cookie 里面找到 sess_id，再根据 sess_id 找到对应的 Session。
- 另外一部分就是你拿到这个 Session 之后，就可以为所欲为了，例如这里用来校验是否登录。

登录校验的实现：

![[Snipaste/Pasted image 20240112140725.png]]

- 第一个 Sessions 是 Gin 帮我们提取 Session 的。
- 第二个是执行登录校验的。

## 升职加薪指南 (GORM)

- 为 GORM 提供**可观测性**的插件实现。
- 为 GORM 提供**读写分离**插件。
- 为 GORM 提供 **BeforeFind** 功能。
- 为 GORM 提供**辅助方法**。

MySQL 规范可以参考：https://developer.aliyun.com/special/tech-java

小公司的 review SQL 可以利用合并请求来达成，尤其是 DDL，最好不要依赖于 GORM 的 AutoMigrate，而是自己手动修改，更加保险一点。

## 面试要点

登录流程面试题：

- **什么是 Cookie，什么是 Session？**

Cookie  
Cookie 是由 web 服务器发送到用户浏览器并保存在本地的一小块数据，它会在浏览器下一次向同一服务器再发起请求时被携带并发送到服务器上。Cookie 主要用于：

**会话状态管理**（如用户登录状态、购物车内容）  
**个性化设置**（如用户选择的网站主题）  
**浏览器行为跟踪**（如跟踪分析用户行为）

Cookie 数据通常被编码为键值对（例如，name=value），并且 web 服务器可以设置 Cookie 的**过期时间**。如果不设置过期时间，则 Cookie 为会话级别，即浏览器关闭时会被删除。如果设置了过期时间，Cookie 将持久化存储直到过期时间到达。

**Session**  
Session 是另一种在服务器上存储和管理用户数据的机制。与 Cookie 直接存储在客户端不同，Session 数据存储在服务器上。服务器为**每个用户的会话分配一个唯一的标识符**（通常称为 Session ID），而 Session ID **通常通过 Cookie** 来在客户端和服务器之间传递。

Session 主要用于存储用户的会话信息，例如用户的登录状态和个人偏好。由于 Session 数据存储在服务器上，它通常被认为比存储在客户端的 Cookie 更安全。

**Cookie 与 Session 的比较**  
**存储位置**：Cookie 数据存储在客户端（浏览器），Session 数据存储在服务器。  
**安全性**：Session 比 Cookie 更安全，因为 Session 数据不会传输到客户端。  
**生命周期**：Cookie **可以设置为持久化存储**，而 Session **通常在用户会话结束时过期**。  
**资源开销**：Session 存储在服务器，可能会随着用户数量的增加而增加服务器的存储压力。而 Cookie 存储在客户端，不占用服务器资源。  

在 Web 应用开发中，开发者通常会结合使用 Cookie 和 Session 来管理用户的会话状态和数据，利用它们的优势来提供更安全、高效的用户体验。

- **Cookie 和 Session 比起来有什么缺点？**

1. **安全性较低**：由于 Cookie 存储在客户端，它们更容易被篡改或者通过跨站脚本攻击（XSS）被窃取，可能导致敏感信息泄露。
2. **大小限制**：Cookie 的大小通常限制在 4KB 左右，这限制了它们存储数据的容量。
3. **性能影响**：每次 HTTP 请求都会携带同一域名下的所有 Cookie，即使是请求静态资源，这可能会增加不必要的网络流量，从而影响加载时间。
4. **跨域问题**：Cookie 默认不支持跨域访问，虽然可以通过设置 `Access-Control-Allow-Credentials` 和 `Access-Control-Allow-Origin` 等响应头来实现跨域请求中的 Cookie 传输，但配置相对复杂。

- **Session ID 可以放在哪里？这个问题，你要记得提起 Cookie 禁用的问题。**

1. cookie
2. header
3. 查询参数

- **用户密码加密算法选取有什么注意事项？你用的是什么？**

安全性依次升高：

1. md5 之类的 hash 算法
2. 1 + salt | 多次 hash
3. PBKDF2、BCrypt 这一类随机盐值加密算法，**同样的文本加密后的结果都不同**。

bcrypt 是一个号称最安全的加密算法。优点：

- 不需要你**自己去生成**盐值。
- 不需要**额外**存储盐值。
- 可以通过控制 **cost** 来控制加密性能。
- **同样的文本，加密后的结果不同**。
- golang.org/x/crypto

处理相同邮件的错误

- **怎么做登录校验？核心是利用 Gin 的 middleware。**  

## 作业

![[Snipaste/Pasted image 20240112142343.png]]
