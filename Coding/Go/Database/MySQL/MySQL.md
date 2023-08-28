我的建议是：[MySQL数据库教程天花板，mysql安装到mysql高级，强！硬！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1iq4y1u7vj/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)

- [(126条消息) ERROR: mysqld failed while attempting to check config_MyNAMS的博客-CSDN博客](https://blog.csdn.net/MyNAMS/article/details/121173241?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166470456216782412563910%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166470456216782412563910&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-121173241-null-null.142^v51^control,201^v3^add_ask&utm_term=%5BERROR%5D%20%5BEntrypoint%5D%3A%20mysqld%20failed%20while%20attempting%20to%20check%20config%20%20%20%20%20%20%20%20%20command%20was%3A%20mysqld%20--verbose%20--help%20--log-bin-index%3D%2Ftmp%2Ftmp.d9UObw7ZuQ%20%20%20%20%20%20%20%20%20mysqld%3A%20Cant%20read%20dir%20of%20%2Fetc%2Fmysql%2Fconf&spm=1018.2226.3001.4187)

```shell
docker run -p 3306:3306 --name mysql \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=root -d mysql:8.0.16
```

![[Snipaste/Pasted image 20221002175819.png]]

- okok 问题不大
- 设置主节点

```shell
docker run -p 3306:3306 --name mysql-master \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root -d mysql:latest
```

```
docker run -p 3306:3306 --name mysql \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

- 注意要设置主从服务器哦
- 要注意目录映射哦

## Grant

- [(143条消息) MySQL的Grant命令_高压锅_1220的博客-CSDN博客_mysql的grant](https://blog.csdn.net/u014651560/article/details/100928600?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166666955216782417082692%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166666955216782417082692&biz_id=0&spm=1018.2226.3001.4187)

### 创建用户

命令: CREATE USER 'username'@'host' IDENTIFIED BY 'password';

说明:username - 你将创建的用户名, host - 指定该用户在哪个主机上可以登陆,如果是本地用户可用 localhost, 如果想让该用户可以从任意远程主机登陆,可以使用通配符%. password - 该用户的登陆密码,密码可以为空,如果为空则该用户可以不需要密码登陆服务器.

```shell
CREATE USER 'dog'@'localhost' IDENTIFIED BY '123456'; 
CREATE USER 'pig'@'192.168.1.101_' IDENDIFIED BY '123456'; 
CREATE USER 'pig'@'%' IDENTIFIED BY '123456'; 
CREATE USER 'pig'@'%' IDENTIFIED BY ''; 
CREATE USER 'pig'@'%'; 
```

### 授权

命令 `:GRANT privileges ON databasename.tablename TO 'username'@'host'`

说明: privileges - 用户的操作权限,如 SELECT , INSERT , UPDATE 等 (详细列表见该文最后面).如果要授予所的权限则使用 ALL.;databasename - 数据库名,tablename- 表名,如果要授予该用户对所有数据库和表的相应操作权限则可用表示, 如.*.

```shell
# 例子: GRANT SELECT, INSERT ON test.user TO 'pig'@'%'; 
GRANT ALL ON *.* TO 'pig'@'%'; 
# 注意:用以上命令授权的用户不能给其它用户授权,如果想让该用户可以授权,用以下命令:
GRANT privileges ON databasename.tablename TO ‘username’@‘host’ WITH GRANT OPTION;
```

### 设置和更改用户密码

```shell
命令:SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');如果是当前登陆用户用SET PASSWORD = PASSWORD("newpassword");

例子: SET PASSWORD FOR 'pig'@'%' = PASSWORD("123456");
```

### 撤销用户权限

```shell
REVOKE privilege ON databasename.tablename FROM 'username'@'host';
```

说明: privilege, databasename, tablename - 同授权部分.

例子: REVOKE SELECT ON . FROM ‘pig’@’%’;

注意: 假如你在给用户’pig’@’%‘授权的时候是这样的 (或类似的):GRANT SELECT ON test.user TO ‘pig’@’%’, 则在使用 REVOKE SELECT ON . FROM ‘pig’@’%’; 命令并不能撤销该用户对 test 数据库中 user 表的 SELECT 操作.相反,如果授权使用的是 GRANT SELECT ON . TO ‘pig’@’%’; 则 REVOKE SELECT ON test.user FROM ‘pig’@’%’; 命令也不能撤销该用户对 test 数据库中 user 表的 Select 权限.

具体信息可以用命令 SHOW GRANTS FOR ‘pig’@’%’; 查看.

### 删除用户

- 你不要仅仅处于一种表面的理解了，你要进行更深层次的思考
- 后面的需要进一步学习哦
