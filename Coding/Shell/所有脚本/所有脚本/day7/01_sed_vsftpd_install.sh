#!/bin/bash
# 功能: vsftpd环境部署实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定基础环境变量
target_type=(部署 下载 操作)

# 设定目录内容函数
menu(){
  echo -e "\e[31m\tvsftpd软件管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 部署   2: 下载测试   3：操作测试 \e[0m"
  echo "====================================================="
}

# 设定主机名准备工作

# 设定软件安装函数

# 设定下载测试函数

# 设定操作测试函数

# 设定主逻辑函数

# 设定帮助函数
Usage(){
   echo "请输入正确的操作步骤标识"
}
# 设定脚本入口逻辑
while true
do 
  menu
  read -p "请输入待操作的步骤标识(q-退出): " target_id
  if [ "${target_id}" == "q" ]
  then
     echo "退出vsftpd操作"
     exit
  elif [ "${target_type[${target_id}-1]}" == "部署" ]
  then
     echo "vsftpd软件部署"
  elif [ "${target_type[${target_id}-1]}" == "下载" ]
  then
     echo "vsftpd环境下载测试"
  elif [ "${target_type[${target_id}-1]}" == "操作" ]
  then
     echo "vsftpd环境操作测试"
  else
     Usage
  fi
done
