- ip addr
- 运维工程师一般是通过网络去链接服务器 ssh(不错的思路哦)
- ssh root@
- Linux 支持多用户同时登陆
- useradd aichijuzi
- passwd

```shell
[root@aichijuzi ~]# useradd aichijuzi
useradd: user 'aichijuzi' already exists
[root@aichijuzi ~]# passwd aichijuzi
Changing password for user aichijuzi.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
```

- rm -rf /* 慎用

![[Snipaste/Pasted image 20221009070912.png]]

- 文件权限
- chmod 777 /tmp/test.txt
- ls -l /tmp/test.txt
- 更改文件权限的操作
- chmod 770 /tmp/test.txt
- xxx.rpm：linux 下的软件包
- 阿里云镜像：https://developer.aliyun.com/mirror/
- 配置 yum 源
- wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
- 你忘记备份辣！
	- cd /etc/
- Epel 源: 第三方软件包。为了得到高分 ，你是需要好好准备一下的。
- ps -ef | grep nginx
- netstat -tunlp | grep nginx
- Tengine 高并发
- 虚拟机防火墙的问题

```shell
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
```

## Nginx

### 修改 Nginx 的首页

- rpm -ql nginx
- vim ---> dG 清空网页
- 写入一些新内容

## LAMP

![[Snipaste/Pasted image 20221010144238.png]]

```shell
[root@aichijuzi ~]# iptables -F
[root@aichijuzi ~]# systemctl stop firewall
Failed to stop firewall.service: Unit firewall.service not loaded.
[root@aichijuzi ~]# systemctl stop firewalld
[root@aichijuzi ~]# systemctl disable firewalld
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
```

apache 的名字是 httpd

```shell
yum insall net-tools -y
netstat -tunlp | grep httpd
```

![[Snipaste/Pasted image 20221010151741.png]]

- apache 服务器正确运行了
- 安装 Mysql(mariadb)——之前必须配置好镜像源

```shell
yum install mariadb-server mariadb -y
```

- 安装 php

```shell
yum install -y zlib-devel libxml2-devel libjpeg-devel \
libjpeg-turbo-devel libiconv-devel freetype-devel libpng-devel \
gd-devel libcurl-devel libxslt-devel libtool-ltdl-devel pcre \
pcre-devel apr apr-devel zlib-devel gcc make 

yum install php php-fpm php-mysql -y

vim /etc/httpd/conf/httpd.conf
```

- /DocumentRoot

```shell
systemctl restart httpd
```

- 更改完配置不要忘记重启服务哦。
- 看到 phpinfo() 证明环境搭建好了

## Discuz

- 基于 LAMP

```
yum install wget -y
wget http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip
docker pull tencentci/discuz
```

- 我的评价是我不评价

![[Snipaste/Pasted image 20221010155709.png]]

- /var/www/html

```shell
cp -r ./upload/* /var/www/html
```

- 给最高权限，方便操作。

```shell
chmod -R 777 /var/www/html/*
```

- 参数 -R 递归的进行权限的

## IP

- Snort3 —— 192.168.116.149

## Reference

- [（正版独家）2022年运维教程巅峰之作，听觉上的享受（Linux入门，系统运维，云计算）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1aG4y1e7gg/?spm_id_from=333.337.top_right_bar_window_custom_collection.content.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [centos镜像_centos下载地址_centos安装教程-阿里巴巴开源镜像站 (aliyun.com)](https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.3e221b11Q4G1Lu)
