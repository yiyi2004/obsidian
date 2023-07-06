#!/bin/bash
# 功能: 网络主机的存活性探测
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 获取脚本参数
host_addr=$1

# 脚本参数的判断
! test -v host_addr && echo "请输入脚本的ip参数" && exit
[ ! $# == 1 ] && echo "请输入脚本的ip参数" && exit

# 主机的存活性探测
host_status=$(ping -c1 -W1 ${host_addr} >> /dev/null 2>&1 && echo "正常" || echo "异常")

# 探测信息的输出
echo -e "\e[31m主机探测状态信息\e[0m"
echo "================================="
echo -e "\e[32m${host_addr}主机网络状态: \e[33m${host_status}\e[0m"
echo "================================="
