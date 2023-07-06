#!/bin/bash
# 功能: cpu负载统计信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 负载信息获取
cpu_load=($(uptime | tr -s " " | cut -d " " -f9-11 | tr "," " "))

# 负载信息展示
echo -e "\e[31mCPU负载信息展示\e[0m"
echo "========================================"
echo -e "\e[32mCPU 1 min负载信息: \e[33m${cpu_load[0]}\e[0m"
echo -e "\e[32mCPU 5 min负载信息: \e[33m${cpu_load[1]}\e[0m"
echo -e "\e[32mCPU 15 min负载信息: \e[33m${cpu_load[2]}\e[0m"
echo "========================================"
