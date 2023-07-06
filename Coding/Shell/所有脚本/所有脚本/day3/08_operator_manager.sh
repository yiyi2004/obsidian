#!/bin/bash
# 功能: 运维故障处理界面
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制类型数组
monitor_type=(研发 测试 运维)
error_type=(红灯 黄灯 绿灯 灰灯)

# 定制信息类型界面
echo -e "\e[31m\t欢迎使用监控平台
-------------------------------------------
1：研发  2：测试  3：运维
-------------------------------------------\e[0m"

# 定制类型信息逻辑
read -p "请选择问题类型: " monitor_id
if [ ${#monitor_type[@]} -lt ${monitor_id} ]
then
   echo -e "\e[32m请输入有效的问题类型id\e[0m"
else
   # 正常的问题类型判断
   if [ ${monitor_type[${monitor_id}-1]} == "研发" ]
   then
      echo -e "\e[32m这是研发问题，传递给研发团队\e[0m"
   elif [ ${monitor_type[${monitor_id}-1]} == "测试" ]
   then
      echo -e "\e[32m这是测试问题，传递给测试团队\e[0m"
   elif  [ ${monitor_type[${monitor_id}-1]} == "运维" ]
   then
      # 运维自己处理问题
      # 定制信息类型界面
      echo -e "\e[31m\t欢迎使用监控平台\e[0m"
      echo -e "\e[31m-------------------------------------------\e[0m"
      echo -e "\e[31m1：红灯  2：黄灯  3：绿灯  4：灰灯\e[0m"
      echo -e "\e[31m-------------------------------------------\e[0m"
      read -p "请选择问题故障级别: " error_id
      # 问题级别的处理逻辑
      if [ ${#error_type[@]} -lt ${error_id} ]
      then
         echo -e "\e[32m请输入有效的问题故障级别id\e[0m"
      else
         if [ ${error_type[${error_id}-1]} == "红灯" ]
         then
            echo -e "\e[32m这是 紧急故障问题\e[0m"
         elif [ ${error_type[${error_id}-1]} == "黄灯" ]
         then
            echo -e "\e[32m这是 严重故障问题\e[0m"
         elif [ ${error_type[${error_id}-1]} == "绿灯" ]
         then
            echo -e "\e[32m这是 一般故障问题\e[0m"
         elif [ ${error_type[${error_id}-1]} == "灰灯" ]
         then
            echo -e "\e[32m这是 未知故障问题，后续操作处理\e[0m"
         fi
      fi
   fi
fi
