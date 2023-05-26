- 没有什么是加一层解决不了的
- 加一层统一管理
- Redis 做 session 共享
- iphash
- 动静分离

1. 反向代理
2. 负载均衡
3. 动静分离

## 安装

安装失败的原因：

1. linux 的防火墙
2. 80 端口有没有开
3. ngnix.conf 配置文件

感觉安装都大同小异，但是需要更新工具。

![[Snipaste/Pasted image 20220929223152.png]]

- 常用命令哦，我的建议是重启 docker

![[Snipaste/Pasted image 20220929223310.png]]

## 实战

端口 8080， 8081

![[Snipaste/Pasted image 20220929223707.png]]

- 全局配置
- events
- http

![[Snipaste/Pasted image 20220929223843.png]]

- 性能优化，全局配置

![[Snipaste/Pasted image 20220929224014.png]]

- location 的作用

![[Snipaste/Pasted image 20220929224157.png]]

![[Snipaste/Pasted image 20220929224623.png]]

- 基本使用

![[Snipaste/Pasted image 20220929224656.png]]

## Reference

- [专栏-KuangStudy](https://www.kuangstudy.com/zhuanlan) 课程网页
- [尚硅谷2022版Nginx教程（亿级流量nginx架构设计）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1yS4y1N76R/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
