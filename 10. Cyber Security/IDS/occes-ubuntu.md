# Server
- ubuntu16.04
```shell
apt-get install build-essential make zlib1g-dev libpcre2-dev -y
sudo apt-get install libmysqld-dev postgresql -y 
sudo apt-get install libevent-dev libssl-dev  -y 
apt install -y libsystemd-dev
mkdir source && cd source
wget https://github.com/ossec/ossec-hids/archive/refs/tags/3.7.0.tar.gz
tar xvzf 3.7.0.tar.gz 
cd ossec-hids-3.7.0/

sudo ./install.sh
```

```shell
sudo apt-get update && sudo apt-get dist-upgrade
```

- 换源问题
```shell
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
```


- 安装输出

```shell
 - System is Debian (Ubuntu or derivative).
 - Init script modified to start OSSEC HIDS during boot.

 - Configuration finished properly.

 - To start OSSEC HIDS:
      /var/ossec/bin/ossec-control start

 - To stop OSSEC HIDS:
      /var/ossec/bin/ossec-control stop

 - The configuration can be viewed or modified at /var/ossec/etc/ossec.conf

    Thanks for using the OSSEC HIDS.
    If you have any question, suggestion or if you find any bug,
    contact us at https://github.com/ossec/ossec-hids or using
    our public maillist at  
    https://groups.google.com/forum/#!forum/ossec-list

    More information can be found at http://www.ossec.net

    ---  Press ENTER to finish (maybe more information below). ---

 - In order to connect agent and server, you need to add each agent to the server.
   Run the 'manage_agents' to add or remove them:

   /var/ossec/bin/manage_agents

   More information at: 
   http://www.ossec.net/docs/docs/programs/manage_agents.html


```

- agent 的安装和 server 类似
- agent 输出
```shell
 - System is Debian (Ubuntu or derivative).
 - Init script modified to start OSSEC HIDS during boot.

 - Configuration finished properly.

 - To start OSSEC HIDS:
      /var/ossec/bin/ossec-control start

 - To stop OSSEC HIDS:
      /var/ossec/bin/ossec-control stop

 - The configuration can be viewed or modified at /var/ossec/etc/ossec.conf
    Thanks for using the OSSEC HIDS.
    If you have any question, suggestion or if you find any bug,
    contact us at https://github.com/ossec/ossec-hids or using
    our public maillist at  
    https://groups.google.com/forum/#!forum/ossec-list

    More information can be found at http://www.ossec.net

    ---  Press ENTER to finish (maybe more information below). ---


 - You first need to add this agent to the server so they 
   can communicate with each other. When you have done so,
   you can run the 'manage_agents' tool to import the 
   authentication key from the server.
   
   /var/ossec/bin/manage_agents

   More information at: 
   http://www.ossec.net/docs/docs/programs/manage_agents.html
```

# Agent
These options should be specified locally in each agent’s **ossec.conf** file or the share agent.conf. Inside the `<localfile>` element, you can have the following options.
- [Log monitoring/analysis — OSSEC](https://www.ossec.net/docs/docs/manual/monitoring/index.html)

## Process Monitoring
- /var/ossec/etc/ossec.conf
- /var/ossec/rules/local_rules.xml
- [Process Monitoring — OSSEC](https://www.ossec.net/docs/docs/manual/monitoring/process-monitoring.html)

## File Monitoring
OSSEC has a process named `ossec-logcollector` that monitors the configured log files for new events. When new log messages arrive, it forwards them to other processes for analysis or transport to an OSSEC server.

The configuration for ossec-logcollector exists in `/var/ossec/etc/ossec.conf` in the `<ossec_config>` section. The syntax can be found in the [localfile syntax page](https://www.ossec.net/docs/docs/syntax/head_ossec_config.localfile.html)


# 安装问题
- [Makefile:930: recipe for target 'ossec-maild' failed](https://github.com/ossec/ossec-hids/issues/2039)

```shell
apt install -y libsystemd-dev
```

- No agent available.

# Reference
- [(142条消息) Ubuntu16.04安装OSSEC详细步骤_zhang35的博客-CSDN博客_ubuntu ossec配置](https://blog.csdn.net/zhang35/article/details/105467435?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166659275716782428695271%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166659275716782428695271&biz_id=0&spm=1018.2226.3001.4187)
- [全网最详细的最新稳定OSSEC搭建部署（ossec-server（CentOS6.X / 7.X）和ossec-agent（Windows7 / 8 / 10）)（图文详解） - 大数据和AI躺过的坑 - 博客园 (cnblogs.com)](https://www.cnblogs.com/zlslch/p/8512858.html)——上面那个 web ui 是有问题的
