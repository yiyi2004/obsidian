#!/bin/bash
# 功能: 统计内存使用率信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
tmp_file='/tmp/mem.txt'

# 设定内存的基本信息
free -m > /tmp/mem.txt 2>&1
mem_total=$(grep Mem /tmp/mem.txt | tr -s " " | cut -d " " -f2)
mem_used=$(grep Mem /tmp/mem.txt | tr -s " " | cut -d " " -f3)
mem_free=$(grep Mem /tmp/mem.txt | tr -s " " | cut -d " " -f4)

# 统计内存的使用率
percentage_used=$(echo "scale=2; ${mem_used} / ${mem_total} * 100" | bc)
percentage_free=$(echo "scale=2; ${mem_free} / ${mem_total} * 100" | bc)

# 信息的显示
echo -e "\e[31m\t $(hostname) 内存使用信息统计\e[0m"
echo "----------------------------------------"
echo -e "\e[32m内存总量: ${mem_total}
内存使用量: ${mem_used}
内存空闲量: ${mem_free}
内存使用占比: ${percentage_used}
内存空闲占比: ${percentage_free}\e[0m"
echo "----------------------------------------"
