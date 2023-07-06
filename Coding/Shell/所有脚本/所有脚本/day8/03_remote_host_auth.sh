#!/bin/bash
# 功能: 批量设定远程主机免密码认证
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 准备工作
user_dir='/root'
login_user='root'
login_pass='123456'
target_type=(部署 免密 退出)

# 菜单
menu(){
  echo -e "\e[31m批量设定远程主机免密码认证管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 部署环境   2: 免密认证   3：退出操作 \e[0m"
  echo "====================================================="
}
# expect环境

# 秘钥文件生成环境

# expect自动匹配逻辑

# 跨主机传输文件认证

# 帮助信息逻辑
Usage(){
  echo "请输入有效的操作id"
}
# 逻辑入口
while true
do
  menu
  read -p "请输入有效的操作id: " target_id
  if [ ${#target_type[@]} -ge ${target_id} ]
  then
    if [ ${target_type[${target_id}-1]} == "部署" ]
    then
       echo "开始部署环境操作..."
    elif [ ${target_type[${target_id}-1]} == "免密" ]
    then
       echo "开始执行免密认证操作..."
    elif [ ${target_type[${target_id}-1]} == "退出" ]
    then
       echo "开始退出管理界面..."
       exit
    fi
  else
    Usage
  fi
done
