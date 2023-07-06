#!/bin/bash
# 功能: if嵌套for获取系统支持的shell类型
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
shell_file='/etc/shells'

# 定制基本逻辑
if [ -f ${shell_file} ] 
then
  # 系统支持的shell类型
  for sh_type in  $(grep sh ${shell_file})
  do
    echo "当前系统支持的shell类型有: ${sh_type}"
  done
else
   echo "没有 ${shell_file} 这个文件，请确认一下"
fi
