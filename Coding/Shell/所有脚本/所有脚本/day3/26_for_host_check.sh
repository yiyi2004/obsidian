#!/bin/bash
# 功能: for批量检测主机存活
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 创建普通信息
host_file='/tmp/host.txt'
host_net='10.0.0'
[ -f $host_file ] && > $host_file

# 主机检测的for逻辑
for i in {1..20}
do
  # 检测主机存活
  host_status=$(ping -c1 -W1 ${host_net}.$i >/dev/null 2>&1 && echo "UP" || echo "DOWN")
  # 主机检测信息输出
  echo "主机ip: ${host_net}.$i ${host_status}" >> $host_file
done

# 网段主机的存活统计
host_up_num=$(grep UP $host_file | wc -l)
host_down_num=$(grep DOWN $host_file | wc -l)
echo -e "\e[31m${host_net}.0 网段主机存活情况\e[0m"
echo "------------------------------------"
echo -e "\e[32m${host_net}.0 网段存活主机数量: ${host_up_num}\e[0m"
echo -e "\e[32m${host_net}.0 网段异常主机数量: ${host_down_num}\e[0m"
