#!/bin/bash
# 功能: 系统服务的操作信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 数组元素的获取
service_array=(启动 关闭 重启 重载 状态)
declare -A service_oper
service_oper=([启动]=start [关闭]=stop [重启]=restart [重载]=reload [状态]=status)

# 数组操作的定制
echo -e "\e[31m===========服务的操作动作显示界面===========
 1: 启动  2: 关闭  3: 重启  4: 重载  5: 状态
============================================\e[0m"


# 操作信息的展示
read -p "请输入服务操作的动作: " target_type
echo "您即将执行服务的 ${service_array[${target_type}-1]}"

echo -e "===========服务执行动作==========="
echo "您即将对服务执行如下命令:"
echo -e "\t\e[32msystemctl \e[33m${service_oper[${service_array[${target_type}-1]}]} \e[32mservice_name\e[0m"
echo -e "=================================="
