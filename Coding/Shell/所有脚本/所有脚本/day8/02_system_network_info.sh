#!/bin/bash
# 功能: 统计服务器网络连接状态的信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取相关的数据
tcp_total=$(ss -s | awk '$1=="TCP" {print $2}')
udp_total=$(ss -s | awk '$1=="UDP" {print $2}')
listen_total=$(ss -antlpH | awk 'BEGIN{count=0} {count++} END{print count}')
estab_total=$(ss -ant | awk 'BEGIN{count=0} /^ESTAB/ {count++} END{print count}')
time_wait_total=$(ss -ant | awk 'BEGIN{count=0} /^TIME-WAIT/ {count++} END{print count}')

# 格式化展示
echo -e "\e[31m服务器网络连接状态信息统计"
echo -e "--------------------------------\e[0m"
echo "tcp连接总数: " ${tcp_total}
echo "udp连接总数: " ${udp_total}
echo "listen监听总数: " ${listen_total}
echo "连接状态总数: " ${estab_total}
echo "time_wait连接总数: " ${time_wait_total}
