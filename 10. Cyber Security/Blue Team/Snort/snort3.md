# Install

![[Pasted image 20221010081831.png]]
![[Pasted image 20221010081847.png]]

- [How to Install Snort on Ubuntu 20.04 (linuxopsys.com)](https://linuxopsys.com/topics/install-snort-on-ubuntu)

# Document
- Additional Resources
- centos8

```shell
find / -name RPM-GPG-KEY-CentOS* 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-Extras
```

![[Pasted image 20221010200138.png]]
- 阿里云镜像问题
- 依赖包镜像问题
- libDAQ 问题
- 写个脚本的问题

![[Pasted image 20221010200956.png]]
```shell

# curl -Lo flatbuffers-1.12.tar.gz https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz
# tar xf flatbuffers-1.12.tar.gz
# mkdir fb-build && cd fb-build
# cmake ../flatbuffers-1.12.0
# make -j$(nproc)
# make -j$(nproc) install
# ldconfig
# cd ../
```

- linux 挂载目录
- vmware-hgfsclient
```shell
vim /etc/fstab
添加一条挂载信息
.host:/repo /mnt/hgfs fuse.vmhgfs-fuse allow_other,default 0 0
然后保存退出 使用mount -a 命令 挂载
mount -a

```
- 你是个憨憨，都不记得自己设置的共享文件夹是吧。

- /bin/sh^M: bad interpreter: No such file or directory
- 这是 git 下载的时候换行符的问题 autocrlf = false 就能解决

其原因是不同系统编码格式引起的，应该是这个cofigure在window上被编辑过
解决方法是利用vi编辑器，挺方便，按照如下步骤：
1. 输入 vi configure，会显示部分内容出来
2. 输入 :set ff，会看到 fileformat=dos，这样就验证了刚才的想法：文件被在window上编辑过
3. 输入 :set ff=unix，就会把文件转化为unix格式的，当然Mac上就可以正常使用了
4. 输入 :wq，退出vi
具体为什么会报^M这个错误，应该是cofigure文件在window上编辑时，每行后面会加个ctrl+m就是^M，相应的利用shell执行时，就会变成sh^M，这个命令当然是没有的，就报了上述错误。

```shell
/bin/sh: ../../../src/main/../lua_wrap.sh: /bin/sh^M: bad interpreter: No such file or directory
make[2]: *** [src/main/CMakeFiles/main.dir/build.make:78: src/main/lua_finalize.h] Error 126
make[2]: *** Deleting file 'src/main/lua_finalize.h'
make[1]: *** [CMakeFiles/Makefile2:3205: src/main/CMakeFiles/main.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
[ 12%] Built target log
make: *** [Makefile:156: all] Error 2
```
# Configure
![[Pasted image 20221011101524.png]]
	
Snort rules, appid, and reputation lists will be stored in their respective directory. The rules/ directory will contain Snort rules files, the appid/ directory will contain the AppID detectors, and the intel/ directory will contain IP blacklists and whitelists.

curl -Lo snortrules-snapshot-3000.tar.gz https://www.snort.org/rules/snortrules-snapshot-3000.tar.gz?oinkcode=b5e22de32f6599ebfb354cdf80eec72aa5e81281

- oinkcode 是 snort 注册用户唯一指定的，在 my account 中查看。

- snort path: /usr/local/snort
- wget https://snort.org/downloads/openappid/26425
- 共享文件夹配置方法
- 6.6 Configuring file Inspectors (Optional)——没有做哦

![[Pasted image 20221011124455.png]]
![[Pasted image 20221011141523.png]]

- [ ] 8. Managing Snort 3 Rules with PulledPork——这步骤没有做哦

- PCAP 文件
![[Pasted image 20221011162907.png]]
- [(134条消息) Pcap文件详解_Keep-fight的博客-CSDN博客_pcap](https://blog.csdn.net/qq_33344148/article/details/114929274?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166547685016782417069907%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166547685016782417069907&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_click~default-1-114929274-null-null.142^v52^control,201^v3^add_ask&utm_term=PCAP&spm=1018.2226.3001.4187)
- 一种存储数据包的格式

![[Pasted image 20221011163338.png]]
```shell
/usr/local/snort/bin/snort -c \ /usr/local/snort/etc/snort/snort.lua -r test.pcap -l \
/var/log/snort --plugin-path /usr/local/snort/extra -k none

/usr/local/snort/bin/snort -c \
/usr/local/snort/etc/snort/snort.lua --pcap-dir pcaps/ \
--pcap-filter '*.pcap' -l /var/log/snort \
--plugin-path /usr/local/snort/extra -k none
```

![[Pasted image 20221011163621.png]]

```shell
/usr/local/snort/bin/snort -c \ /usr/local/snort/etc/snort/snort.lua -i eth0 \ 
-l /var/log/snort --plugin-path /usr/local/snort/extra -k none
```

![[Pasted image 20221011163716.png]]

![[Pasted image 20221011163819.png]]
```shell
# git clone https://github.com/sstephenson/bats.git
# cd bats/
# ./install.sh /usr/local

# git clone https://github.com/snort3/snort3_demo.git
# cd snort3_demo/
# ./run_test.sh /usr/local/snort
```

# Install PulledPork
```shell
dnf install perl-LWP-UserAgent-Determined perl-Net-SSLeay perl-LWP-Protocol-https perl-Sys Syslog perl-Archive-Tar
```

# 代办
- [ ] Hyperscan 的安装，但不是通过源码编译的
- [ ] Snort+Barnyard2+Mysql+BASE
- [ ] [Snorby](https://github.com/Snorby/snorby)
- [ ] Snort GUI [Snow](https://snowl.io/)
- [ ] Snort + Iptables
- [ ] Snort/Barnyard2 脚本。启动与停止
- [ ] Guardian
- [ ] [Snort IPS With NFQ (nfqueue) Routing on Ubuntu – Sublime Robots](http://sublimerobots.com/2017/06/snort-ips-with-nfq-routing-on-ubuntu/)
- [ ] 如果需要讲 snort 的数据写入主机 ---> 写入 MySQL
	- [ ] 需要一个日志处理程序
	- [ ] push 方法
	- [ ] 消息队列问题
- [ ] PulledPork
- [ ] 通过 NFQ 构建 IPS

课程内容
- 之后是伍老师讲课了
- 社会工程学
- 内生安全

2022.10.12 要做什么事情呢？
- [x] 文档完成
	- [x] 虚拟网络的设计
		- [x] Docker旁理由搜集信息
		- [x] 虚拟机，网关 Router 部署在网关上面做 IPS，或者 snort + iptables / 其他方案
	- [x] 各个组件的功能
		- [x] Nginx
		- [x] DWAW...
- [ ] 调研 IPS 的方法
	- [ ] snort3 + iptable
	- [ ] 静态 IP 配置
- [ ] snort3 配置任务完成
	- [ ] rules
	- [ ] extra tools

基于警报还是基于网络流量呢？
- snort 可以将数据包记录成 pcap 格式
- [ ] 可以用目录挂载解决这个问题
- [ ] 通过 barnyard2 实现写入数据库 ---> 直接写入其他主机的数据库中，但是需要权限控制一系列操作

# Error
```shell
[root@localhost ~]# /usr/local/snort/bin/snort -c /usr/local/snort/etc/snort/snort.lua --pcap-dir ./pcap/ --pcap-filter '*.pcap' -l /var/log/snort --plugin-path /usr/local/snort/extra -k none
--------------------------------------------------
o")~   Snort++ 3.1.43.0
--------------------------------------------------
Loading /usr/local/snort/etc/snort/snort.lua:
Loading snort_defaults.lua:
Finished snort_defaults.lua:
	ssh
	host_cache
	pop
	so_proxy
	stream_tcp
	mms
	smtp
	gtp_inspect
	packets
	dce_http_proxy
	file_log
	alert_fast
	ips
	stream_icmp
	normalizer
	hosts
	binder
	wizard
	appid_listener
	reputation
ERROR: /usr/local/snort/etc/snort/snort.lua: can't find reputation.blacklist
ERROR: /usr/local/snort/etc/snort/snort.lua: can't find reputation.whitelist
# 这里你配置了绝对路径哦
	appid
	file_id
	stream_udp
	http2_inspect
	http_inspect
	ftp_data
	search_engine
	ftp_server
	port_scan
	dce_http_server
	dce_tcp
	dce_smb
	iec104
	cip
	telnet
	ssl
	sip
	rpc_decode
	netflow
	modbus
	host_tracker
	stream_user
	stream_ip
	trace
	back_orifice
	classifications
	dnp3
	active
	process
	ftp_client
	daq
	decode
	alerts
	stream
	references
	arp_spoof
	output
	network
	dns
	dce_udp
	imap
	file_policy
	s7commplus
	stream_file
Finished /usr/local/snort/etc/snort/snort.lua:
Loading file_id.rules_file:
Loading file_magic.rules:
Finished file_magic.rules:
Finished file_id.rules_file:
Loading ips.rules:
ERROR: ips.rules:1 can't open ../../rulessnort.rules

Finished ips.rules:
--------------------------------------------------
ips policies rule stats
              id  loaded  shared enabled    file
               0     208       0     208    /usr/local/snort/etc/snort/snort.lua
--------------------------------------------------
rule counts
       total rules loaded: 208
               text rules: 208
            option chains: 208
            chain headers: 1
--------------------------------------------------
service rule counts          to-srv  to-cli
                  file_id:      208     208
                    total:      208     208
--------------------------------------------------
fast pattern groups
                to_server: 1
                to_client: 1
--------------------------------------------------
search engine
                instances: 2
                 patterns: 416
            pattern chars: 2508
               num states: 1778
         num match states: 370
             memory scale: KB
             total memory: 68.5879
           pattern memory: 18.6973
        match list memory: 27.3281
        transition memory: 22.3125
--------------------------------------------------
ERROR: Could not find requested DAQ module: pcap

FATAL: see prior 4 errors (0 warnings)
Fatal Error, Quitting..

```

- ERROR: /usr/local/snort/etc/snort/snort.lua: can't find reputation.blacklist
- ERROR: /usr/local/snort/etc/snort/snort.lua: can't find reputation.whitelist
- ERROR: ips.rules:1 can't open ../../rulessnort.rules
- ERROR: Could not find requested DAQ module: pcap
- Error getting pcaps under dir: ./pcaps/: No such file or directory

- [ubuntu - Snort 3.0 Error: Could not find requested DAQ moduel: pcap - Stack Overflow](https://stackoverflow.com/questions/66014641/snort-3-0-error-could-not-find-requested-daq-moduel-pcap)

- Couldn't start DAQ instance: truncated dump file; tried to read 4 file header bytes, only got 0 (-1)
- 目前存在的问题

- 启动命令
- /usr/local/snort/bin/snort -c /usr/local/snort/etc/snort/snort.lua --pcap-dir /root/pcaps/ --pcap-filter '*.pcap' -l /var/log/snort  --daq-dir /usr/local/lib/daq --plugin-path /usr/local/snort/extra -k nonec
- /usr/local/snort/bin/snort -c /usr/local/snort/etc/snort/snort.lua  -l /var/log/snort  --daq-dir /usr/local/lib/daq -i ens160 -A fast -d


# Snort IPS Inline Mode on Ubuntu
- Barnyard2, PulledPork, and a web GUI like BASE or Snorby are optional but helpful


- [Snort IPS Inline Mode on Ubuntu – Sublime Robots](http://sublimerobots.com/2016/02/snort-ips-inline-mode-on-ubuntu/)
- [Sublime Robots – Better than having a real job](http://sublimerobots.com/)

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
- [linux - How to enable PowerTools repository in CentOS 8? - Server Fault](https://serverfault.com/questions/997896/how-to-enable-powertools-repository-in-centos-8)
- [(133条消息) 在Mac中执行configure，异常 /bin/sh^M: bad interpreter: No such file or directory_芸轩的博客-CSDN博客](https://blog.csdn.net/flame_007/article/details/83019247?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166544411016782391828223%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166544411016782391828223&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-83019247-null-null.142^v52^control,201^v3^add_ask&utm_term=-bash%3A%20.%2Fconfigure_cmake.sh%3A%20%2Fbin%2Fsh%5EM%3A%20bad%20interpreter%3A%20No%20such%20file%20or%20directory&spm=1018.2226.3001.4187)

- Snort3 安装配置
- [Snort-IPS-入侵防御系统安装及部署小记 - Deng_Xian_Sheng - 博客园 (cnblogs.com)](https://www.cnblogs.com/Deng-Xian-Sheng/p/14120221.html)
- [基于CentOS 8 系统环境下的 Snort 3 安装指南_Linux_开发者网_运维开发技术经验分享 (devze.com)](https://www.devze.com/linux/320807.html)
- [Cisco 安全防火墙管理中心 Snort 3 配置指南，版本 7.2 - 从 Snort 2 迁移到 Snort 3 [Cisco Firepower Management Center] - Cisco](https://www.cisco.com/c/zh_cn/td/docs/security/secure-firewall/management-center/snort/720/snort3-configuration-guide-v72/migrating.html)
- [snort 开源网络入侵防御系统(ips) - 第2页 共2页 - 🔰雨苁ℒ🔰 (ddosi.org)](https://www.ddosi.org/snort/2/)
- [基于CentOS 8 系统环境下的 Snort 3 安装指南 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/266824288)
- [Snort-IPS-Tutorial.pdf](https://s3.amazonaws.com/snort-org-site/production/document_files/files/000/000/069/original/Snort-IPS-Tutorial.pdf)
- [Snort IPS With NFQ (nfqueue) Routing on Ubuntu – Sublime Robots](http://sublimerobots.com/2017/06/snort-ips-with-nfq-routing-on-ubuntu/)

- [barnyard2 mysql_安装配置Snort和barnyard2](https://blog.csdn.net/weixin_39553458/article/details/113375941?ops_request_misc=&request_id=&biz_id=102&utm_term=barnyard&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-113375941.142^v53^control,201^v3^add_ask&spm=1018.2226.3001.4187)

- [How to Install Snort on Ubuntu 20.04 (linuxopsys.com)](https://linuxopsys.com/topics/install-snort-on-ubuntu)



# 20221013
- [Search · iptables (github.com)](https://github.com/search?q=iptables)
- [ubuntu - Snort 3.0 Error: Could not find requested DAQ moduel: pcap - Stack Overflow](https://stackoverflow.com/questions/66014641/snort-3-0-error-could-not-find-requested-daq-moduel-pcap)
- [snort:ERROR: Can't find pcap DAQ! (pclinuxos.com)](https://www.pclinuxos.com/forum/index.php?topic=104936.0)
- [(138条消息) Centos7.x搭建Snort IDS入侵检测环境_afei00123的博客-CSDN博客](https://blog.csdn.net/qq_41490561/article/details/104008353?ops_request_misc=&request_id=&biz_id=102&utm_term=snort%20%E5%90%AF%E5%8A%A8%20IDS%20%20%E6%A8%A1%E5%BC%8F&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-104008353.142^v56^control,201^v3^add_ask&spm=1018.2226.3001.4187)

# Snort + guardian
- [(138条消息) Snort与防火墙Iptables联动_半砖的博客-CSDN博客_snort与iptables联动](https://blog.csdn.net/hexf9632/article/details/98200876)
- [Linux：IPtable与Snort联动测试 (361shipin.com)](https://www.361shipin.com/blog/1511940369749639168#_106)
- 安装步骤还是比较简单的，明天试一试。


# 规划
ubuntu 安装 snort 有 17 个部分，半个月时间 + 半个月时间去看 snort 的文档和联动

总共给你 1 个月的时间
