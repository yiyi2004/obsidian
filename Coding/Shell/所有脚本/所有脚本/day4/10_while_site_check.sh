#!/bin/bash
# 功能: while语句检测站点实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
read -p "请输入一个站点地址: " site_name

# 定制while逻辑
while true
do
   wget -T2 -q -t2 ${site_name} && echo "${site_name} 站点状态正常" ||  echo "${site_name} 站点状态异常"
   sleep 5
done
