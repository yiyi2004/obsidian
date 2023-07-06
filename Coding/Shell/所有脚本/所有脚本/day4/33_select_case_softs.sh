#!/bin/bash
# 功能: select简单实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定普通变量
PS3='请输入系统的类型: '
soft_array=(Nginx Apache Tomcat)

# select 逻辑循环
select webname in ${soft_array[@]}
do
  # 嵌套case语句进行基本的控制
  case "${webname}" in
    "Nginx")
       echo "安装nginx软件"
       break;;
    "Apache")
       echo "安装Apache软件"
       break;;
    "Tomcat")
       echo "安装Tomcat软件"
       break;;
    *)
       echo "请选择合适的web软件";; 
  esac
done
