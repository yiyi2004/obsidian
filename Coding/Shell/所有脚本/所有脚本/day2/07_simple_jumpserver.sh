#!/bin/bash
# 功能: 堡垒机的入口界面
# 版本: v0.2
# 作者: 书记
# 联系: superopsmsb.com

# 显示终端界面信息
echo -e "\033[31m \t 欢迎使用堡垒机\033[0m"
echo -e "\033[32m
--------------请选择您要登录的主机----------------
1: 10.0.0.12 (nginx)
2: 10.0.0.13 (apache)
3: 10.0.0.14 (tomcat)
4: 10.0.0.15 (jenkins)
5: localhost
\e[0m"

read -p "请输入您要登录的主机编号: " host_index
echo "您选择的主机编号: ${host_index}, 即将连接的主机是: $(hostname)"

read -p "请输入您的登录用户: " account
ssh ${account}@localhost
