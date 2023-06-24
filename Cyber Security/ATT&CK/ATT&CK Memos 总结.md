- Time：2023-06-24 16:28
- Label： #ATTCK #summary #security #memos

## Abstract

整理记录在 memos 上 ATT&CK 的笔记内容

## Content

### 服务器环境部署

软件环境 + 硬件环境

#### 硬件环境

- 系统部署需要的最小系统环境

#### 软件环境

- HIDS 部署环境不用写，写操作 command 获取密码的命令行
- Suricata 部署环境
- 软件部署 (Java 中间件、Python 后端、Vue 前端 X2) ，为什么修改 IP。

```shell
curl -XGET "http://192.168.2.171:8081/wazuh/indexer/alerts/brief?from=0&size=1&level=0,15"
curl -XGET "http://192.168.2.171:8081/wazuh/indexer/nids/alerts/detail/?begin=now-1d&end=now&from=0&size=1&level=1,3"
```

### 高级告警

1. HTBot

```shell
"ET POLICY Spotify P2P Client"
"GPL SNMP public access udp"
"ET POLICY Windows 3.1 User-Agent Detected - Possible Malware or Non-Updated System"
"ET POLICY Unsupported/Fake Internet Explorer Version MSIE 5."
"ET POLICY Possible External IP Lookup whoer.net"
"ET POLICY HTTP POST contains pass= in cleartext"
"ET POLICY Dropbox Client Broadcasting"
"ET POLICY Windows 98 User-Agent Detected - Possible Malware or Non-Updated System"
"ET POLICY Http Client Body contains pwd= in cleartext"
"ET POLICY Known External IP Lookup Service Domain in SNI"
"ET POLICY Unsupported/Fake Internet Explorer Version MSIE 3."
"ET POLICY Vulnerable Java Version 1.4.x Detected"
"ET POLICY Outgoing Basic Auth Base64 HTTP Password detected unencrypted"
"ET POLICY Unsupported/Fake Internet Explorer Version MSIE 2."
"ET MOBILE_MALWARE Android/Geost CnC Checkin"
"ET POLICY PE EXE or DLL Windows file download HTTP"
"ET POLICY Possible IP Check api.ipify.org"
"ET POLICY Unsupported/Fake Internet Explorer Version MSIE 4."
"ET POLICY Windows 98 User-Agent Detected - Possible Malware or Non-Updated System (Win98)"
"ET MALWARE Win32/Htbot.B Checkin"
"ET POLICY HTTP Outbound Request contains pw"
"ET POLICY HTTP HEAD invalid method case outbound"
"ET POLICY Executable served from Amazon S3"
```

1. Zeus

```shell
"ET MALWARE Possible Compromised Host AnubisNetworks Sinkhole Cookie Value Snkz"
"ET MALWARE Possible Compromised Host AnubisNetworks Sinkhole Cookie Value btst"
"ET MALWARE Possible Zeus GameOver/FluBot Related DGA NXDOMAIN Responses"
"ET MALWARE Known Sinkhole Response Header"
"ET MALWARE DNS Reply Sinkhole - Anubis - 195.22.26.192/26"
"ET MALWARE Possible Zeus GameOver Connectivity Check"
```

1. BitCoinMiner

```shell
"ET SCAN Potential VNC Scan 5900-5920"
"ET POLICY Cryptocurrency Miner Checkin"
"ET POLICY Dropbox Client Broadcasting"
"ET SCAN Suspicious inbound to Oracle SQL port 1521"
"ET SCAN Potential VNC Scan 5800-5820"
"ET SCAN Suspicious inbound to PostgreSQL port 5432"
"ET SCAN Suspicious inbound to mySQL port 3306"
"ET SCAN Suspicious inbound to MSSQL port 1433"
"ET POLICY Spotify P2P Client"
"GPL SNMP public access udp"
```

1. CCleanerTrojanVersion

```shell
"ET POLICY PE EXE or DLL Windows file download HTTP"
"ET MALWARE CCleaner Backdoor DGA Domain (ab70a139cc3a.com) Dec 2017"
"ET POLICY Dropbox Client Broadcasting"
"ET POLICY Spotify P2P Client"
```

1. Bladabindi

```shell
"ET MALWARE njrat ver 0.7d Malware CnC Callback (File Manager Actions)"
"ET MALWARE Generic njRAT/Bladabindi CnC Activity (ll)"
"ET POLICY DNS Query to DynDNS Domain *.ddns .net"
"ET MALWARE njrat ver 0.7d Malware CnC Callback Response (Remote Desktop)"
"ET MALWARE njrat ver 0.7d Malware CnC Callback (Remote Desktop)"
```

1. Pony

```shell
"ET MALWARE Pony Downloader HTTP Library MSIE 5 Win98"
"ET POLICY Unsupported/Fake Internet Explorer Version MSIE 5."
"ET MALWARE Fareit/Pony Downloader Checkin 3"
"ET POLICY Windows 98 User-Agent Detected - Possible Malware or Non-Updated System"
```

### 部署文档

部署文档

1. 威胁库前端 ip
2. 威胁库后端 0.0.0.0:8000
3. 项目前端 config ip
4. 项目 pyapi ---> ip vmware
5. wazuh 中间件 ---> 不需要改动

### 部署

目前存在问题

- [x] 威胁库 IP
- [x] 溯源图获取后端数据
- [x] 钓鱼 ---> 暴力破解 ✅ 2023-06-24
- [x] 文档语句优化
- [x] 刷新的失效
- [x] Agent 数量获取的问题
- [x] ATTVueFrontend public/server.json ✅ 2023-06-24
- [x] ATTVueBackend server.json ✅ 2023-06-24
- [x] ATTThreatFrontend basic url ✅ 2023-06-24
- [x] ATTThreatBackend setting.py ✅ 2023-06-24  
服务器端口映射  
wazuh 端口  
1514 Agent connection service  
1515 Agent enrollment service  
55000 Wazuh server RESTful API  
9200 Wazuh indexer RESTful API  
443 Wazuh web user interface  
514 Wazuh Syslog collector (disabled by default  
服务端口  
8000: 威胁库后端  
8001: 威胁关联 python 后端  
8081: wazuh 后端  
8082: 威胁库前端  
8083: 项目前端

### Wazuh 登录

后端环境安装

1. wazuh 安装，弹出所有的密码
2. 写后端中间件的配置
3. 启动后端
4. python 那部分 API + 前端的部署  
还有端口映射问题，windows 把端口都映射出来捏  
password

```shell
# Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'admin'
  indexer_password: '?XoY.2y9zepB36zYlJBbqEX2xeNV6yPo'
# Wazuh dashboard user for establishing the connection with Wazuh indexer
  indexer_username: 'kibanaserver'
  indexer_password: 'lVK9HKoOXMgYrRW0lJgz1+y?GcL44etr'
# Regular Dashboard user, only has read permissions to all indices and all permissions on the .kibana index
  indexer_username: 'kibanaro'
  indexer_password: 'KYrF+YeSOEAzxBqmq7DCOn9lfR7R?4wa'
# Filebeat user for CRUD operations on Wazuh indices
  indexer_username: 'logstash'
  indexer_password: '1vFp+Ddt4EtihheG+ZISWrajJLVr?Uux'
# User with READ access to all indices
  indexer_username: 'readall'
  indexer_password: '8zJo*+nOcl?*sxQ17kktV.QEzTjmfWN7'
# User with permissions to perform snapshot and restore operations
  indexer_username: 'snapshotrestore'
  indexer_password: 'CRAIr3oXhgppR6q2LDa9Xudh2Q4v?XP*'
# Password for wazuh API user
  api_username: 'wazuh'
  api_password: 'scFChT030H6D2SRtlkWmYf*?ou*AwoJ6'
# Password for wazuh-wui API user
  api_username: 'wazuh-wui'
  api_password: '3nx09fOBHXWpOmW*4gQHXa49lR?F?GSL'
```

1. 安装 wazuh 并获取密码
2. 安装 mysql 的内容
3. 修改配置文件
4. 测试 java 环境 api 是否可用 (但是需要重新设置规则)
- [解决mysql问题](https://blog.csdn.net/weixin_43639345/article/details/121338716?ops_request_misc=&request_id=&biz_id=102&utm_term=docker%20MySQL%20Failed%20to%20open%20fi&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-121338716.nonecase&spm=1018.2226.3001.4187)
- [Java 安装](https://blog.csdn.net/weixin_50843918/article/details/122262306)

```shell
nohup java -jar AttackDetection-1.0-SNAPSHOT.jar > attack_detection.log 2>&1 &
```

1. 安装威胁库后端

```shell
python3 manage.py runserver 0.0.0.0:8000 < nohup
```

1. 安装威胁库前端

## Reference
