#!/bin/bash
# 功能: 函数内全局变量的实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 定制普通变量(任务级别的全局变量)
message='helloworld'

# 定制函数 
Usage(){
  echo "直接调用脚本内的变量: ${message}"
  # 函数内修改外部的全局变量
  message="function-helloworld"
  echo "函数内变量修改后的内容: ${message}"
}
# 定制业务逻辑
while true
do
   read -p "请输入查看变量的内容 【1-函数内 2-脚本内】" location
   if [ "${location}" == "1" ] 
   then
     Usage
   elif  [ "${location}" == "2" ]
   then
     echo ${message}
   fi
done
