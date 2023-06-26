- Time：2023-06-26 09:39
- Label： #渗透 #deeplocker #CVE #漏洞利用

## Abstract

整体的流程如下：

1. 可能利用弱口令进入服务后台管理器
2. 然后寻找上传点，上传反弹 shell 代码
3. 通过 kali 去访问上传的一句话木马
4. 上传载荷

注意：这也可以是利用某个漏洞 getshell 的方式

需要注意的是 CVE 应该是 windows getshell 的复现，因为 Linux 不好演示

现在需要做的事情是将 deeplocker 迁移到虚拟机上面执行成功：

- [ ] tensorflow 依赖的安装
- [ ] 安装 anaconda 环境，开启录音的服务
- [ ] 然后应该没有别的了叭，其实挺简单的，但是今天的任务是在自己的电脑上进行演示
- [ ] 要找到一个你能说清楚原理的 CVE

在发现一个漏洞之后，公司的安全部门需要编写针对于该漏洞的扫描和验证程序，比如对于 Python 的各个版本来说，测试是否包含该漏洞。

## Content

### 资料搜集

- [tr0uble-mAker/POC-bomber: 利用大量高威胁poc/exp快速获取目标权限，用于渗透和红队快速打点 (github.com)](https://github.com/tr0uble-mAker/POC-bomber)

上面的是各种漏洞的扫描，通过扫描进行快速打点。同时代码审计也是非常重要的。

### CVE 搜集

- [k8gege/ZimbraExploit: Zimbra邮件系统漏洞 XXE/RCE/SSRF/Upload GetShell Exploit 1. (CVE-2019-9621 Zimbra<8.8.11 XXE GetShell Exploit) (github.com)](https://github.com/k8gege/ZimbraExploit)
- [0x6b7966/CVE-2019-0708-RCE: CVE-2019-0708 RCE远程代码执行getshell教程 (github.com)](https://github.com/0x6b7966/CVE-2019-0708-RCE)

## Reference
