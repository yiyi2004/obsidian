![[Pasted image 20221130143345.png]]

- 漏洞：安全性的缺陷
- bug：功能上的缺陷
	- 闪退
	- 注册不上 

1. 数据泄漏——机密性
2. 业务停止——可用性
3. 高考录取系统——完整性

- 渗透测试一定要授权

- 360 漏洞云——公众号是不错的资源。你在假期的时候要好好整合你的技术知识和内容。

攻击载荷，反弹连接的代码或者提权的代码。

- Vulnerability
- Penatration Test
- Exploit
- Privilege Escalation
- Payload
- Anti-AntiVirus
- Post-Exploitation
- virustotl.com
- s.threatbook.com 微步云沙箱
 
- 渗透测试的流程
![[Pasted image 20221130144857.png]]

![[Pasted image 20221130145245.png]]

- **基于某个漏洞数据库** 需要掌握大量数据库
- github POC EXP 的工具
- 可以无限的扩展，可以把你自己的 POC  放到里面去。
- 国内**漏洞扫描**的服务。
- msfconsole 最常用
- 源在国外，需要替换 apt 源

- 利用模块，如果找到永恒之蓝的漏洞和代码，就可以利用成功了。
- 一般是先利用，然后攻击载荷。主动攻击和被动攻击(运行在主机，社会工程学的手段)

- 攻击方式
	- Active Exploit 主动攻击 直接攻击，适用于服务端
	- Passive Exploit 被动攻击 放置攻击代码运行，适用于客户端

- /usr/share/metasploit-framework/modules/exploit

![[Pasted image 20221130152455.png]]

- meterpreter

![[Pasted image 20221130152543.png]]

- 情报收集阶段使用辅助模块

![[Pasted image 20221130152825.png]]

- 这种具有开放性的工具的扩展性是甚强的。ruby

![[Pasted image 20221130153455.png]]

 ![[Pasted image 20221130153615.png]]
- 内容少，针对 windows 平台，免杀效果差。

![[Pasted image 20221130153655.png]]
- 填充空格，空模块，实际应用少。


![[Pasted image 20221130153722.png]]
- payloads 是用来生成木马的。

# 基本命令

- 交互界面

![[Pasted image 20221130155103.png]]

- 核心命令
- 内置数据库，如果有匹配的利用工具，会直接给你。**search** 命令非常关键

## search

![[Pasted image 20221130160732.png]]
![[Pasted image 20221130160905.png]]

- cve-details

![[Pasted image 20221130160800.png]]

- search 搜索的是自带的模块
- **searchsploit** 搜索的是漏洞数据库网站的内容
- exploit-db.com： https://www.exploit-db.com/
- 这里面都是针对于某一个漏洞的利用脚本

![[Pasted image 20221130161552.png]]

- python 脚本，利用它可以直接攻击成功。**补丁系统如何设计？**
- show options 

![[Pasted image 20221130164751.png]]

- use + module (search)
- show options
- set required
- unset rhosts
- show options
- run/exploit
- back
- quit/exit

# 信息搜集实战
- 系统的攻击，后面两天

- dig baidu.com
- whois baidu.com
- 同一个网段里面有什么主机

kali 主机发现 nmap

![[Pasted image 20221130170120.png]]

- C 段

![[Pasted image 20221130170544.png]]

- 搜集 IP 信息
- 搜集端口信息

![[Pasted image 20221130170627.png]]

![[Pasted image 20221130170715.png]]

- **vunhub.org 的靶场，漏洞复现的靶场**

![[Pasted image 20221130170832.png]]

- kali 里面目录扫描
	- drrb
	- drrsearch
	- wFuzz
	- 御剑
- 192.168.184.1 代表物理机的 IP，这我还是第一次知道


![[Pasted image 20221130171045.png]]

![[Pasted image 20221130171054.png]]
- 默认的字典
- 200 成功

- 爆破 ssh 的操作
![[Pasted image 20221130171248.png]]

- kali 爆破 ssh 协议的软件

![[Pasted image 20221130171332.png]]

- 常用辅助模块，信息搜集。

![[Pasted image 20221130171419.png]]


# 安全方向
![[Pasted image 20221130172746.png]]

- 别干网工

![[Pasted image 20221130173139.png]]
# msf 实战
- msf 渗透 wordpress 博客
- msf 爆破 Tomcat 并获得 shell
- msf 利用 Ubuntu 内核漏洞提提权
- msf 渗透流程总结

## WPScan 爆破WordPress 密码
WorldPress 全球最流行的 web  应用。
![[Pasted image 20221130183108.png]]

1. 程序本身有问题
2. 插件
3. 主题 theme

```shell
wpscan --url https://www.coolshell.cn --enumerate -u
```
![[Pasted image 20221130204324.png]]

![[Pasted image 20221130204509.png]]

- 文件上传：木马
- 反弹shell
	- 内网 IP 没有外网 IP
	- 防火墙
	- 动态 IP

- 密码字典，社工库去爆破 。
- zoomeye.org 
- 将你的个人博客写道你的简历里面，自己搭建一个博客网站。
- 漏洞扫描的攻击
	- wpscan

1. 建立监听
2. 生成反弹链接木马

![[Pasted image 20221130204903.png]]

- msfvenom

![[Pasted image 20221130205029.png]]

![[Pasted image 20221130205454.png]]

- 记得备份原来的数据，然后将生成的载荷放到一个 php 文件中。如 404，只要调用就会上钩。

![[Pasted image 20221130205631.png]]

![[Pasted image 20221130210012.png]]

![[Pasted image 20221130210054.png]]

- meterpreter 执行的不是操作系统的命令，而是 meterpreter 的命令

![[Pasted image 20221130210214.png]]

![[Pasted image 20221130210248.png]]

- sysinfo

![[Pasted image 20221130210402.png]]

![[Pasted image 20221130210529.png]]

- background
- 会话的概念，让很多人链接我的电脑。


![[Pasted image 20221130210838.png]]

![[Pasted image 20221130210933.png]]

- shell 进入目标主机的shell
-  只要获得 meterpreter 的会话，你就有权限上传和下载文件。
- excute 可以执行目标主机上的程序，比如勒索病毒。
- getsystem 可以自动提权
- clearev 清除痕迹

## msf 渗透总结
![[Pasted image 20221130211814.png]]
# msf 进阶
- msf 利用永恒之蓝 ms17-010
- msf 渗透并控制安卓手机
- msf 渗透并控制 Windows 电脑
- msf 渗透靶场综合实战案例

# kali 工具总结
- [kali总结——基本工具_haoaaao的博客-CSDN博客_kali工具](https://blog.csdn.net/haoaaao/article/details/123904545?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166979890616800182770778%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166979890616800182770778&biz_id=0&spm=1018.2226.3001.4187)
- [【Kali】kali主要工具使用说明(文末附超全思维导图)_PP_L的博客-CSDN博客_kali工具大全使用方法](https://blog.csdn.net/Zhou_ZiZi/article/details/124717943?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166979890616800182770778%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166979890616800182770778&biz_id=0&spm=1018.2226.3001.4187) #重要资源
