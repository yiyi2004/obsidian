#!/bin/bash
# 功能: 模拟登录界面
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取基本信息
version=$(cat /etc/redhat-release)
kernel_info=$(uname -r)
arch_info=$(uname -m)

# 登录界面
echo -e "\e[31m${version}\e[0m"
echo -e "\e[31mKernel ${kernel_info} on ${arch_info}\e[0m"
echo "--------------------------------------"
read -p "请输入用户名: " account
read -s -t 30 -p "请输入密  码: " passwd
echo
echo "--------------------------------------"

printf "您输入的用户名: \e[32m%s\e[0m, 您输入的密码: \e[32m%s\e[0m\n" ${account} ${passwd}
