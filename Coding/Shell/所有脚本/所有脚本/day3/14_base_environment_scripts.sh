#!/bin/bash
# 功能: 环境标准化脚本管理平台
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制基本属性
env_type=(os web sql storage other)

# 定制信息显示
echo -e "\e[31m        欢迎使用脚本管理平台
-----------请选择功能场景-----------
 1: 系统环境下脚本
 2: web环境下脚本
 3: 数据库环境下脚本
 4: 存储环境下脚本
 5: 其他环境下脚本
----------------------------------\e[0m"

# 定制内容匹配逻辑
read -p "请输入环境的标识: " env_id

# case进行逻辑匹配
case  ${env_type[${env_id}-1]} in
  "os")
      echo -e "\e[32m系统环境下脚本文件有: \e[0m"
      ls os;;
  "web")
      echo -e "\e[32mWEB环境下脚本文件有: \e[0m"
      ls web;;
  "sql")
      echo -e "\e[32m数据库环境下脚本文件有: \e[0m"
      ls sql;;
  "storage")
      echo -e "\e[32m存储环境下脚本文件有: \e[0m"
      ls storage;;
  "other")
      echo -e "\e[32m其他环境下脚本文件有: \e[0m"
      ls other;;
  *)
      echo -e "\e[32m请输入有效环境的标识\e[0m";;
esac
