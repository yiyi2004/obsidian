- Time：2023-07-10 13:14
- Label：

## Abstract

## Content

```shell
docker run \
 --name mysql-redis \
 -e MYSQL_ROOT_PASSWORD=123456 \
 -p 3306:3306 \
 -v /tmp/mysql/conf/my.cnf:/etc/mysql/conf.d/hmy.cnf \
 -v /tmp/mysql/data:/var/lib/mysql \
 -d \
 mysql:5.7
```

```
docker run \
 --name mysql-redis \
 -e MYSQL_ROOT_PASSWORD=123456 \
 -p 3306:3306 \
 -d \
 mysql:5.7
```

```
docker update mysql --restart=always
sudo systemctl stop firewalld.service
sudo systemctl restart docker
docker start mysql
sudo docker exec -it mysql bash
mysql -uroot -p
select host,user,plugin,authentication_string from mysql.user;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'deeplocker';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'deeplocker';
```

```
sudo systemctl start firewalld.service
```

```
docker restart mysql
where is mysql
docker stop mysql
docker rmi 镜像ID
```

## Reference

- [Docker 安装 mysql8 并对外暴露端口方法_linux中启动的容器mysql暴露端口_tino.tang的博客-CSDN博客](https://blog.csdn.net/qq_36289377/article/details/124097436)
