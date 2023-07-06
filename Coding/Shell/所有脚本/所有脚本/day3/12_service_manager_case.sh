#!/bin/bash
# 功能: case语句演示服务管理流程
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
cmd_arg=$1

# 定制case的服务逻辑
case "${cmd_arg}" in
  "start")
       echo -e "\e[31m服务启动中...\e[0m";;
  "stop")
        echo -e "\e[31m服务关闭中...\e[0m";;
  "restart")
       echo -e "\e[31m服务重启中...\e[0m";;
  *)
       echo -e "\e[31mUsage: /bin/bash $0 [ start|stop|restart ]\e[0m";;
esac
