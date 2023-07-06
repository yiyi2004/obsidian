#!/bin/bash 
# 功能: 获取ip网卡的基本信息

# 定制普通变量
net_name="$1"

# ip 地址显示
ipaddr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 3)

# 掩码地址显示
netmast_addr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 5)

# 广播地址显示
broad_addr=$(ifconfig ${net_name} | grep netma | tr -s " " | cut -d " " -f 7)

# 显示MAC地址
mac_addr=$(ifconfig ${net_name} | grep ether | tr -s " " | cut -d " " -f 3)

# 显示最终的信息
echo -e "\e[32m----------------主机网卡基本信息---------------\e[0m"
echo -e "IP:  \e[31m${ipaddr}\e[0m"
echo -e "Netmask: \e[31m${netmast_addr}\e[0m"
echo -e "BroadCast: \e[31m${broad_addr}\e[0m"
echo -e "MAC Address: \e[31m${mac_addr}\e[0m"
echo -e "\e[32m-----------------------------------------------\e[0m"
