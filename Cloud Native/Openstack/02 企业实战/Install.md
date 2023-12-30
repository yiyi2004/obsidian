## Installation

- 最简单的组成架构
- 概念架构和逻辑架构

控制节点和计算节点

## Overview

Use a deployment tool such as Ansible, Chef, Puppet, or Salt to automate deployment and management of the production environment. The OpenStack project has a couple of deployment projects with specific guides per version: - [Yoga release](https://docs.openstack.org/yoga/deploy/) - [Xena release](https://docs.openstack.org/xena/deploy/) - [Wallaby release](https://docs.openstack.org/wallaby/deploy/) - [Victoria release](https://docs.openstack.org/victoria/deploy/) - [Ussuri release](https://docs.openstack.org/ussuri/deploy/) - [Train release](https://docs.openstack.org/train/deploy/) - [Stein release](https://docs.openstack.org/stein/deploy/) - [Rocky release](https://docs.openstack.org/rocky/deploy/) - [Queens release](https://docs.openstack.org/queens/deploy/) - [Pike release](https://docs.openstack.org/pike/deploy/)

### Example Architecture

For more information on production architectures for Pike, see the [Architecture Design Guide](https://docs.openstack.org/arch-design/), [OpenStack Networking Guide for Pike](https://docs.openstack.org/neutron/pike/admin/), and [OpenStack Administrator Guides for Pike](https://docs.openstack.org/pike/admin/).

For more information on production architectures for Queens, see the [Architecture Design Guide](https://docs.openstack.org/arch-design/), [OpenStack Networking Guide for Queens](https://docs.openstack.org/neutron/queens/admin/), and [OpenStack Administrator Guides for Queens](https://docs.openstack.org/queens/admin/).

For more information on production architectures for Rocky, see the [Architecture Design Guide](https://docs.openstack.org/arch-design/), [OpenStack Networking Guide for Rocky](https://docs.openstack.org/neutron/rocky/admin/), and [OpenStack Administrator Guides for Rocky](https://docs.openstack.org/rocky/admin/).

![[Snipaste/Pasted image 20231230083901.png]]

### Networking

#### Networking Option 1: Provider Networks

![[Snipaste/Pasted image 20231230084435.png]]

#### Networking Option 2: Self-service Networks

![[Snipaste/Pasted image 20231230084446.png]]

## Environment

You must use an account with **administrative** privileges to configure each node. Either run the commands as the root user or configure the **sudo** utility.  

For best performance, we recommend that your environment meets or **exceeds** the hardware requirements in [Hardware requirements](https://docs.openstack.org/install-guide/overview.html#figure-hwreqs).

- Controller Node: 1 processor, 4 GB memory, and 5 GB storage
- Compute Node: 1 processor, 2 GB memory, and 10 GB storage

A single disk partition on each node works for most basic installations. However, you should consider [Logical Volume Manager (LVM)](https://docs.openstack.org/install-guide/common/glossary.html#term-Logical-Volume-Manager-LVM) for installations with **optional services such as Block Storage.**
