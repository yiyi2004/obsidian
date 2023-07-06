#!/bin/bash
# 功能: if语句演示服务管理流程
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
cmd_arg=$1

# 脚本的执行
if [ $# -ne 1 ]
then
   echo -e "\e[31mUsage: /bin/bash $0 [ start|stop|restart ]\e[0m"
   exit
fi

# 逻辑的判断
if [ "${cmd_arg}" == "start" ]
then
  echo -e "\e[31m服务启动中...\e[0m"
elif [ "${cmd_arg}" == "stop" ]
then
  echo -e "\e[31m服务关闭中...\e[0m"
elif [ "${cmd_arg}" == "restart" ]
then
  echo -e "\e[31m服务重启中...\e[0m"
else
  echo -e "\e[31mUsage: /bin/bash $0 [ start|stop|restart ]\e[0m"
fi
