- 指令大写字母，内容写小写字母
- 按照顺序执行
- FROM 开始，声明镜像的低包
- 首先会从本地查找指定镜像

- MAINTAINER
- USER
![[Pasted image 20220929184107.png]]
- linux grep 指令
- docker inspect image | grep User
![[Pasted image 20220929184831.png]]
- WORKDIR：启动容器后的工作目录(容器内)
![[Pasted image 20220929185255.png]]
- 不同的基准镜像，默认的东西是不同的。那么工作目录的意义是什么呢？
- ADD/COPY 将宿主机的文件复制到镜像中
	- ADD 可以将压缩包解压之后上传到镜像中
	- COPY 不存在解压的操作
![[Pasted image 20220929185701.png]]

![[Pasted image 20220929193559.png]]
![[Pasted image 20220929193622.png]]
![[Pasted image 20220929193647.png]]
![[Pasted image 20220929193749.png]]

- 仅仅是端口声明

![[Pasted image 20220929193800.png]]
![[Pasted image 20220929214300.png]]
 - 启动命令

![[Pasted image 20220929214338.png]]
- 进入容器之后默认的目录

![[Pasted image 20220929214414.png]]
- 基于父镜像 

# 操作指令

![[Pasted image 20220929214531.png]]

![[Pasted image 20220929214546.png]]
- 只会出现一次，如果有多条，只会执行最后一条

![[Pasted image 20220929214623.png]]

![[Pasted image 20220929214648.png]]
- 推荐使用 ADD
- nginx 会默认有 ENTRYPOINT 所以会执行不起来
- here document

![[Pasted image 20220929215524.png]]
- docker file

![[Pasted image 20220929215849.png]]

# 常用基本操作
- 构建 workflow 脚本
- 可以写 [shell](https://www.bilibili.com/video/BV1hW41167NW/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3) 脚本
- shell 脚本对你来说还很重要的

## ubuntu
### 国内镜像操作
```Dockerfile
FROM ubuntu:20.04

WORKDIR /root/workplace

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
	apt-get -y update

ADD . /root/workplace/
```


### 安装依赖(Unicorn)
```Dockerfile
FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

ARG thread=8
ARG workdir=/prepare

WORKDIR ${workdir}

# ANCHOR Dependence and source
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list  &&\
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list  &&\
	# NOTE Using old G++
	echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial main  \
		deb http://dk.archive.ubuntu.com/ubuntu/ xenial universe">> /etc/apt/sources.list  &&\
	apt-get update -y  &&\
	apt-get install -y \
		python \
		g++-4.9 \
		libz-dev \
		python-pip \
		python-dev \
		build-essential  &&\
	pip install numpy==1.14.3 scipy==0.17.0 scikit-learn==0.19.1 virtualenv  &&\

	# To run Visicorn:
	apt-get -y install libsqlite3-dev  &&\
	pip install pysqlite  &&\

	apt-get install -y \
		vim \
		wget \
		git  &&\
	# NOTE Download the source of unicorn
	wget https://github.com/crimson-unicorn/core/archive/refs/tags/v1.0.tar.gz -O core.tar.gz  &&\
	tar -xzf ./core.tar.gz

# ANCHOR Compile
RUN sed -i 's/sdebug/swdebug/g' ${workdir}/core-1.0/Makefile &&\
	cd core-1.0  &&\
		# make toy # FIXME
	cd ${workdir}
```

### Snort(我不知道需不需要构建镜像)
- [x] 设置时区的问题

# FAQ
## 交互式命令怎么处理
- 进入镜像，然后 commit 镜像
- [通过 expect 实现交互](https://blog.horus-k.com/2020/08/25/docker/%C2%96Dockerfile-%E4%B8%AD%E6%B7%BB%E5%8A%A0%E4%BA%A4%E4%BA%92%E5%BC%8F%E5%91%BD%E4%BB%A4/)
- [Linux expect 介绍和用法一 - 梦徒 - 博客园 (cnblogs.com)](https://www.cnblogs.com/saneri/p/10819348.html)————自动化交互式脚本

通用是重要的，这种技术的开发其实并不是很难。

- 但是问题是我不知道怎么验证，我真的栓Q。
