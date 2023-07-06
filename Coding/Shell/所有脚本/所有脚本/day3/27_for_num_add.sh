#!/bin/bash
# 功能: for赋值循环实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
all_sum=0
odd_sum=0
ou_sum=0
# 定制所有数据的求和逻辑
for i in {1..100}
do
   let all_sum+=i
done

# 定制所有奇数数据的求和逻辑
for i in {1..100..2}
do
   let odd_sum+=i
done

# 定制所有偶数数据的求和逻辑
for i in {0..100..2}
do
   let ou_sum+=i
done
# 相关信息的输出
echo "所有数据的求和: ${all_sum}"
echo "所有奇数数据的求和: ${odd_sum}"
echo "所有偶数数据的求和: ${ou_sum}"
