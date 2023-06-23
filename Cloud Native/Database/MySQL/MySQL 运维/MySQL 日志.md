- Time：2023-06-23 13:01
- Label： #mysql

## Abstract

1. 日志
2. 主从复制
3. 分库分表
4. 读写分离

- 错误日志
- 二进制日志
- 查询日志
- 慢查询日志

## Content

### 错误日志

1. 存放目录
2. 如何查看

```powershell
show variables like '%log_error%';

tail -f /var/log/mysqld.log
```

### 二进制日志

1. 介绍
2. 格式
3. 查看
4. 删除
	1. master
	2. 编号
	3. 时间
	4. 配置过期时间

binlog: 包含 DDL 和 DML 语句

```powershell
vim /etc/my.cnf

binlog_format=STATEMENT
```

然后会生成一个新的 binlog 文件，以为记录的格式发生了改变。

### 查询日志

1. 什么是查询日志
2. 如何进行配置
3. 如何查看

默认不开启的，记录 MySQL 的所有操作。

![[Snipaste/Pasted image 20230623133139.png]]

### 慢查询日志

1. 什么是慢查询日志

默认不开启

### 小结

1. 错误日志
2. 二进制日志
3. 查询日志
4. 慢查询日志

## Reference
