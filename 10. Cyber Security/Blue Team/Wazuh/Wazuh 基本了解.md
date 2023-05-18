- [ ] youtube
- [ ] 搭建 agent server
- [ ] 熟悉环境
- [ ] API 测试 —— Postman
- [ ] API 简单封装一手

# Overview
- [wazuh 介绍_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Tr4y1r74o/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- elasticsearch api
- zeak
- 看他在这耍纯纯的浪费时间。

- 恶意软件检测：软件在进程里面找不到，识别到恶意进程。没有进程会将自己无缘无故的隐藏起来
- 主动响应 avtivitive response

## Features
- Security Analytics
- Intrusion Detection
- Log Data Analysis
- File Integrity Monitoring
- Vulnerability Detection
- Incident Response
- Cloud Security
- Container Security
- Regulatory Compliance


- filter
- wazuh is build on the top of elk stack
- it can monitor networking equipment that can not run a wauh agent
- by the log file?

![[Pasted image 20221030154323.png]]

- virtual machine wazuh ova file.
- distributed module 

# Get Started
## Components

![[Pasted image 20221030170350.png]]
### Wazuh indexer

![[Pasted image 20221030170510.png]]
- JSON Document and  Each document correlates a set of keys

![[Pasted image 20221030170749.png]]
- ES?

- Query example and output 

```json
GET /wazuh-alerts-4.x-*/_search
{
  "query": {
    "bool": {
      "must": [
        {"term": { "rule.mitre.tactic": "Lateral Movement" } },
        {"term": { "rule.mitre.technique": "SSH" } }
      ]
    }
  },
  "sort": [
    { "timestamp": { "order": "desc" } }
  ],
  "size": 1
}
```

```json
{
   "timestamp" : "2022-04-24T17:24:56.110+0000",
   "agent" : {
    "ip" : "10.0.1.52",
    "name" : "Amazon",
    "id" : "001"
   },
   "data" : {
     "srcip" : "68.183.216.91",
     "srcport" : "53820"
   },
   "rule" : {
     "description" : "sshd: insecure connection attempt (scan).",
     "id" : "5706",
     "level" : 6,
     "pci_dss" : ["11.4"],
     "mitre" : {
       "technique" : [
         "SSH"
       ],
       "id" : ["T1021.004"],
       "tactic" : [
         "Lateral Movement"
      ]
     }
   },
   "full_log" : "Apr 24 17:24:55 ip-10-0-1-52 sshd[32179]: Did not receive identification string from 68.183.216.91 port 53820",
   "location" : "/var/log/secure",
   "predecoder" : {
     "hostname" : "ip-10-0-1-52",
     "program_name" : "sshd",
     "timestamp" : "Apr 24 17:24:55"
   },
   "decoder" : {
     "parent" : "sshd",
     "name" : "sshd"
   },
   "GeoLocation" : {
     "city_name" : "Frankfurt am Main",
     "country_name" : "Germany",
     "region_name" : "Hesse"
   }
}
```

### Wazuh Server
- The Wazuh server uses threat intelligence sources to improve its detection capabilities. It also enriches alert data by using the [MITRE ATT&CK](https://attack.mitre.org//) framework and regulatory compliance requirements such as PCI DSS, GDPR, HIPAA, CIS, and NIST 800-53, providing helpful context for security analytics.

#### Server architecture
![[Pasted image 20221030171426.png]]

#### Server Components

- **Agent enrollment service**
- **Agent connection service**
- **Analysis engine**
- **Wazuh RESTful API**
- **Wazuh cluster daemon**
- **Filebeat**

### Wazuh Dashboard

![[Pasted image 20221030173503.png]]
- Data visualization and analysis
- Agents monitoring and configuration
- Platform management
- **Developer tools**
	- **Ruleset**
	- **Developer tools**

![[Pasted image 20221030173711 1.png]]
![[Pasted image 20221030173715.png]]

### Wazuh Agent

![[Pasted image 20221030173750.png]]

#### Agent Modules
- **Log collector**: It supports XPath filters for Windows events and recognizes multi-line formats like Linux Audit logs. It can also enrich JSON events with additional metadata.
- **Command execution**:  Agents run authorized commands periodically
- **File integrity monitoring (FIM)**: This module monitors the file system, reporting when files are created, deleted, or modified.
- **Security configuration assessment (SCA)** :**What is  Center of Internet Security (CIS)**
- **System inventory**
- **Malware detection**
- **Active response**
- **Container security monitoring**
- **Cloud security monitoring**

- **上面是未完成部分，因为有很多概念都不懂**

#### Communication with Wazuh server
The Wazuh agent communicates with the [Wazuh server](https://documentation.wazuh.com/current/getting-started/components/wazuh-server.html) to ship collected data and security-related events. Besides, the agent sends operational data, reporting its configuration and status. Once connected, the agent can be upgraded, monitored, and configured remotely from the Wazuh server.

The communication of the agent with the server takes place through a secure channel (TCP or UDP), providing data encryption and compression in real time. Additionally, it includes flow control mechanisms to avoid flooding, queueing events when necessary, and protecting the network bandwidth.

You need to enroll the agent before connecting it to the server for the first time. This process provides the agent with a unique key used for authentication and data encryption.

## Architecture
- agent listens on port 1514
	- The file **/var/ossec/logs/archives/archives.json** contains all events whether they tripped a rule or not.
	- The file **/var/ossec/logs/alerts/alerts.json** contains only events that tripped a rule with high enough priority (the threshold is configurable).
- default AES encryption

### Wazuh indexer communication
- using TLS encryption
- indexer by default listening on port 9200/TCP

### Required ports

![[Pasted image 20221030230256.png]]

### Archival data storage
- .json or .log ---> text ---> hash
- On the other hand, you may choose to dispense with storing archive files and simply rely on the **Wazuh indexer** for archive storage.

## Use cases

### Log Data analysis

### File integrity monitoring

### Rootkits detection

### Active response

### Configuration assessment

### System inventory

### Vulnerability detection

### Cloud security

### Regulatory complicance

# Task
- [ ] complicate the 22 API test in two days;
- [ ] Deployment int 2 days;
- [ ] learning ELK stack and MYSQL Tech

# Install
- https://192.168.116.159/app/wazuh#/health-check
- Username: admin
- W9C+Y08yS*2WNskK6fA26O?bPp*9xiYM
- systemctl restart wazuh-manager ///     
- restart

Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'padmin'
  indexer_password: 'W9C+Y08yS*2WNskK6fA26O?bPp*9xiYM'

Wazuh dashboard user for establishing the connection with Wazuh indexer
  indexer_username: 'kibanaserver'
  indexer_password: '5mT8I3SCNMg+s4M*0Ns9FWM50?SF?4AD'

Regular Dashboard user, only has read permissions to all indices and all permissions on the .kibana index
  indexer_username: 'kibanaro'
  indexer_password: '0hOwSSmuynSVsiZPZg01RT2apG+yfm54'

Filebeat user for CRUD operations on Wazuh indices
  indexer_username: 'logstash'
  indexer_password: '5+tzTbiB7lQIy?H6kmScRJRX0+y0oqzA'

User with READ access to all indices
  indexer_username: 'readall'
  indexer_password: '?SEe.TAEaip0s2a7k3U9JTGMIEzYDr4M'

User with permissions to perform snapshot and restore operations
  indexer_username: 'snapshotrestore'
  indexer_password: 'SXNyrNf8xnTNwYTTbp89jONzZa*eP+0C'

Password for wazuh API user
  api_username: 'wazuh'
  api_password: '3D?ab85SDBhFlKem?sgTd4R3NYF1o29S'

Password for wazuh-wui API user
  api_username: 'wazuh-wui'
  api_password: 'gsFX9aY*Nzqkj+ZXj3et8epr.2mbYpFz'

```shell
 curl -u wazuh:'3D?ab85SDBhFlKem?sgTd4R3NYF1o29S' -k -X GET "https://localhost:55000/security/user/authenticate?raw=true"
```

```shell
systemctl restart wazuh-indexer-performance-analyzer.service wazuh-manager.service wazuh-indexer wazuh-dashboard.service 
```


# wazuh 解析
- Policy monitoring 公司里面日常会执行的 Policy 保证公司电脑的安全。
	- 员工系统
	- 邮件安全
	- 密码安全   
- configure 重要的部分 config your wazuh by configuration
- osquery
- set vulnerability-detector to yes
- doc explaih how vulnerability detection work.

- set agent osquery yes

## Level
| Level | Title                           | Description                                                          |
| ----- | ------------------------------- | -------------------------------------------------------------------- |
| 0     | Successful/Authorized events    | These include successful login attempts, firewall allow events, etc. |
| 2     | System low priority error       |  System notification or status messages. These have no security relevance.                                                                    |
| 3     | Successful/Authorized events    |  These include successful login attempts, firewall allow events, etc.                                                                    |
| 4     | System low priority error       |                                                                      |
| 5     | User generated error            |                                                                      |
| 6     | Low relevance attack            |                                                                      |
| 7     | "Bad word" matching             |                                                                      |
| 8     | First time seen                 |                                                                      |
| 9     | Error from invalid source       |                                                                      |
| 10    | Multiple user generated errors  |                                                                      |
| 11    | Integrity checking warning      |                                                                      |
| 12    | High importance event           |                                                                      |
| 13    | Unusual error (high importance) |                                                                      |
| 14    | High importance security event  |                                                                      |
| 15    | Severe attack                   |                                                                      |

# 需要关注
- User manual —— integration with external APIs 可以调用外部 API。
- [Sending messages using Incoming Webhooks | Slack](https://api.slack.com/messaging/webhooks)
- slack API
- [beats](https://github.com/elastic/beats)
- 如果你英语听力好一点，你就不至于学的这么慢了，国外的资源是真的多，你需要练习听力和口语。

- 周2、3 API 测试——主要、次要
- 周 4 beats slack API

# Reference
- [(91条消息) wazuh 收集 suricata eve.json日志_guoguangwu的博客-CSDN博客_suricata 日志](https://blog.csdn.net/guoguangwu/article/details/103137640?spm=1001.2101.3001.6650.3&depth_1-utm_relevant_index=4)
- [(91条消息) wazuh 日志收集原理分析_guoguangwu的博客-CSDN博客](https://blog.csdn.net/guoguangwu/article/details/102920674?spm=1001.2101.3001.6661.1&depth_1-utm_relevant_index=1)
- [(91条消息) Wazuh关联分析规则高级玩法_orright的博客-CSDN博客](https://blog.csdn.net/orright/article/details/120880062)
