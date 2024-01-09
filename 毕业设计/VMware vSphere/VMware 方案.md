![[Snipaste/Pasted image 20240109091631.png]]

- 复制连接

现在的方案大概是完全基于虚拟机的，不要进行否定。

## VMware Workstation

### 网络拓扑

### 操作步骤

#### 环境配置

1. 创建虚拟机
2. 根据网络拓扑进行网络配置
	1. 配置静态 IP
3. 关闭相应的虚拟机

### RESTful API 封装

- [VMware Workstation Pro API - VMware API Explorer](https://developer.vmware.com/apis/412/vmware-workstation-pro-api/)

### 限制

- 缺少创建虚拟机的 API
	- 只能预先创建完拓扑环境 + 启动
- API 相对比较简单

## VMware EXSi and Server

## Reference

- [VMware vSphere 文档](https://docs.vmware.com/cn/VMware-vSphere/index.html)
- [vmware/pyvmomi: VMware vSphere API Python Bindings (github.com)](https://github.com/vmware/pyvmomi?tab=readme-ov-file#getting-started)  
[VMware Developer](https://developer.vmware.com/home) 是专供开发人员和自动化社区使用的网站。要了解 vSphere API、SDK 和命令行界面，请访问以下 VMware 开发人员资源：

- [VMware SDK](https://developer.vmware.com/sdks)
- [VMware API](https://developer.vmware.com/apis)
- 自动化工具下的 [VMware 命令行界面](https://developer.vmware.com/resources)

---
- [在两个仅主机模式网络之间设置路由 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-87995B4F-5945-4AF8-86D1-1003DDEFCF25.html)
