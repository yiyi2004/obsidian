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
