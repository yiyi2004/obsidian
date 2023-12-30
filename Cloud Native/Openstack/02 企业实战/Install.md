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

### Security

```bash
$ openssl rand -hex 10
```

- `SERVICE_PASS`
- `SERVICE_DBPASS`

### Host Networking

![[Snipaste/Pasted image 20231230151745.png]]

### Network Time Protocol (NTP)

To properly synchronize services among nodes, you can install **Chrony**, an implementation of [NTP](https://docs.openstack.org/install-guide/common/glossary.html#term-Network-Time-Protocol-NTP). We recommend that you configure the controller node to reference more accurate (lower stratum) servers and other nodes to reference the controller node.

- [Controller node](https://docs.openstack.org/install-guide/environment-ntp-controller.html)
- [Other nodes](https://docs.openstack.org/install-guide/environment-ntp-other.html)
- [Verify operation](https://docs.openstack.org/install-guide/environment-ntp-verify.html)

### OpenStack Packages

The set up of OpenStack packages described here needs to be done on all nodes: controller, compute, and Block Storage nodes.

**Disable or remove** any automatic update services because they can impact your OpenStack environment.

- [OpenStack packages for SUSE](https://docs.openstack.org/install-guide/environment-packages-obs.html)
    - [Enable the OpenStack repository](https://docs.openstack.org/install-guide/environment-packages-obs.html#enable-the-openstack-repository)
    - [Finalize the installation](https://docs.openstack.org/install-guide/environment-packages-obs.html#finalize-the-installation)
- [OpenStack packages for RHEL and CentOS](https://docs.openstack.org/install-guide/environment-packages-rdo.html)
    - [Prerequisites](https://docs.openstack.org/install-guide/environment-packages-rdo.html#prerequisites)
    - [Enable the OpenStack repository](https://docs.openstack.org/install-guide/environment-packages-rdo.html#enable-the-openstack-repository)
    - [Finalize the installation](https://docs.openstack.org/install-guide/environment-packages-rdo.html#finalize-the-installation)
- [OpenStack packages for Ubuntu](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html)
    - [Archive Enablement](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html#archive-enablement)
    - [Sample Installation](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html#sample-installation)
    - [Client Installation](https://docs.openstack.org/install-guide/environment-packages-ubuntu.html#client-installation)

### SQL Database

Most OpenStack services use an SQL database to store information. The database typically **runs on the controller node**. The procedures in this guide use MariaDB or MySQL depending on the distribution. OpenStack services also support other SQL databases including [PostgreSQL](https://www.postgresql.org/).

- [SQL database for SUSE](https://docs.openstack.org/install-guide/environment-sql-database-obs.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-sql-database-obs.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-sql-database-obs.html#finalize-installation)
- [SQL database for RHEL and CentOS](https://docs.openstack.org/install-guide/environment-sql-database-rdo.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-sql-database-rdo.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-sql-database-rdo.html#finalize-installation)
- [SQL database for Ubuntu](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-sql-database-ubuntu.html#finalize-installation)

### Message Queue

OpenStack uses a [message queue](https://docs.openstack.org/install-guide/common/glossary.html#term-message-queue) to coordinate operations and status information among services. The message queue service typically runs **on the controller node**. OpenStack supports several message queue services including [RabbitMQ](https://www.rabbitmq.com/), [Qpid](https://qpid.apache.org/), and [ZeroMQ](http://zeromq.org/). However, most distributions that package OpenStack support a particular message queue service. This guide implements the RabbitMQ message queue service because most distributions support it. If you prefer to implement a different message queue service, consult the documentation associated with it.

- [Message queue for SUSE](https://docs.openstack.org/install-guide/environment-messaging-obs.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-messaging-obs.html#install-and-configure-components)
- [Message queue for RHEL and CentOS](https://docs.openstack.org/install-guide/environment-messaging-rdo.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-messaging-rdo.html#install-and-configure-components)
- [Message queue for Ubuntu](https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-messaging-ubuntu.html#install-and-configure-components)

### Memcached

The Identity service authentication mechanism for services uses Memcached to cache tokens. The memcached service typically runs on the **controller** node. For production deployments, we recommend enabling a combination of **firewalling**, **authentication**, and **encryption** to secure it.

- [Memcached for SUSE](https://docs.openstack.org/install-guide/environment-memcached-obs.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-memcached-obs.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-memcached-obs.html#finalize-installation)
- [Memcached for RHEL and CentOS](https://docs.openstack.org/install-guide/environment-memcached-rdo.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-memcached-rdo.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-memcached-rdo.html#finalize-installation)
- [Memcached for Ubuntu](https://docs.openstack.org/install-guide/environment-memcached-ubuntu.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-memcached-ubuntu.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-memcached-ubuntu.html#finalize-installation)

### Etcd

OpenStack services may use Etcd, a distributed reliable key-value store for distributed key locking, storing configuration, keeping track of service live-ness and other scenarios.

- [Etcd for SUSE](https://docs.openstack.org/install-guide/environment-etcd-obs.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-etcd-obs.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-etcd-obs.html#finalize-installation)
- [Etcd for RHEL and CentOS](https://docs.openstack.org/install-guide/environment-etcd-rdo.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-etcd-rdo.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-etcd-rdo.html#finalize-installation)
- [Etcd for Ubuntu](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html)
    - [Install and configure components](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html#install-and-configure-components)
    - [Finalize installation](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html#finalize-installation)

## Install Openstack Services

- [Install OpenStack services — Installation Guide documentation](https://docs.openstack.org/install-guide/openstack-services.html)

## Reference

- [ubuntu20.04手动安装Openstack YOGA版本（双节点）_ubuntu server 20.04 yoga-CSDN博客](https://blog.csdn.net/qq_43626147/article/details/124369603)
