# DVWA 安装
- [Ubuntu安装DVWA - starnight_cyber - 博客园 (cnblogs.com)](https://www.cnblogs.com/Hi-blog/p/How-To-Install-DVWA-On-Ubuntu.html)
- [DVWA/README.zh.md at master · digininja/DVWA (github.com)](https://github.com/digininja/DVWA/blob/master/README.zh.md)
- [(95条消息) DVWA reCAPTCHA key: Missing解决方法_RBPi的博客-CSDN博客_dvwa key](https://blog.csdn.net/RBPicsdn/article/details/80059132)


# SQL 注入
## SQL 手工注入

![[Pasted image 20221123193448.png]]

单引号闭合

1' and 1=1'

![[Pasted image 20221123213230.png]]

- 引号闭合类型问题

![[Pasted image 20221123213443.png]]

- 原来是这样，我有点明白了。

![[Pasted image 20221123213619.png]]

- 到第三个字段出错了，说明数据表只有两个字段。

![[Pasted image 20221123213832.png]]

![[Pasted image 20221123213901.png]]

![[Pasted image 20221123220951.png]]



![[Pasted image 20221123221121.png]]

![[Pasted image 20221123221138.png]]
![[Pasted image 20221123221149.png]]
![[Pasted image 20221123221252.png]]

- 然后 md5 破解

![[Pasted image 20221123221322.png]]


![[Pasted image 20221123221404.png]]

- 如果是复选框，只能选额几 id，那么只能通过抓包的方式，修改包里面的数据。

![[Pasted image 20221123223853.png]]

- 通过 burp suite 去截获请求，闭合方式不再是单引号。那么高级的方式是什么样的呢？
- 不要过于急于求成了

你要找时间把代码合起来。

# Reference
- [02SQL注入手工_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1JR4y1x7Rg/?p=2&vd_source=25509bb582bc4a25d86d871d5cdffca3)
