- Time：2023-06-24 17:45
- Label： #docker #notebook

## Abstract

记录 Docker 的学习笔记，但为什么我感觉这个已经做过了呢？

容器技术基于两大技术 **Namespace** 和 **CGgroup**

## Content

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

## Reference
