#!/bin/bash
# 功能: shell整合expect实践-自动分区格式化
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定普通变量
mount_dir='/check_dir'
[ -d ${mount_dir} ] && rm -rf ${mount_dir} 
mkdir ${mount_dir} 

# 待格式化分区磁盘列表
fdisk -l | grep '磁盘 /dev'
read -p "请输入您要分区的磁盘名称(示例: /dev/sda): " disk_name
# 自动化分区
[ -f /usr/bin/expect ] && echo "expect环境正常" || (echo "expect环境异常" && exit)
/usr/bin/expect <<-EOF
set timeout 30
spawn bash -c "fdisk ${disk_name}"
expect "命令*" {send "n\r"}
expect "Select*" {send "p\r"}
expect "分区号*" {send "\r"}
expect "起始 扇区*" {send "\r"}
expect "Last 扇区*" {send "\r"}
expect "命令*" {send "wq\r"}
expect eof
interact
EOF
# 自动化格式
read -p "请输入您要格式化类型(示例: ext4): " disk_type
/usr/bin/expect <<-EOF
set timeout 30
spawn bash -c "mkfs -t ${disk_type} ${disk_name}"
expect "*y,n*" {send "y\r"}
expect eof
interact
EOF

# 磁盘测试
mount ${disk_name} ${mount_dir}
echo "mashibing" > ${mount_dir}/nihao.txt
[ -f ${mount_dir}/nihao.txt ] && echo "磁盘挂载成功" || (echo "磁盘挂载失败" && exit)
umount ${disk_name}
[ ! -f ${mount_dir}/nihao.txt ] && echo "磁盘卸载成功" || (echo "磁盘卸载失败" && exit)
rm -rf ${mount_dir}
