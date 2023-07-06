#!/bin/bash 
# 功能: 获取ip网卡的基本信息

# ip 地址显示
                       ifconfig eth0 | grep netma | tr -s " " | cut -d " " -f 3 | xargs -I {} echo "IP: " {}

# 掩码地址显示
    ifconfig eth0 | grep netma | tr -s " " | cut -d " " -f 5 | xargs -I {} echo "Netmask: " {}

# 广播地址显示
ifconfig eth0 | grep netma | tr -s " " | cut -d " " -f 7 | xargs -I {} echo "BroadCast: " {}

# 显示MAC地址
                                                 ifconfig eth0 | grep ether | tr -s " " | cut -d " " -f 3 | xargs -I {} echo "MAC Address: " {}
