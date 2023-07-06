#!/bin/bash
# 功能: 系统负载统计信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 负载信息获取
# cpu_load=($(uptime | tr -s " " | cut -d " " -f9-11 | tr "," " "))

# 负载信息展示
# echo -e "\e[31mCPU负载信息展示\e[0m"
# echo "========================================"
# echo -e "\e[32mCPU 1 min负载信息: \e[33m${cpu_load[0]}\e[0m"
# echo -e "\e[32mCPU 5 min负载信息: \e[33m${cpu_load[1]}\e[0m"
# echo -e "\e[32mCPU 15 min负载信息: \e[33m${cpu_load[2]}\e[0m"
# echo "========================================"

# 普通属性的数组
resource_type=(CPU MEM)
cpu_attr=(1 5 15)
mem_attr=(total used free)

# 属性数据的数组
cpu_load=($(uptime | tr -s " " | cut -d " " -f9-11 | tr "," " "))
mem_load=($(free -m | grep Mem | tr -s " " | cut -d " " -f2-4))

# 资源类型选择显示
echo -e "\e[31m系统负载信息选择\e[0m"
echo "========================================"
echo "1: CPU  2: MEM"
echo "========================================"
read -p "请输入有效的系统负载信息类型id: " resource_id

# 信息显示的逻辑判断
if [ ${#resource_type[@]} -ge ${resource_id} ]
then
   # cpu负载信息
   if [ ${resource_type[${resource_id}-1]} == "CPU" ]
   then
      echo -e "\e[31mCPU负载信息显示\e[0m"
      echo "========================================"
      for index in ${!cpu_attr[@]}
      do
         echo -e "\e[32mCPU ${cpu_attr[$index]} min负载信息: \e[33m${cpu_load[$index]}\e[0m"
      done
      echo "========================================"
   fi
   # mem负载信息
   if [ ${resource_type[${resource_id}-1]} == "MEM" ]
   then
      echo -e "\e[31mMEM负载信息显示\e[0m"
      echo "========================================"
      for index in ${!mem_attr[@]}
      do
         echo -e "\e[32mMEM ${mem_attr[$index]} 总量使用信息: \e[33m${mem_load[$index]}\e[0m"
      done
      echo "========================================"
   fi
else
   echo -e "\e[31m请输入有效的系统负载信息类型id\e[0m"
fi
