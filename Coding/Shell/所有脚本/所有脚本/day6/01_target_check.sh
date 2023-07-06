#!/bin/bash
# 功能: 目标检测平台
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 普通变量的定制
target_type=(主机 网站)
# 菜单显示函数
menu(){
  echo -e "\e[31m\t站点检测平台管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 主机\n 2: 网址\e[0m"
  echo "====================================================="
}
# 检测ip格式
ip_check(){
   ip=$1
   regex_rule='(^([1-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.)((0|[1-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){2}((0|[1-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))'
   echo $ip | egrep "${regex_rule}" >/dev/null 2>&1 && echo "true" || echo "false"
}
# 检测site格式
site_check(){
  site=$1
  regex_rule='((http|https|ftp):\/\/)?(www)?([0-9a-zA-Z]+\.)([a-zA-Z]{2,5})$'
  echo ${site} | egrep "${regex_rule}"  >/dev/null 2>&1 && echo "true" || echo "false"
}
# ip地址检测逻辑
host_check_func(){
  # 接收用户输入
  read -p "请输入要检测的主机ip地址: " host_ip
  # 数据格式检测
  echo "ip地址检测"
  check_status=$(ip_check ${host_ip})
  # 检测信息输出
  if [ "${check_status}" == "true" ]
  then
    ping -c1 -W1 ${host_ip} >/dev/null 2>&1 && echo "${host_ip} 状态正常" || echo "${host_ip} 状态异常"
  else
    echo "ip地址格式异常，请重新输入"
  fi
}

# site地址检测逻辑
site_check_func(){
  # 接收用户输入
  read -p "请输入要检测的网站站点地址: " host_site
  # 数据格式检测
  echo "站点地址检测"
  check_status=$(site_check ${host_site})
  # 检测信息输出
  if [ "${check_status}" == "true" ]
  then
    wget --spider -t2 -T2 -q  ${host_site}  && echo "${host_site} 状态正常" || echo "${host_site} 状态异常"
  else
    echo "网站地址格式异常，请重新输入"
  fi
}
# 脚本帮助信息
Usage(){
  echo -e "\e[31m请输入站点检测的方法类型标识\e[0m"
}
# 主逻辑调用
while true
do
  menu
  read -p "请输入待检测目标的类型(q-退出): " target_id
  if [ "${target_id}" == "q" ] 
  then
     exit
  elif [ "${target_type[${target_id}-1]}" == "主机" ]
  then
     host_check_func    
  elif [ "${target_type[${target_id}-1]}" == "网站" ]
  then 
     site_check_func
  else
     Usage
  fi
done
