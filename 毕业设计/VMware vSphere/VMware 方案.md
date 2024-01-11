## VMware Workstation

### 网络拓扑

![[Snipaste/Pasted image 20240109155445.png]]

### 操作步骤

#### 环境配置

1. 创建虚拟机
2. 根据网络拓扑进行网络配置
	1. 配置静态 IP

```shell
# 设置用户名和密码
(base) PS C:\Program Files (x86)\VMware\VMware Workstation> vmrest -C
# 启动 VMware Workstation RESTful API
(base) PS C:\Program Files (x86)\VMware\VMware Workstation> vmrest
VMware Workstation REST API
Copyright (C) 2018-2022 VMware Inc.
All Rights Reserved

vmrest 1.2.1 build-20089737
-
Using the VMware Workstation UI while API calls are in progress is not recommended and may yield unexpected results.
-
Serving HTTP on 127.0.0.1:8697
-
```

### RESTful API 封装

- [VMware Workstation Pro API - VMware API Explorer](https://developer.vmware.com/apis/412/vmware-workstation-pro-api/)
- VM Management
- VM Power Management
- VM Shared Folders Management
- VM Network Adapters Management
- Host Networks Management

![[Snipaste/Pasted image 20240109160627.png]]

### 限制

- 缺少创建虚拟机的 API，**但是可以 copy**。
	- 只能预先创建拓扑环境 + 启动
- API 相对比较简单
- 没有办法管理复杂网络 | **未验证**

### 后续的工作

- 封装 VMware workstation 的网络配置，维护网络信息。
- 网络拓扑的抽象。
- 准备更新虚拟机方案。
- 配置和创建不同类型虚拟机。
	- 路由功能
	- 个人计算机
	- Redis 服务器
	- MySQL 服务器
	- 。。。
- **需求分析**。

### 控制机制

控制的内容包含哪些层面：  

- 网络  
- 虚拟机  
- 服务  
- 内容类的

典型场景的配置文件：

网络环境中必须包含控制节点，控制节点需要最高权限，并且能够与任意一个节点进行通信。同时需要管理 IP 和拓扑信息。

controller 节点需要包含的功能：

1. 通过 controller 初始化整体网络环境 | VPN 技术？
2. 保存整体拓扑结构、记录蜜网调整日志、提供调整蜜网的接口
3. 虚拟机本身的启停和配置

内网的主机怎么和外网的主机进行通信呢？NAT？VPN？—— **需要解决的问题**

**思考到控制节点的功能和网络通信相关问题这里**

#### 网络

提供的功能

- IP 的自动分配和手动配置

整体初始化配置文件的设计

- network
	- network_name: MyNetwork
	- network_id: 192.168.1.0/24
	- mask: 255.255.255.0
- router
	- router_name: r1
	- **划分网段应该如何表示呢**？| 创建不同的 vth
- host
	- host_name: h1
	- type: controller | host
	- network
		- ipv4: 192.168.1.128
		- mask: 255.255.255.0
		- gateway: 192.168.1.2
		- dns: 8.8.8.8 114.114.114.114
	- image: image_name:version(image_name 不能冲突)
	- 构建服务的脚本

需要做的工作

- 创建服务的脚本 —— **配置中心**、配置中心要怎么设计呢？
- 虚拟机的镜像库 —— 需要创建可以复用的。**不符合事实你知道嘛**？
- 线索仓库
	- 文本内容
		- 普通文本内容
		- 邮件内容
		- 日志内容
		- and so on
- 修改虚拟机相关内容的接口
	- 内容 | 添加 | 覆盖 | 修改
		- 文件内容
		- 邮件内容
		- and so on
	- 虚拟机的启停和配置

基础的组件是必须要有的，比如基础的组件，MySQL、Redis、Kafka 消息队列中间件。

可以参考的配置文件写法

- kubernetes
- 别人设计的蜜网描述语言
- 扩展的蜜网描述语言
- 路由表

通过划分子网创建路由器，**路由器资源池**——修改和变更他们的网卡。

```yml
# 网络基本配置
network_name: MyNetwork
network_id: 192.168.1.0/24

# 路由器配置
router:
  model: ModelXYZ
  ip_address: 192.168.1.1
  subnet_mask: 255.255.255.0
  dhcp_enabled: true
  nat_enabled: true
```

## VMware vSphere

![[Snipaste/Pasted image 20240109091631.png]]

- [vmware/pyvmomi: VMware vSphere API Python Bindings (github.com)](https://github.com/vmware/pyvmomi)
- [vSphere Web Services API - VMware API Explorer](https://developer.vmware.com/apis/1720/vsphere/)

#chatgpt

> VMware vSphere 是由 VMware 公司提供的一套**虚拟化和云计算基础设施**解决方案。vSphere 提供了一系列的虚拟化技术，使企业能够构建、管理和优化其虚拟化基础设施。这个解决方案涵盖了服务器虚拟化、存储虚拟化、网络虚拟化等多个方面，旨在提供一个灵活、高效、可靠的数据中心平台。
> 
> 主要组件和功能包括：
> 
> 1. **ESXi（vSphere Hypervisor）：** ESXi 是 VMware 的裸机虚拟化平台，允许在物理硬件上运行多个虚拟机。它是一个轻量级的、高度优化的虚拟化操作系统。
> 2. **vCenter Server：** vCenter Server 是 vSphere 的中央管理服务器，用于集中管理和监控多个 ESXi 主机。它提供了一种集中式的管理平台，可以通过图形用户界面或 API 进行管理。
> 3. **vSphere Client：** vSphere Client 是用于管理和配置虚拟化环境的图形用户界面。它提供直观的操作界面，用于执行任务、监控性能、配置虚拟机等。
> 4. **vMotion：** 允许在不间断地运行虚拟机的情况下将其从一个 ESXi 主机迁移到另一个主机。
> 5. **Storage vMotion：** 允许在运行的虚拟机的存储迁移，而不会中断虚拟机的服务。
> 6. **High Availability（HA）：** 提供在 ESXi 主机故障时自动重新启动虚拟机的能力，确保业务连续性。
> 7. **Distributed Resource Scheduler（DRS）：** 自动平衡虚拟机在集群中的负载，以优化性能和资源利用率。
> 8. **vSphere Replication：** 提供虚拟机级别的复制，以确保在灾难发生时数据的可用性。
> 9. **vSphere Update Manager（VUM）：** 用于管理和应用 ESXi 主机和虚拟机的软件补丁和升级。
> 
> VMware vSphere 为企业提供了灵活性、可靠性和性能优势，使其能够更有效地管理和利用数据中心资源。

## Reference

- [VMware vSphere 文档](https://docs.vmware.com/cn/VMware-vSphere/index.html)
- [vmware/pyvmomi: VMware vSphere API Python Bindings (github.com)](https://github.com/vmware/pyvmomi?tab=readme-ov-file#getting-started)  

[VMware Developer](https://developer.vmware.com/home) 是专供开发人员和自动化社区使用的网站。要了解 vSphere API、SDK 和命令行界面，请访问以下 VMware 开发人员资源：

- [VMware SDK](https://developer.vmware.com/sdks)
- [VMware API](https://developer.vmware.com/apis)
- 自动化工具下的 [VMware 命令行界面](https://developer.vmware.com/resources)

---

- [在两个仅主机模式网络之间设置路由 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-87995B4F-5945-4AF8-86D1-1003DDEFCF25.html)

## 需求分析

- RE
- PHP
- Dappa
- 应对钓鱼攻击

---

共有的偏执 ---> 线索 ---> **搜集信息** ---> 识别偏执 ---> 生成策略 ---> **调整蜜网**

生成环境随机性 ---> 调整环境的随机性

构建 (虚拟机比较容易) + 调整 (网络更改比较困难，新创建比较 ok)

5 ~ 6 个虚拟机

- 邮件服务器
- OA
- 网盘

页面相关

- 整体页面
	- 拓扑类型
	- 多层结构
- 配置页面
- 系统更新日志展示
- 策略的列表

---

钓鱼检测：3 种智能算法，支持至少 100 家的钓鱼网站检测

- vSphere 分布式环境
- kloc
- **酷炫的前端效果**

---

- 初步思路
- 细致
- 配置
- 控制机制
- 反馈 —— 协议机制。

---
