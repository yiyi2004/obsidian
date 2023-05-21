![[Snipaste/Pasted image 20221005193134.png]]


![[Snipaste/Pasted image 20221005193214.png]]
- filter 表下
- FORWARD：流经流量进行处理。

![[Snipaste/Pasted image 20221005193806.png]]

# iptable 配置管理
```shell
yum install iptables-services -y
```
- systemctl start iptables
- iptables -nL 查看
- 
![[Snipaste/Pasted image 20221005195052.png]]

![[Snipaste/Pasted image 20221005195321.png]]
- 每个表都拥有自己不同的链

基于 filter 表的规则配置
![[Snipaste/Pasted image 20221005195733.png]]
![[Snipaste/Pasted image 20221005200057.png]]
![[Snipaste/Pasted image 20221005195839.png]]
- 临时生效，可以重启一下防火墙。

![[Snipaste/Pasted image 20221005200403.png]]
- 指定源地址进行规则匹配，防火墙和 IDS 结合进行防御
- -D 删除规则

![[Snipaste/Pasted image 20221005200823.png]]
![[Snipaste/Pasted image 20221005200813.png]]
![[Snipaste/Pasted image 20221005201005.png]]

![[Snipaste/Pasted image 20221005201102.png]]
- -i

![[Snipaste/Pasted image 20221005201427.png]]

- ifdown eth1
- ifup eth1

![[Snipaste/Pasted image 20221005201723.png]]
- 这里是什么意思呢？

![[Snipaste/Pasted image 20221005202100.png]]
![[Snipaste/Pasted image 20221005202659.png]]

## 总结
![[Snipaste/Pasted image 20221005214815.png]]
![[Snipaste/Pasted image 20221005214950.png]]
![[Snipaste/Pasted image 20221005215024.png]]
![[Snipaste/Pasted image 20221005215245.png]]
- systemctl status iptables.service

![[Snipaste/Pasted image 20221005215827.png]]
![[Snipaste/Pasted image 20221005215845.png]]

![[Snipaste/Pasted image 20221005220044.png]]


![[Snipaste/Pasted image 20221005220246.png]]
- iptables -h | grep ...
- man iptables;  \/m

![[Snipaste/Pasted image 20221005220622.png]]
![[Snipaste/Pasted image 20221005220635.png]]
- 开放多个端口

![[Snipaste/Pasted image 20221005220841.png]]
![[Snipaste/Pasted image 20221005223231.png]]
![[Snipaste/Pasted image 20221005223249.png]]

## iptables nat

![[Snipaste/Pasted image 20221006090059.png]]
## Reference
- [Linux运维-使用iptables配置NAT服务_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1B24y1d7mZ/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [3.iptable内网转发功能_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1u8411b7g2?p=3&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [通俗易懂的iptables讲解_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1iQ4y1a7AL/?spm_id_from=333.788.recommend_more_video.0&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [Linux下网络安全之防火墙技术汇总#iptables#selinux#firewalld#tcp_wrappers_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1ru411r7Ff/?spm_id_from=333.788.recommend_more_video.1&vd_source=25509bb582bc4a25d86d871d5cdffca3)
