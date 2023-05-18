- 基于规则的入侵检测系统

# 规则头
- 规则头包含四个部分
	- 规则行为
	- 协议
	- 源信息
	- 目的信息

- snort 规则头 snort 预置规则动作有 5 种
	- pass
	- log
	- alert
	- dynamic 潜伏状态
	- activate ---> dynamic 复杂攻击，对数据进行归类

# 规则体
- 规则体的作用是在规则头信息的基础上进一步分析，有了它才能确认复杂的攻击(Snort的规则定义中可以没有规则体)。规则体由若干个被分别隔开的片断组成，每个片断定义了一个选项和相应的选项值。一部分选项是对各种协议的详细说明，包括IP、ICMP和TCP协议，其余的选项是：规则触发时提供给管理员的参考信息，被搜索的关键字，Snort规则的标识和大小写不敏感选项。
- 规则体的书写还要具体进行学习呢。


# 预处理
- 预处理器在调用检测引擎之前，在数据包被解码之后运行。通过这种机制，Snort可以以一种out of band的方式对数据包进行修改或者分析。

预处理器可以使用preprocessor关键词来加载和配置，常用到的预处理器如下：
1. HTTPdecode预处器HTTP解码预处理模块用来处理HTTPURL字符串，把它们转换为清晰的ASCII字符串。
2. 端口扫描器portscan端口扫描器会把由单个源IP地址发起的端口扫描从开始到结束的全过程记录到标准日志。
3. stream处理器stream处理器为snort提供了TCP数据包重组的功能。在配置的端口上，stream处理器能够对TCP数据包的细小片段进行重组，使之成为完整的TCP数据包，然后snort可以对其可疑行为进行检查。
4. frag2处理器frag2预处理器为snort提供了IP分片重组的功能。frag2预处理器能够对分片包进行重组来定位分片攻击，它的工作原理是将所有的分片重组构造成一个包含完整信息的数据包，再将这个包传给检测引擎。

- 这是一些可以用到的插件吗？

- config 文件中有 规则路径，还有 include (这是官方提供的一些规则嘛)，比如引入一些与 MySQL 有关的规则库。


![[Pasted image 20220929164801.png]]
snort -T -c /root/snort/snort-2.9.20/etc/snort.conf -i ens33 

![[Pasted image 20220929164820.png]]
- snort 的操作手册，你需要了解一下。

![[Pasted image 20220929164934.png]]


![[Pasted image 20220929165016.png]]
sparta-kali

![[Pasted image 20220929165505.png]]
- 规则

![[Pasted image 20220929165604.png]]

![[Pasted image 20220929165622.png]]
![[Pasted image 20220929165756.png]]
- 安装 daq
- cd daq
- ./configure
- make and make install

![[Pasted image 20220929165915.png]]
- 然后白色部分最上面部分

![[Pasted image 20220929170022.png]]
- 记得在之前安装 openssl 和 openssl-dev

- make && make install 
- download rules
- snort3 的安装
- snort 注册下载 rules

![[Pasted image 20220929170949.png]]
- 你的价值和能力不就体现在这里嘛？你晚上不吃饭了。

![[Pasted image 20220929171223.png]]
![[Pasted image 20220929171244.png]]
- 不是按照版本来的哦

**snort.conf** 文件很重要哦

![[Pasted image 20220929171405.png]]
- snort 文档

threakt 和 snort 规则的兼容性是很好的。

![[Pasted image 20220929171708.png]]
![[Pasted image 20220929171838.png]]
![[Pasted image 20220929172045.png]]
![[Pasted image 20220929172110.png]]
- vim /etc/snort/snort.conf
- 写好 RULE_PATH

![[Pasted image 20220929172240.png]]
- cat sql.rules
- cat local.rules 空的
- cat ftp.rules
- 是不是需要花钱才能弄到规则呢？

- vim /etc/snort/snort.conf
- SO_RULE_PATH

桥豆麻袋！这些规则要到哪里去获得呢？

![[Pasted image 20220929172615.png]]
- cd /etc/snort/rules
- 创建白名单和黑名单

![[Pasted image 20220929172701.png]]
- touch white_list.rules
- touch black_list.rules

![[Pasted image 20220929172855.png]]
- 这条命令有问题的

- 几种模式

![[Pasted image 20220929172948.png]]
- snort 文档要仔细看一眼

![[Pasted image 20220929173426.png]]

![[Pasted image 20220929173553.png]]
- 删掉之后两项功能不能用呗

![[Pasted image 20220929173718.png]]

![[Pasted image 20220929173725.png]]
- vim local.rules
- Linux 命令
- Linux 网络管理

![[Pasted image 20220929173851.png]]
![[Pasted image 20220929173919.png]]
- 正常流量 snort 简单的部署，真的有很多值得研究的东西嘛？
- /etc/snort/rules
![[Pasted image 20220929174019.png]]
- set nu 和行数相关的 vim 命令

# Docker 安装
## Snort3 Container

This is an interactive container for learning Snort3 with the Cisco Talos Snort3 training videos.

### Features

-   Snort3 Tutorial
-   Rule Writing Labs
-   Detection Strategies

### Step by Step Guide

#### Download the Container

```
$ docker pull ciscotalos/snort3
```

#### Start the Container

```
$ docker run --name snort3 -h snort3 -u snorty -w /home/snorty -d -it ciscotalos/snort3 bash
```

#### Enter the Snort Container

```
$ docker exec -it snort3 bash
```

#### Stop the Snort Container

```
$ docker kill snort3
```

# Document(video)
![[Pasted image 20220930103206.png]]
- 有将 snort2 升级到snort3 的工具，lua?


![[Pasted image 20220930103523.png]]
![[Pasted image 20220930103632.png]]
![[Pasted image 20220930103820.png]]
- docker commands and 
- lua 是一门脚本语言
- hyper scan

![[Pasted image 20220930104420.png]]
- 你仅仅是在念 PPT 吧

![[Pasted image 20220930110257.png]]
- 整理下思路，继续前进
- snort --version
- snort -c /home/snorty/snort3/etc/snort/snort.lua
- snort --help
- snort --help-modules
- snort --help-config

## lab1

![[Pasted image 20220930111520.png]]
![[Pasted image 20220930111640.png]]
## lab2
![[Pasted image 20220930114511.png]]
- 这些参数是什么意思捏？
![[Pasted image 20220930124709.png]]
- 设置 rule_path
![[Pasted image 20220930124830.png]]
- 将 snort2 的语法转换为 snort3 的语法

![[Pasted image 20220930124949.png]]
- 你是不是可以做一个中文的视频呢？把这些事情讲清楚

![[Pasted image 20220930145708.png]]
- elk 是什么

![[Pasted image 20220930150344.png]]
![[Pasted image 20220930150445.png]]
![[Pasted image 20220930150638.png]]
![[Pasted image 20220930150959.png]]
- 他们难道是为了去规避法律风险吗？

![[Pasted image 20220930151044.png]]

# 安装指令序列
Unable to open address file /root/snort/etc/../rules/white_list.rules, Error: No such file or directory

snort -A console -q -c /root/snort/snort-2.9.20/etc/snort.conf -i ens33

- 你要找时间把你的学习链接都整理一下

# Reference
- [Snort总结-简介](https://blog.csdn.net/ftxc_blog/article/details/12565761?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166368257716782390580762%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166368257716782390580762&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-12565761-null-null.142^v48^pc_rank_34_default_3,201^v3^control_1&utm_term=snort&spm=1018.2226.3001.4187)
- [(122条消息) Snort入侵检测系统简介_波波仔86的博客-CSDN博客_snort](https://blog.csdn.net/bobozai86/article/details/81214747?ops_request_misc=&request_id=&biz_id=102&utm_term=snort&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-81214747.nonecase&spm=1018.2226.3001.4187)
- [基于CentOS7系统环境下的Snort3安装指南 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/197339236)
- [(126条消息) snort3安装教程_bob62856的博客-CSDN博客_snort3安装](https://blog.csdn.net/qq_20817327/article/details/111058942?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166446367916800182146757%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166446367916800182146757&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-1-111058942-null-null.142^v51^control,201^v3^add_ask&utm_term=snort3%20%E5%AE%89%E8%A3%85&spm=1018.2226.3001.4187)
- [(613) Snort 101 - YouTube](https://www.youtube.com/watch?v=W1pb9DFCXLw&list=PLpPXZRVU-dX33VNUeqWrMmBNf5FeKVmi-&index=2)——我裂开了，似乎只能看这个了。
- [(126条消息) 认识Snort3 （1）：编译、安装与简单使用_ObjectNF的博客-CSDN博客_snort3](https://blog.csdn.net/weixin_44911246/article/details/122355797?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166450877416782412519662%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166450877416782412519662&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-122355797-null-null.142^v51^control,201^v3^add_ask&utm_term=snort3&spm=1018.2226.3001.4187)
- Snort Manual - [https://snort.org/downloads/snortplus...](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbmlwNjNmMTNQbDhJSm9GNjZ5T2JzYU0xYlhFZ3xBQ3Jtc0trX0EyZXhxNG1hV21zOE5MQ0lRTTF1V0NLSFJzcmNTQ3dlYUhvU0k4U1BVZ04yWDF3N3p2WXRSQzNmSmRMbFc1NVZhRFo3RjEzSGhZY3VLUC13N1FsSUFNTGxZRGQxRzdkMlUyU3c0OFR6Y3JmRHBndw&q=https%3A%2F%2Fsnort.org%2Fdownloads%2Fsnortplus%2Fsnort_manual.pdf&v=PYP0YH2PVuo) 
- Snort Documentation -[https://snort.org/documents](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbDdsWTRoVGV3OVB1TE1UVlVXbzU3bEhWMnd6d3xBQ3Jtc0tsd0VXNkg3eFFDeTNFWWE0aWpqenZ6SHRiS1pIalRRS2tCNHQtdnhDRDVkM0pMb3hLZlo5NTBUN1pQNVdzb1FtUzN6bzJqQmd2Tng2MTB3VjVBMGo5MF8xR2E0SGFsMmFVZGZwbDZmMHFlUjRoY1JDVQ&q=https%3A%2F%2Fsnort.org%2Fdocuments&v=PYP0YH2PVuo) 
- Snort 3 Docker Container - [https://hub.docker.com/r/ciscotalos/s...](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbmtDdzhwY2VySUMtUkh5ZG13TjJLVzJYbDhsZ3xBQ3Jtc0trbW9pbV8xS0ViOHVib29fS3lHdnZqOE4tdDJWcTAyMmFVZ0xVTkpBYzBNOTZOLVMyaXF6Ni1PSWVaODk4WTVtMmNqNm9RYXFUaHduRUJucFpnR2twMkNSNTdaekN3bWdSQjFsNTBRN3ZybVNPVUd5TQ&q=https%3A%2F%2Fhub.docker.com%2Fr%2Fciscotalos%2Fsnort3&v=PYP0YH2PVuo) 
- LuaJIT - [http://luajit.org](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa2dJbjliZFNaT1pMNDA1N2ZYei16SGE3Zzc1Z3xBQ3Jtc0ttenF6cHJsMV9HTTBJcWJyblEtU1ZQQ0I2OE1adVFHWU9GemVTbmJldjQ0M2wxd0ZHRXg4SnNqdHFXN1dWVXp0cTBoUzBSY0lTeFhxSWI5VTNBZF94T0NYODdGQnl4emJSd3FDZ0w3RnlXVERfUTZrWQ&q=http%3A%2F%2Fluajit.org%2F&v=PYP0YH2PVuo) 
- Hyperscan - [https://hyperscan.io](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbVJCQmV6NnpHZW45RHo5cUhPREhiUDNaeElNUXxBQ3Jtc0trZWZsYjBsNXFSRkRncXA0dkJncWVsSzNjYkRTUUtSNmQtRjdVajJrMjNIYmZXUy1hUVVHZjdaYlZGU1NZUXBUVFhlSHF1OVMtekhCRFROTkhVWE9qeVNzVDlFeVlOMTR0aXFQOWp4cnkwdFpHQThYbw&q=https%3A%2F%2Fhyperscan.io%2F&v=PYP0YH2PVuo) 
- Snort Community & mailing list - [https://snort.org/community](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqa1pJd1U3ekhlaEFMQ1FWVVhieEU1aU5uR1N2d3xBQ3Jtc0ttQlpYY2pSWjZBNG1nMDdGdi12LVRJY0lzRmZzanFHMzNjLWtjODRfQlpfTHZneTFuaWxucmdGbnI1OGZSU3VNdXUzZFdjMklhS213RjdHTk8wZHhmSnM3RVFmWXhuWExfWkNteHJzb0Nja1J0VFEydw&q=https%3A%2F%2Fsnort.org%2Fcommunity&v=PYP0YH2PVuo)
- [(126条消息) Elasticsearch学习笔记_巨輪的博客-CSDN博客_elasticsearch学习笔记](https://blog.csdn.net/u011863024/article/details/115721328)
- [(131条消息) snort IPS 模式编译安装（脚本）_noodle_bear的博客-CSDN博客](https://blog.csdn.net/noodle_bear/article/details/109805600?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166519246316782395391332%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166519246316782395391332&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-2-109805600-null-null.142^v51^control,201^v3^add_ask&utm_term=snort%20%E5%8F%AF%E4%BB%A5%E5%81%9A%20ips%20%E5%90%97&spm=1018.2226.3001.4187)
- [Snort Database - an overview | ScienceDirect Topics](https://www.sciencedirect.com/topics/computer-science/snort-database)
