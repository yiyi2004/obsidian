# SQL
![[Snipaste/Pasted image 20221027142740.png]]
- 一共就这几条命令，你还给分了一个类

## DDL 数据库操作
![[Snipaste/Pasted image 20221027142950.png]]
- urf8mb4 因为有些字符占四个字节，缩影用 utf8mb4 指定为默认字符集

![[Snipaste/Pasted image 20221027180022.png]]
![[Snipaste/Pasted image 20221027180253.png]]
![[Snipaste/Pasted image 20221027180430.png]]
- show create table tb_user

![[Snipaste/Pasted image 20221027182145.png]]

![[Snipaste/Pasted image 20221027182442.png]]
![[Snipaste/Pasted image 20221027182453.png]]
- 字符串类型
- BLOB 二进制数据，TEXT 文本数据
- char 固定字符串
- varchar 变长字符串

![[Snipaste/Pasted image 20221027182751.png]]

![[Snipaste/Pasted image 20221027183008.png]]
![[Snipaste/Pasted image 20221027183137.png]]
![[Snipaste/Pasted image 20221027183206.png]]
![[Snipaste/Pasted image 20221027183230.png]]
![[Snipaste/Pasted image 20221027183310.png]]

### 小结
![[Snipaste/Pasted image 20221027183345.png]]

## DataGrip
- JetBrain 全家桶中的一员，

## DML
- INSERT
- UPDATE
- DELETE
### INSERT

![[Snipaste/Pasted image 20221029200007.png]]

### UPDATE

![[Snipaste/Pasted image 20221029201227.png]]
- 如果不加 where 是对整张表进行操作，好细节哦。

### DELETE

![[Snipaste/Pasted image 20221029201345.png]]

### 小结
![[Snipaste/Pasted image 20221029201430.png]]

## DQL
- 数据查询语言

![[Snipaste/Pasted image 20221029201747.png]]

### 基本查询
![[Snipaste/Pasted image 20221029201910.png]]

![[Snipaste/Pasted image 20221029202120.png]]
- AS 是可以省略的
- distinct 去除重复记录

### 条件查询

![[Snipaste/Pasted image 20221029202315.png]]

![[Snipaste/Pasted image 20221029202650.png]]
![[Snipaste/Pasted image 20221029202907.png]]
- 模糊匹配是很有用的哦。

### 聚合函数
- 分组查询结合聚合函数进行查询

![[Snipaste/Pasted image 20221029203059.png]]
![[Snipaste/Pasted image 20221029205511.png]]
- 所有的 none 值是不计入聚合函数的统计的。

![[Snipaste/Pasted image 20221029205640.png]]

### 分组查询
- GROUP BY
- WHERE 中不使用聚合函数，而 HAVING 中可以使用聚合函数

![[Snipaste/Pasted image 20221029210240.png]]
- 通过使用别名来

![[Snipaste/Pasted image 20221029211132.png]]

- 分组之后的字段和聚合字段

### 排序查询
- ORDER BY
- 多字段排序
	- ASC
	- DESC

![[Snipaste/Pasted image 20221029211347.png]]

![[Snipaste/Pasted image 20221029211612.png]]

![[Snipaste/Pasted image 20221029211640.png]]
- 注意一下多字段学习

### 分页查询
- LIMIT
- 我真的服了啊，

![[Snipaste/Pasted image 20221029213128.png]]

![[Snipaste/Pasted image 20221029213208.png]]

![[Snipaste/Pasted image 20221029213345.png]]
- 注意查询第二页的数据和查询第一页有很大不同哦
- (页码 - 1) \* 每页展示的数据的个数
- 不同的数据库有不同的实现

### 练习

![[Snipaste/Pasted image 20221029213817.png]]
- 其实这种查询也不是很难哦。
- 我第一天就把所有工作都做完了。

### DQL 执行顺序
![[Snipaste/Pasted image 20221029214111.png]]
![[Snipaste/Pasted image 20221029214335.png]]
![[Snipaste/Pasted image 20221029214528.png]]
- 怎么感觉他讲的这些比本科学习的要简单很多，是我的错觉吗？what the fuck.


### 小结
![[Snipaste/Pasted image 20221029214727.png]]


## DCL
- 数据控制语言，哪些庸碌可以访问服务器，可以操作那几个数据库。
	- 数据库有哪些用户可以访问
	- 用户有哪些数据库的访问权限

![[Snipaste/Pasted image 20221029214900.png]]
![[Snipaste/Pasted image 20221029215006.png]]
- 通过用户名和主机地址就能定位
- localhost 表示只能在本机访问，不能从远程访问

## 多表问题


# FAQ
- 排序问题

# Reference
- [05. 基础-SQL-通用语法及分类_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Kr4y1i7ru?p=5&vd_source=25509bb582bc4a25d86d871d5cdffca3)