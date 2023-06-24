## 免去 Sudo

![[../Snipaste/Pasted image 20221002113338.png]]  
![[../Snipaste/Pasted image 20221002113416.png]]  
![[../Snipaste/Pasted image 20221002113749.png]]

- 微服务的架构图

## 微服务基本特点

1. 统一入口 HTTP 接口
2. 对内服务特别多：接口、数据库、redis、消息队列、日志收集

将测试代码放入微服务架构内

1. 将测试代码打包成镜像
2. 容器编排，让容器一起运行

## Docker-compose

- 用于定义和运行多容器的 docker 工具
- 通过 yaml 配置程序和服务
- 使用单个命令创建并启动多个容器
- 相当于起了写了一个脚本而已

### 1. Docker-compose Installation

- [(126条消息) Centos7 安装docker-compose过程_IMK7的博客-CSDN博客_centos7安装docker-compose](https://blog.csdn.net/yidragon88xx/article/details/124409550?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166469856716800184148163%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166469856716800184148163&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-124409550-null-null.142^v51^control,201^v3^add_ask&utm_term=centos7%E5%AE%89%E8%A3%85docker-compose&spm=1018.2226.3001.4187)
- ubuntu 安装 sudo apt install docker-compose(不过注意要指定版本)
- 安装还是尽量安装稳定的版本哦

```shell
wget https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
docker-compose version
```

https://github.com/docker/compose/releases

### 2. Command

### 3. docker-compose.yaml

- yaml 语法
- CI/CD 都是用 yaml 进行配置的，要学会哦！

docker-compose 内容结构

![[../Snipaste/Pasted image 20221002162536.png]]  
![[../Snipaste/Pasted image 20221002162619.png]]  
![[../Snipaste/Pasted image 20221002162820.png]]

- 总体描述

![[../Snipaste/Pasted image 20221002162958.png]]

- 环境变量传递参数
- 容器之间的关系 (依赖)

## 编排容器

接口项目容器 + 测试框架容器 = 测试结果容器

### 1. 构建镜像

- 编排的前提是构建镜像
- 如何确定自己使用的版本呢？
- 怪不得 Gin 的 example 中会通过环境变量去获得服务的参数。
- 以后不要说我不是很了解这种话，你为什么不去了解呢？你说这种话我会很生气的！

![[../Snipaste/Pasted image 20221002164233.png]]

- stopping: v2_test_api_server_1
- 名字是和文件夹的名字有关联的，所以最好去找一个文件夹去创建。

### 3. 构建测试镜像

## Docker 复杂场景搭建

```shell
docker run -p 3307:3306 --name mysql-master \
-v /mydata/mysql-master/log:/var/log/mysql \
-v /mydata/mysql-master/data:/var/lib/mysql \
-v /mydata/mysql-master/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root  \
--privileged=true \
-d mysql:5.7
```

- 进入 /mydata/mysql-master/conf 中 create my.cnf

```shell
[mysqld]
## 设置server_id，同一局域网中需要唯一
server_id=101 
## 指定不需要同步的数据库名称
binlog-ignore-db=mysql  
## 开启二进制日志功能
log-bin=mall-mysql-bin  
## 设置二进制日志使用内存大小（事务）
binlog_cache_size=1M  
## 设置使用的二进制日志格式（mixed,statement,row）
binlog_format=mixed  
## 二进制日志过期清理时间。默认值为0，表示不自动清理。
expire_logs_days=7  
## 跳过主从复制中遇到的所有错误或指定类型的错误，避免slave端复制中断。
## 如：1062错误是指一些主键重复，1032错误是因为主从数据库数据不一致
slave_skip_errors=1062
```

- [(126条消息) ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)_渣渣的夏天的博客-CSDN博客](https://blog.csdn.net/qq_39564555/article/details/102520778?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166475387716782248526690%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166475387716782248526690&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-102520778-null-null.142^v51^control,201^v3^add_ask&utm_term=ERROR%201045%20%2828000%29%3A%20Access%20denied%20for%20user%20root%40localhost%20%28using%20password%3A%20YES%29&spm=1018.2226.3001.4187)——太折磨辣

```shell
docker run -p 3308:3306 --name mysql-slave \
-v /mydata/mysql-slave/log:/var/log/mysql \
-v /mydata/mysql-slave/data:/var/lib/mysql \
-v /mydata/mysql-slave/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root  \
--privileged=true \
-d mysql:5.7
```

```shell
[mysqld]

## 设置server_id，同一局域网中需要唯一

server_id=102

## 指定不需要同步的数据库名称

binlog-ignore-db=mysql  

## 开启二进制日志功能，以备Slave作为其它数据库实例的Master时使用

log-bin=mall-mysql-slave1-bin  

## 设置二进制日志使用内存大小（事务）

binlog_cache_size=1M  

## 设置使用的二进制日志格式（mixed,statement,row）

binlog_format=mixed  

## 二进制日志过期清理时间。默认值为0，表示不自动清理。

expire_logs_days=7  

## 跳过主从复制中遇到的所有错误或指定类型的错误，避免slave端复制中断。

## 如：1062错误是指一些主键重复，1032错误是因为主从数据库数据不一致

slave_skip_errors=1062  

## relay_log配置中继日志

relay_log=mall-mysql-relay-bin  

## log_slave_updates表示slave将复制事件写进自己的二进制日志

log_slave_updates=1  

## slave设置为只读（具有super权限的用户除外）

read_only=1

# skip-grant-tables
```

![[../Snipaste/Pasted image 20221003115814.png]]

```shell
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Zx962464';
flush privileges;
```

- CREATE USER 'slave'@'%' IDENTIFIED BY '123456';
- GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';

change master to master_host='192.168.116.138', master_user='slave', master_password='Zx962464', master_port=3307, master_log_file='mall-mysql-bin.000004', master_log_pos=154, master_connect_retry=30;

- linux 真的好多坑，我真的醉了。
- docker-compose
	- service
	- project

![[../Snipaste/Pasted image 20221004185802.png]]  
![[../Snipaste/Pasted image 20221004185911.png]]

- 通过 Dockerfile 构建镜像，然后通过 docker-compose 部署服务

![[../Snipaste/Pasted image 20221004190135.png]]

- 所以现在你要做的事情
- [ ] 通过 Dockerfile 构建镜像
	- [ ] 有漏洞的 Web APP
	- [ ] Snort3 ++
	- [ ] MySQL(主从服务)
- [ ] 通过 docker-compose.yaml 去部署服务

## Reference

- [Docker_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1NS4y1Q75t?p=1&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [(127条消息) Slave_IO_Running：Connecting ；_Java小白白又白的博客-CSDN博客_slaveiorunning为connect](https://blog.csdn.net/qq_36756682/article/details/109647266?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166477311716782390536868%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166477311716782390536868&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-109647266-null-null.142^v51^control,201^v3^add_ask&utm_term=%20%20%20%20%20%20%20%20%20%20%20%20%20Slave_IO_Running%3A%20Connecting&spm=1018.2226.3001.4187)
- [(127条消息) Error response from daemon: driver failed programming external connectivity on endpoint redis-1_Tom-东的博客-CSDN博客](https://blog.csdn.net/m0_37800387/article/details/124191239?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166478259216782388015851%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166478259216782388015851&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-124191239-null-null.142^v51^control,201^v3^add_ask&utm_term=Error%20response%20from%20daemon%3A%20driver%20failed%20programming%20external%20connectivity%20on%20endpoint%20mysql-master%20%289eb9232ece056243e298bd11e62b1c84257e3753e3aea3b102b78685a26a601e%29%3A%20%20%28iptables%20failed%3A%20iptables%20--w&spm=1018.2226.3001.4187)
