#!/bin/bash
# 功能: 生产环境项目代码的发布脚本
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取代码
get_code(){
  echo -e "\e[31m获取代码\e[0m"
}
# 打包代码
tar_code(){
  echo -e "\e[31m打包代码\e[0m"
}
# 传输代码
scp_code(){
  echo -e "\e[31m传输代码\e[0m"
}
# 关闭应用
stop_serv(){
  echo -e "\e[31m关闭相关的应用环境\e[0m"
  echo -e "\e[32m调整Nginx应用环境\e[0m"
  echo -e "\e[32m调整Django应用环境\e[0m"
}
# 解压代码
untar_code(){
  echo -e "\e[31m解压代码\e[0m"
}
# 放置代码
put_code(){
  echo -e "\e[31m放置代码\e[0m"
  echo -e "\e[32m备份老文件\e[0m"
  echo -e "\e[32m放置新代码\e[0m"
}
# 开启应用
start_serv(){
  echo -e "\e[31m开启相关的应用环境\e[0m"
  echo -e "\e[32m调整Nginx应用环境\e[0m"
  echo -e "\e[32m调整Django应用环境\e[0m"
}
# 内部检测
site_check(){
  echo -e "\e[31m代码发布完成，内部检测\e[0m"
}
# 总部署函数
site_deploy(){
  get_code 
  tar_code
  scp_code
  stop_serv
  untar_code
  put_code
  start_serv
  site_check
}
# 主函数
main(){
  site_deploy
}
# 调用主函数
main

