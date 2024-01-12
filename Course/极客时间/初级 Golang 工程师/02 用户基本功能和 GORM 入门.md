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

## 密码加密

## 登录和登录检验
