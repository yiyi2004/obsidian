#!/bin/bash 
# 功能: 获取ip网卡的基本信息

# 定制普通变量
net_name='eth1'

# ip 地址显示
ipaddr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 3)

# 掩码地址显示
netmast_addr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 5)

# 广播地址显示
broad_addr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 7)

# 显示MAC地址
mac_addr=$(ifconfig ${net_name} | grep ether | tr -s " " | cut -d " " -f 3)

# 显示最终的信息
echo "IP: ${ipaddr}"
echo "Netmask: ${netmast_addr}"
echo "BroadCast: ${broad_addr}"
echo "MAC Address: ${mac_addr}"
