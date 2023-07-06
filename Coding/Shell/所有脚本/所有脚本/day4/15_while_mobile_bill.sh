#!/bin/bash
# 功能: while语句手机发送短信实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
read -p "请输入您的收集余额(元): " mobile_bill
sms_num=0  # 发送短信的数量
mobile_count=$[${mobile_bill}*10]  # 手机话费的余额

# while嵌套if逻辑
while [ ${mobile_count} -ge 0 ]
do
   # 短信发送
   sms_num=$[${sms_num}+1]
   # 短信判断
   if [ ${mobile_count} -lt 1 ]
   then
      echo "手机余额不足，无法发送短信，请充值!!!"
   else
      echo "您已经发送 ${sms_num} 条短信。"
   fi
   # 手机话费调整
   mobile_count=$[${mobile_count}-1]
done
