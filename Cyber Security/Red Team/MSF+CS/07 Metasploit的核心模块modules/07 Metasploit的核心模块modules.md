msf的模块都放在

/usr/share/metasploit-framework/modules/这个目录下

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1640748958000/9e03e3c4dbc548d7b38c0389b1f131ab.png)


1 auxiliary:辅助模块，辅助渗透(端口扫描、登录密码爆破、漏洞验证等)

2 exploits:漏洞利用模块，包含主流的漏洞利用脚本，通常是对某些可能存在漏洞的目标进行漏洞利用。

3 payloads:攻击载荷，主要是攻击成功后在目标机器执行的代码,比如反弹shell的代码

4 post:后渗透阶段模块，漏洞利用成功获得meterpreter之后， 向目标发送的一些功能性

指令,如:提权等

5 encoders: 编码器模块，主要包含各种编码工具，对payload进行编码加密，以便绕过入侵检测和过滤系统

6 evasion:躲避模块，用来生成免杀payload

7 nops:这里主要放着调整shellcode 前置nop指令长度的工具（不理解没关系）
