#!/bin/bash
# 功能: select简单实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 基本信息
echo "请选择要安装的操作系统: "
select osname in "Linux" "MacOS" "Ubuntu" "Windows"
do
   echo "我选择的操作系统是: ${osname}"
done
