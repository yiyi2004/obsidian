- Gin 入门
- webook WEB 结构
- 跨域问题
- GORM 入门
- 设计项目结构
- 定义用户模型
- 密码加密
- 登录功能
- 深入讨论 Session
- JWT
- 保护登录系统

## Gin 入门

Gin 的学习要点：

- 如何定义路由：包括参数路由、通配符路由
- 如何处理输入输出
- 如何使用 middlew

are 解决 AOP 问题

## Webook WEB 结构

- 集中注册和分散注册  
![[Snipaste/Pasted image 20240112100459.png]]

- 分组路由简化注册

![[Snipaste/Pasted image 20240112100620.png]]

- 目录结构

internal: 放着我们所有的业务代码  
pkg: 沉淀出来可以给其他项目使用的东西

- 预编译正则表达式

![[Snipaste/Pasted image 20240112102649.png]]

- github.com/dlclark/regexp2

整体校验，要区分不同的错误：

![[Snipaste/Pasted image 20240112102735.png]]

## 跨域问题

- preflight 请求

gin 跨域问题解决方案：

- https://github.com/gin-gonic/contrib

![[Snipaste/Pasted image 20240112103032.png]]

middleware 的其他名字：

1. plugin
2. handler
3. filter
4. interceptor

所有业务都关心的东西，AOP 方案

CORS Middleware

- AllowCrendentials：是否允许带上用户认证信息（比如 cookie）。
- AllowHeader：业务请求中可以带上的头。
- ExposeHeader: 可以在 response 中设置的 Header 头，比如 x-jwt-token 这些自定义的字段。
- AllowOriginFunc：哪些来源是允许的。

![[Snipaste/Pasted image 20240112103407.png]]

这个 middleware 设置了 Access-Control 家族的几个 Header，这是解决跨越问题的关键。preflight 请求如下。

## 升职加薪指南

## 面试要点
