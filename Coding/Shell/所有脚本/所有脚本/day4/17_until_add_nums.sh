#!/bin/bash
# 功能: until语句场景实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
all_sum=0
odd_sum=0
ou_sum=0

# 定制全部求和
i=0
until ((i>100))
do
  let all_sum+=i
  let i++
done

# 定制奇数求和
i=1
until ((i>100))
do
  let odd_sum+=i
  let i+=2
done

# 定制偶数求和
i=2
until ((i>100))
do
  let ou_sum+=i
  let i+=2
done

# 统一信息显示
echo "1-100所有数据求和: ${all_sum}"
echo "1-100所有奇数求和: ${odd_sum}"
echo "1-100所有偶数求和: ${ou_sum}"
