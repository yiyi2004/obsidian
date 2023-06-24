#docker

## Memos

```powershell
iptables -t nat -vnL POSTROUTING
ptables -t nat -vnL DOCKER
```

Docker 的四种网络模式

1. bridge
2. host
3. none
4. container 联盟模式

```powershell
docker network ls
docker network inspect bridge
docker network create -d bridge --subnet "192.168.100.0/24" --gateway "192.168.100.1" -o com.docker.network.bridge.name=docker1 mybr0
docker run -it --network mybr0 --rm busybox
docker run -it --network host --rm busybox
docker run -it --name c1 --rm busybox:latest
docker run -it --name c2 --network container:c1 --rm busybox:latest
netstat -npl
docker exec c1 wget -O - -q 127.0.0.1
# 查看c1容器/tmp目录，发现没有在c2容器中创建的文件，说明c1与c2仅共享了网络命名空间，没有共享文件系统
docker exec c1 ls /tmp
```

![[Snipaste/Pasted image 20230624184220.png]]  
![[Snipaste/Pasted image 20230624184226.png]]  
![[Snipaste/Pasted image 20230624184231.png]]

## Note

- ifconfig
- brctl show
- docker0 虚拟的网桥，相当于一个虚拟的交换机

![[Snipaste/Pasted image 20220929231425.png]]

- linux 有 veth-pair 技术

![[Snipaste/Pasted image 20220929231445.png]]  
![[Snipaste/Pasted image 20220929231457.png]]  
![[Snipaste/Pasted image 20220929231709.png]]  
![[Snipaste/Pasted image 20220929232906.png]]

- tcpdump -i

![[Snipaste/Pasted image 20220929233126.png]]

- arp -n

![[Snipaste/Pasted image 20220929233328.png]]

- iptables 和 docker 网络配置
- docker0 是容器之间，容器和宿主机进行通信的一块网卡，ens33 是主机的网卡。

docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1

- https://note.youdao.com/s/Js2Tccu3
- https://note.youdao.com/s/36hAglwJ
- https://note.youdao.com/s/3DTJ6Ora
- 容器 IP 会发生改变，通过服务名称找到进程。
- bridge 模式下的容器 IP 是会改变的
- 四大网络模式
	- bridge
	- host
	- none
	- container

### 自定义网络配置

- [(129条消息) Docker之网络配置_小依不秃头的博客-CSDN博客_docker配置路由](https://blog.csdn.net/qq_54936371/article/details/123054213?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166492259916782427464762%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166492259916782427464762&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-4-123054213-null-null.142^v51^control,201^v3^add_ask&utm_term=docker%20%E9%85%8D%E7%BD%AE%E6%97%81%E8%B7%AF%E7%94%B1&spm=1018.2226.3001.4187)
- 可以固定容器 IP
- [(129条消息) linux基本网络配置命令_没刮胡子的博客-CSDN博客](https://blog.csdn.net/somken/article/details/105936211?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166492331216782425171915%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166492331216782425171915&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-105936211-null-null.142^v51^control,201^v3^add_ask&utm_term=linux%20%E7%BD%91%E7%BB%9C%E9%85%8D%E7%BD%AE%E5%91%BD%E4%BB%A4&spm=1018.2226.3001.4187)

![[Snipaste/Pasted image 20221005064735.png]]

## Reference

- [二十分钟彻底搞懂Docker网络！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1PS4y1d7WB/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [终于有人讲明白了iptables和docker网络！_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1nL411j7Ln/?spm_id_from=333.788.recommend_more_video.-1)
