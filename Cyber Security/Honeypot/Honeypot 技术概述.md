#chatgpt #honeypot #security

## 基本概念

- honeypot
- honeydata
- honeynet
- 欺骗防御
- [[../../Basic/计算机网络/SDN/SDN 技术|SDN 技术]]
- 牵引技术
- [[../../Cloud Native/K8s/K8s 基础知识/K8s 基础知识|K8s 基础知识]]
- 容器技术 docker | containerd

## Honeypot and Kuberne

你可以利用虚拟化技术部署你的蜜罐，但问题是例如一些系统级别的漏洞是没有办法模拟的，因为 docker 调用的是 host 的系统调用，因此在 linux 主机下没有办法虚拟化以 linux 作为操作系统的容器。

- [在Kubernetes中创建与部署蜜罐 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/network/208895.html)

## Thinks

通过异构的系统，可以利用攻击者检测系统内存在的 0day，但是攻击者一旦建立了蜜网系统和真实系统之间的联系，真实系统将会变得很危险。

## Reference

- [[../认知偏执脆弱性/认知偏执脆弱性调研|认知偏执脆弱性调研]]
- [[../认知偏执脆弱性/脚本|脚本]]
- [[../认知偏执脆弱性/架构图|架构图]]
- [8.12. 蜜罐技术 — Web安全学习笔记 1.0 文档 (websec.readthedocs.io)](https://websec.readthedocs.io/zh/latest/defense/honeypot.html)
- [在Kubernetes中创建与部署蜜罐 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/network/208895.html)
- [[../../Website/8.12. 蜜罐技术 — Web安全学习笔记 1.0 文档|8.12. 蜜罐技术 — Web安全学习笔记 1.0 文档]]
- [[../../Paper/Paper/Honeypots/How to Mock a Bear Honeypot, Honeynet, Honeywall & Honeytoken.pdf|How to Mock a Bear Honeypot, Honeynet, Honeywall & Honeytoken]]
