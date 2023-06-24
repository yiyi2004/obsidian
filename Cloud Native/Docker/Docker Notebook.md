- Time：2023-06-24 17:45
- Label： #docker #notebook

## Abstract

记录 Docker 的学习笔记，但为什么我感觉这个已经做过了呢？

容器技术基于两大技术 **Namespace** 和 **CGgroup**

## Content

### Basic

#### Docker 镜像分层结构

用过 Dockerfile 构建镜像的都知道 Dockerfile 执行完每一条指令都会创建一个新的镜像，最终的镜像由层层叠加而成。  
分层**最大的好处就是共享资源。**

当多个镜像从相同的 base 镜像构建而来，那么 Docker host 只需要在磁盘保存一份 base 镜像，同时内存中也只需要加载一份 base 镜像，就可以为所有的容器服务了。  

**容器的修改并不会影响镜像**

当容器启动时，一个新的可写层被加载到镜像的顶层，这一层通常被成为“容器层”。  
对容器的改动，无论添加、删除、还是修改文件都只会发生在容器层中。  

**容器层是可写的，镜像层是只读的。**

### Command

```shell
docker ps -aq
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)

docker cp mycontainer:/opt/file.txt /opt/local/
docker cp /opt/local/file.txt mycontainer:/opt/
```

```shell
# clean the build cache
docker builder prune
```

### 数据持久化

Docker 提供三种方式将数据从宿主机挂载到容器中：

- **docker run -v**  

运行容器时，直接挂载本地目录至容器中

- **volumes**  

Docker 管理宿主机文件系统的一部分 (/var/lib/docker/volumes)  
是 Docker 默认存储数据方式

```powershell
docker volume create nginx-vol
ls /var/lib/docker/volumes/
docker volume ls
docker volume inspect nginx-vol
docker run -d --name web4 --mount src=nginx-vol,dst=/usr/share/nginx/html nginx:latest
docker run -d --name web4 -v nginx-vol:/usr/share/nginx/html/ nginx:latest
ls /var/lib/docker/volumes/nginx-vol/_data/
```

- **bind mounts**  
将宿主机上的任意位置文件或目录挂载到容器中

```powershell
docker run -d --name web5 --mount type=bind,src=/opt/web5root,dst=/usr/share/nginx/html nginx:latest
```

## Reference
