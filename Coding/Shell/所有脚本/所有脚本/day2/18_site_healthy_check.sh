#!/bin/bash
# 功能: 检测网站的站点可访问情况
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定普通变量
site_addr=$1

# 检测平台信息展示
echo -e "\e[31m\t站点检测平台管理界面\e[0m"
echo "====================================================="
echo -e "\e[32m 1: wget\n 2: curl\e[0m"
echo "====================================================="
# 站点检测方法
read -p "请输入站点检测的方法类型标识【1 或者 2】: " input_type
[ ${input_type} == "1" ] && site_status=$(wget --spider -T2 -t2 -q ${site_addr} && echo "正常" || echo "异常")
[ ${input_type} == "2" ] && site_status=$(curl -s -o /dev/null ${site_addr} && echo "正常" || echo "异常")

# 站点检测信息
echo "${site_addr} 站点状态是: ${site_status}"
