## 主要问题

1. 组网问题  

## 方案一：基于虚拟机

### 实现方案

- 通过虚拟化平台定制蜜罐镜像，通过保存和恢复快照的方式实现动态调整。
- 或者通过控制拥有高权限控制节点对整体网络和虚拟机进行控制。

### 基于 VMware

#### 优点

- 提供 API
- 可以实现应用级、服务级和主机级的蜜罐
- **克隆和快照：** 利用 VMware 的克隆和快照功能，可以迅速部署新的蜜网节点，以及在需要时还原到先前的状态，提高了蜜网的效率。

#### 缺点

- 创建和启动比较缓慢

### 基于 KVM

#### 优点

- 开源

#### 缺点

## 方案二：容器 Or 虚拟机 + Mininet 工具

- OA 系统 | 多层的路由
- 可以实现组网
- 基于 docker 去做，也是没有问题的。docker 以指标为主的。
- [mininet/mininet: Emulator for rapid prototyping of Software Defined Networks (github.com)](https://github.com/mininet/mininet?tab=readme-ov-file)
- [Mininet中host与外网通信_host通讯-CSDN博客](https://blog.csdn.net/yeya24/article/details/79644520)

1. 怎么做的？
2. 可以实现？
3. SDN？

## 方案三：基于 Openstack

- 搭建私有云
- 我可能需要 2~3 台服务器，不需要

## 方案四：Openstack + K8s

- 对于服务级别的蜜罐，使用容器部署，借助 k8s 进行管理。
- 对于主机级别的蜜罐，使用虚拟机部署，借助 Openstack 进行组网和管理。

## 成本

- 时间成本
- 金钱成本
- 学习成本
- 试错成本
