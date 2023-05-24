## Namp 功能

- 主机发现
- 端口扫描
- 版本测试
- OS 检测
- 可与脚本进行脚本交互：使用 Nmap 脚本引擎（NSE）和 Lua 编程语言
- [x] 安装完成

```shell
nmap -sV -p 1-65535 192.168.1.1/24
```

```shell
Starting Nmap 7.92 ( https://nmap.org ) at 2022-11-17 09:59 EST
Stats: 0:00:05 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 8.38% done; ETC: 10:00 (0:00:22 remaining)
Stats: 0:00:10 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 13.77% done; ETC: 10:00 (0:00:50 remaining)
Stats: 0:00:13 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 17.91% done; ETC: 10:00 (0:00:50 remaining)
Stats: 0:00:43 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 55.78% done; ETC: 10:01 (0:00:32 remaining)
Stats: 0:01:01 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 77.50% done; ETC: 10:01 (0:00:17 remaining)
Stats: 0:01:02 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 79.08% done; ETC: 10:01 (0:00:16 remaining)
Stats: 0:01:08 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 83.72% done; ETC: 10:01 (0:00:13 remaining)
Stats: 0:01:24 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 92.54% done; ETC: 10:01 (0:00:07 remaining)
Stats: 0:01:26 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 93.00% done; ETC: 10:01 (0:00:06 remaining)
Stats: 0:01:39 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 97.10% done; ETC: 10:01 (0:00:03 remaining)
Stats: 0:01:44 elapsed; 250 hosts completed (4 up), 4 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 98.55% done; ETC: 10:01 (0:00:01 remaining)
Stats: 0:02:00 elapsed; 250 hosts completed (4 up), 4 undergoing Service Scan
Service scan Timing: About 41.18% done; ETC: 10:02 (0:00:16 remaining)
WARNING: Service 192.168.184.128:9200 had already soft-matched rtsp, but now soft-matched sip; ignoring second value
Stats: 0:02:21 elapsed; 250 hosts completed (4 up), 4 undergoing Service Scan
Service scan Timing: About 70.59% done; ETC: 10:02 (0:00:13 remaining)
Stats: 0:03:12 elapsed; 250 hosts completed (4 up), 4 undergoing Service Scan
Service scan Timing: About 94.12% done; ETC: 10:03 (0:00:05 remaining)
Stats: 0:03:35 elapsed; 250 hosts completed (4 up), 4 undergoing Service Scan
Service scan Timing: About 94.12% done; ETC: 10:03 (0:00:07 remaining)
Stats: 0:03:50 elapsed; 250 hosts completed (4 up), 4 undergoing Service Scan
Service scan Timing: About 94.12% done; ETC: 10:03 (0:00:08 remaining)
Nmap scan report for 192.168.184.1
Host is up (0.0011s latency).
Not shown: 65527 filtered tcp ports (no-response)
PORT      STATE SERVICE       VERSION
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds?
2179/tcp  open  vmrdp?
3462/tcp  open  track?
7680/tcp  open  pando-pub?
10003/tcp open  documentum_s?
49668/tcp open  msrpc         Microsoft Windows RPC
MAC Address: 00:50:56:C0:00:08 (VMware)
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Nmap scan report for 192.168.184.2
Host is up (0.00021s latency).
Not shown: 65534 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
53/tcp open  domain  (generic dns response: NOTIMP)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port53-TCP:V=7.92%I=7%D=11/17%Time=63764CD6%P=x86_64-pc-linux-gnu%r(DNS
SF:StatusRequestTCP,E,"\0\x0c\0\0\x90\x04\0\0\0\0\0\0\0\0");
MAC Address: 00:50:56:F9:7A:06 (VMware)

Nmap scan report for 192.168.184.128
Host is up (0.00067s latency).
Not shown: 65527 closed tcp ports (reset)
PORT      STATE SERVICE        VERSION
22/tcp    open  ssh            OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
443/tcp   open  ssl/https
1514/tcp  open  fujitsu-dtcns?
1515/tcp  open  tcpwrapped
9200/tcp  open  ssl/rtsp
9300/tcp  open  ssl/vrace?
9650/tcp  open  unknown
55000/tcp open  ssl/http       aiohttp 3.8.1 (Python 3.9)
3 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port443-TCP:V=7.92%T=SSL%I=7%D=11/17%Time=63764CDB%P=x86_64-pc-linux-gn
SF:u%r(HTTPOptions,143,"HTTP/1\.1\x20404\x20Not\x20Found\r\nosd-name:\x20w
SF:azuh-server\r\nx-frame-options:\x20sameorigin\r\ncontent-type:\x20appli
SF:cation/json;\x20charset=utf-8\r\ncache-control:\x20private,\x20no-cache
SF:,\x20no-store,\x20must-revalidate\r\ncontent-length:\x2060\r\nDate:\x20
SF:Thu,\x2017\x20Nov\x202022\x2015:01:48\x20GMT\r\nConnection:\x20close\r\
SF:n\r\n{\"statusCode\":404,\"error\":\"Not\x20Found\",\"message\":\"Not\x
SF:20Found\"}")%r(FourOhFourRequest,1C9,"HTTP/1\.1\x20401\x20Unauthorized\
SF:r\nosd-name:\x20wazuh-server\r\nx-frame-options:\x20sameorigin\r\nconte
SF:nt-type:\x20application/json;\x20charset=utf-8\r\ncache-control:\x20pri
SF:vate,\x20no-cache,\x20no-store,\x20must-revalidate\r\nset-cookie:\x20se
SF:curity_authentication=;\x20Max-Age=0;\x20Expires=Thu,\x2001\x20Jan\x201
SF:970\x2000:00:00\x20GMT;\x20Secure;\x20HttpOnly;\x20Path=/\r\ncontent-le
SF:ngth:\x2077\r\nDate:\x20Thu,\x2017\x20Nov\x202022\x2015:01:48\x20GMT\r\
SF:nConnection:\x20close\r\n\r\n{\"statusCode\":401,\"error\":\"Unauthoriz
SF:ed\",\"message\":\"Authentication\x20required\"}")%r(tor-versions,1C,"H
SF:TTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(RTSPRequest,1C,"HTTP/1\.1
SF:\x20400\x20Bad\x20Request\r\n\r\n")%r(RPCCheck,1C,"HTTP/1\.1\x20400\x20
SF:Bad\x20Request\r\n\r\n")%r(DNSVersionBindReqTCP,1C,"HTTP/1\.1\x20400\x2
SF:0Bad\x20Request\r\n\r\n")%r(DNSStatusRequestTCP,1C,"HTTP/1\.1\x20400\x2
SF:0Bad\x20Request\r\n\r\n")%r(Help,1C,"HTTP/1\.1\x20400\x20Bad\x20Request
SF:\r\n\r\n")%r(SSLSessionReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r
SF:\n")%r(TerminalServerCookie,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\
SF:r\n")%r(TLSSessionReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%
SF:r(Kerberos,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(SMBProgNe
SF:g,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(X11Probe,1C,"HTTP/
SF:1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(LPDString,1C,"HTTP/1\.1\x2040
SF:0\x20Bad\x20Request\r\n\r\n")%r(LDAPSearchReq,1C,"HTTP/1\.1\x20400\x20B
SF:ad\x20Request\r\n\r\n")%r(LDAPBindReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Re
SF:quest\r\n\r\n")%r(SIPOptions,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n
SF:\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9200-TCP:V=7.92%T=SSL%I=7%D=11/17%Time=63764CE4%P=x86_64-pc-linux-g
SF:nu%r(GetRequest,9B,"HTTP/1\.0\x20401\x20Unauthorized\r\nWWW-Authenticat
SF:e:\x20Basic\x20realm=\"OpenSearch\x20Security\"\r\ncontent-type:\x20tex
SF:t/plain;\x20charset=UTF-8\r\ncontent-length:\x2012\r\n\r\nUnauthorized"
SF:)%r(HTTPOptions,67,"HTTP/1\.0\x20200\x20OK\r\nAllow:\x20DELETE,GET,HEAD
SF:\r\ncontent-type:\x20text/plain;\x20charset=UTF-8\r\ncontent-length:\x2
SF:00\r\n\r\n")%r(RTSPRequest,67,"RTSP/1\.0\x20200\x20OK\r\nAllow:\x20DELE
SF:TE,GET,HEAD\r\ncontent-type:\x20text/plain;\x20charset=UTF-8\r\ncontent
SF:-length:\x200\r\n\r\n")%r(FourOhFourRequest,F3,"HTTP/1\.0\x20405\x20Met
SF:hod\x20Not\x20Allowed\r\nAllow:\x20POST\r\ncontent-type:\x20application
SF:/json;\x20charset=UTF-8\r\ncontent-length:\x20127\r\n\r\n{\"error\":\"I
SF:ncorrect\x20HTTP\x20method\x20for\x20uri\x20\[/nice%20ports%2C/Tri%6Eit
SF:y\.txt%2ebak\]\x20and\x20method\x20\[GET\],\x20allowed:\x20\[POST\]\",\
SF:"status\":405}")%r(SIPOptions,6A,"SIP/2\.0\x20200\x20OK\r\nAllow:\x20DE
SF:LETE,GET,PUT,HEAD\r\ncontent-type:\x20text/plain;\x20charset=UTF-8\r\nc
SF:ontent-length:\x200\r\n\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port9650-TCP:V=7.92%I=7%D=11/17%Time=63764CD5%P=x86_64-pc-linux-gnu%r(N
SF:ULL,28,"\0\0\x12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\0\0\
SF:x06\0\0\x20\0\0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01")%r(GenericLines,8F,"\0
SF:\0\x12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\0\0\x06\0\0\x2
SF:0\0\0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01\0\0\^\x07\0\0\0\0\0\0\0\0\0\0\0\0
SF:\x01HTTP/2\x20client\x20preface\x20string\x20missing\x20or\x20corrupt\.
SF:\x20Hex\x20dump\x20for\x20received\x20bytes:\x200d0a0d0a")%r(GetRequest
SF:,5C,"\0\0\x12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\0\0\x06
SF:\0\0\x20\0\0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01\0\0\+\x07\0\0\0\0\0\0\0\0\
SF:0\0\0\0\x01Unexpected\x20HTTP/1\.x\x20request:\x20GET\x20/\x20")%r(HTTP
SF:Options,60,"\0\0\x12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\
SF:0\0\x06\0\0\x20\0\0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01\0\0/\x07\0\0\0\0\0\
SF:0\0\0\0\0\0\0\x01Unexpected\x20HTTP/1\.x\x20request:\x20OPTIONS\x20/\x2
SF:0")%r(RTSPRequest,B3,"\0\0\x12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x0
SF:4\0\x10\0\0\0\x06\0\0\x20\0\0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01\0\0\x82\x
SF:07\0\0\0\0\0\0\0\0\0\0\0\0\x01HTTP/2\x20client\x20preface\x20string\x20
SF:missing\x20or\x20corrupt\.\x20Hex\x20dump\x20for\x20received\x20bytes:\
SF:x204f5054494f4e53202f20525453502f312e300d0a0d0a")%r(RPCCheck,B7,"\0\0\x
SF:12\x04\0\0\0\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\0\0\x06\0\0\x20\0\
SF:0\0\x04\x08\0\0\0\0\0\0\x0f\0\x01\0\0\x86\x07\0\0\0\0\0\0\0\0\0\0\0\0\x
SF:01HTTP/2\x20client\x20preface\x20string\x20missing\x20or\x20corrupt\.\x
SF:20Hex\x20dump\x20for\x20received\x20bytes:\x208000002872fe1d13000000000
SF:0000002000186a00001977c")%r(DNSVersionBindReqTCP,B7,"\0\0\x12\x04\0\0\0
SF:\0\0\0\x03\x7f\xff\xff\xff\0\x04\0\x10\0\0\0\x06\0\0\x20\0\0\0\x04\x08\
SF:0\0\0\0\0\0\x0f\0\x01\0\0\x86\x07\0\0\0\0\0\0\0\0\0\0\0\0\x01HTTP/2\x20
SF:client\x20preface\x20string\x20missing\x20or\x20corrupt\.\x20Hex\x20dum
SF:p\x20for\x20received\x20bytes:\x20001e000601000001000000000000077665727
SF:3696f6e0462")%r(DNSStatusRequestTCP,A3,"\0\0\x12\x04\0\0\0\0\0\0\x03\x7
SF:f\xff\xff\xff\0\x04\0\x10\0\0\0\x06\0\0\x20\0\0\0\x04\x08\0\0\0\0\0\0\x
SF:0f\0\x01\0\0r\x07\0\0\0\0\0\0\0\0\0\0\0\0\x01HTTP/2\x20client\x20prefac
SF:e\x20string\x20missing\x20or\x20corrupt\.\x20Hex\x20dump\x20for\x20rece
SF:ived\x20bytes:\x20000c000010000000000000000000");
MAC Address: 00:0C:29:DC:31:EC (VMware)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for 192.168.184.254
Host is up (0.00032s latency).
All 65535 scanned ports on 192.168.184.254 are in ignored states.
Not shown: 65535 filtered tcp ports (no-response)
MAC Address: 00:50:56:EC:BF:9A (VMware)

Nmap scan report for 192.168.184.130
Host is up (0.0000040s latency).
Not shown: 65534 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.0p1 Debian 1+b1 (protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (5 hosts up) scanned in 267.85 seconds


```

## Reference

- [Nmap 简介和使用方法](https://blog.csdn.net/m1585761297/article/details/80015726)
- [Nmap Tutorial: from the Basics to Advanced Tips (hackertarget.com)](https://hackertarget.com/nmap-tutorial/)
