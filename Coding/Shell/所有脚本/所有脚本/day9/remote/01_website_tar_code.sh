#!/bin/bash
# 功能: 代码仓库主机进行代码打包动作
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 打包动作
cd /data/codes
[ -f django.tar.gz ] && rm -f django.tar.gz
tar zcf django.tar.gz django/
