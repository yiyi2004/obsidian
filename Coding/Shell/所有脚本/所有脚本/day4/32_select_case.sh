#!/bin/bash
# 功能: select简单实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定普通变量
PS3='请输入系统的类型: '

# select 逻辑循环
select osname in "HMOS" "Linux" "Ubuntu" "Windows"
do
  # 嵌套case语句进行基本的控制
  case "${osname}" in
    "HMOS")
       echo "华为鸿蒙"
       break;;
    "Linux")
       echo "开源Linux";;
    "Ubuntu")
       echo "内核最新Ubuntu";;
    "Windows")
       echo "桌面主机";;
    *)
       echo "请选择合适的操作系统";; 
  esac
done
