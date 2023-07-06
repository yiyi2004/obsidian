#!/bin/bash
# 功能: 代码仓库主机进行代码打包动作
# 版本: v0.2
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
code_dir='/data/codes'
code_name='django'
tar_file="${code_name}.tar.gz"

# 打包动作改造
cd ${code_dir}
[ -f ${tar_file} ] && rm -f ${tar_file}
tar zcf ${tar_file} ${code_name}/
