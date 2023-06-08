## Shell 基本操作

- 但是你在写这块还存在很大的问题

```shell
#!/bin/bash
echo "Hello World !"
```

```shell
chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本z
```

### 变量

- 使用变量

```shell
for file in $(ls /etc)
```

```shell
your_name="qinjx"  
echo $your_name  
echo ${your_name}
```

```shell
for skill in Ada Coffe Action Java; do  
    echo "I am good at ${skill}Script"  
done
```

- for 分号 do done 需要注意 (但是语句后面没有分号)
- 只读变量

```shell
#!/bin/bash  
myUrl="https://www.google.com"  
readonly myUrl  
myUrl="https://www.runoob.com"
```

- 会出现以下结果

```shell
/bin/sh: NAME: This variable is read only.
```

- 删除变量

```shell
unset variable_name
```

- 变量类型
	- 局部变量
	- 环境变量：环境变量的含义
	- shell 变量：shell 可以定义局部变量和环境变量
- 字符串

```shell
str='this is a string'

your_name="runoob"  
str="Hello, I know you are \"$your_name\"! \n"  
echo -e $str

# Hello, I know you are "runoob"!


your_name="runoob"  
# 使用双引号拼接  
greeting="hello, "$your_name" !"  
greeting_1="hello, ${your_name} !"  
echo $greeting  $greeting_1  
  
# 使用单引号拼接  
greeting_2='hello, '$your_name' !'  
greeting_3='hello, ${your_name} !'  
echo $greeting_2  $greeting_3

string="abcd"  
echo ${#string}   # 输出 4

string="abcd"  
echo ${#string[0]}   # 输出 4

string="runoob is a great site"  
echo ${string:1:4} # 输出 unoo

string="runoob is a great site"  
echo `expr index "$string" io`  # 输出 4
```

- shell 数组

```shell
array_name=(value0 value1 value2 value3)

array_name=(
	value0
	value1
	value2
	value3
)

array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen

valuen=${array_name[n]}

# 使用 @ 符号可以获取数组中的所有元素，例如：
echo ${array_name[@]}

# 取得数组元素的个数  
length=${#array_name[@]}  
# 或者  
length=${#array_name[*]}  
# 取得数组单个元素的长度  
lengthn=${#array_name[n]}

#--------------------------------------------  
# 这是一个注释  
# author：菜鸟教程  
# site：www.runoob.com  
# slogan：学的不仅是技术，更是梦想！  
#--------------------------------------------  
##### 用户配置区 开始 #####  
#  
#  
# 这里可以添加脚本描述信息  
#  
#  
##### 用户配置区 结束  #####


:<<EOF  
注释内容...  
注释内容...  
注释内容...  
EOF
```

- EOF 也可以使用其他符号:
- 系统变量

```shell
# Shell常见的变量之一系统变量，主要是用于对参数判断和命令返回值判断时使用，系统变量详解如下：

$0 		当前脚本的名称；
$n 		当前脚本的第n个参数,n=1,2,…9；
$* 		当前脚本的所有参数(不包括程序本身)；
$# 		当前脚本的参数个数(不包括程序本身)；
$? 		令或程序执行完后的状态，返回0表示执行成功；
$$ 		程序本身的PID号。
```

- 环境变量

```shell
#Shell常见的变量之二环境变量，主要是在程序运行时需要设置，环境变量详解如下：

PATH  		命令所示路径，以冒号为分割；
HOME  		打印用户家目录；
SHELL 		显示当前Shell类型；
USER  		打印当前用户名；
ID    		打印当前用户id信息；
PWD   		显示当前所在路径；
TERM  		打印当前终端类型；
HOSTNAME    显示当前主机名；
PS1         定义主机命令提示符的；
HISTSIZE    历史命令大小，可通过 HISTTIMEFORMAT 变量设置命令执行时间;
RANDOM      随机生成一个 0 至 32767 的整数;
HOSTNAME    主机名

```

- 赋予执行权限 chmod o+x shell.sh
- example —— echo -e 扩展

```shell
#!/bin/bash
# This is echo color shell
# by author rivers 2021.09-23
# 字体颜色
for i in {31..37}; do
echo -e "\033[$i;40mHello world!\033[0m"
done
# 背景颜色
for i in {41..47}; do
echo -e "\033[47;${i}mHello world!\033[0m"
done
# 显示方式
for i in {1..8}; do
echo -e "\033[$i;31;40mHello world!\033[0m"
done


```

- [这是怎么做到的呢？](https://blog.csdn.net/qq_39843374/article/details/103178487?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166685352616782388057252%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166685352616782388057252&biz_id=0&spm=1018.2226.3001.4187)
	- -e：激活 [转义](https://so.csdn.net/so/search?q=%E8%BD%AC%E4%B9%89&spm=1001.2101.3001.7020) 字符。使用 -e 选项时，若字符串中出现以下字符，则特别加以处理，而不会将它当成一般文字输出：

### 逻辑控制

```shell
# If条件判断语句，通常以if开头，fi结尾。也可加入else或者elif进行多条件的判断

# 单分支语句 ---比较大小
	if (条件表达式);then
		语句1
	fi

# 双分支if 语句
	if (表达式)
		语句1
	else
		语句2
	fi

# 多支条件语句 ---判断成绩
	if (表达式)
		语句1
	elif
		语句2
	elif
		语句2
	fi  
```

- 常见的逻辑判断运算符

```shell
-f	 	判断文件是否存在 eg: if [ -f filename ]；
-d	 	判断目录是否存在 eg: if [ -d dir     ]；
-eq		等于，应用于整型比较 equal；
-ne		不等于，应用于整型比较 not equal；
-lt		小于，应用于整型比较 letter；
-gt		大于，应用于整型比较 greater；
-le		小于或等于，应用于整型比较；
-ge 	大于或等于，应用于整型比较；
-a		双方都成立（and） 逻辑表达式 –a 逻辑表达式；
-o		单方成立（or） 逻辑表达式 –o 逻辑表达式；
-z		空字符串；
-x      是否具有可执行权限
||      单方成立；
&&      双方都成立表达式。
```

- 判断 crond 服务是否运行

```shell
#!/bin/bash
# this is check crond
# by author rivers on 2021-9.23

# 定义一个变量名
name=crond
num=$(ps -ef|grep $name|grep -vc grep)
if [ $num -eq 1 ];then
    echo "$num running!"
else
    echo "$num is not running!"
fi
```

## Shell 操作

### 变量

- windows .bat
- linux .sh

```shell
#! /bin/bash
```

- 自动化部署
- history 保存历史命令

```shell
vim !/.bash_history
echo $HISFILE # 存放历史命令

-c # 清空历史
-r # 恢复历史

history -c
cat ~/.bash_history

history -r

# ! + 历史 id，快速执行历史命令
# !! 执行上一次的命令，忘了 sudo，加 sudo，这里的 !! 代表上一条命令
```

- ctrl + rl 快速清屏

![[Snipaste/Pasted image 20221027100834.png]]

- 不要写空格，区别于其他编程语言，因为 ls -la 会报错，识别成参数等等。
- 默认所有类型都是字符串
- pstree，shell 父进程
- 单引号不识别特殊语法
- 双引号识别特殊语法
- 父子 shell 的理念
- 切换 shell 变量会丢失
- 环境变量的概念

```shell
ench $? # 表示上一条命令是否执行成功。0 成功，1 ~ 255 出错
```

#### 父子 Shell 面试题

![[Snipaste/Pasted image 20221027151634.png]]

- 反引号中的 linux 命令执行的结果会被保存下来

```shell
name=`ls`
echo $name
```

#### 环境变量

- 用于定义 shell 的运行环境

![[Snipaste/Pasted image 20221027152245.png]]

- /etc/profile
- /etc/bashrc
- 系统建议最好创建在 /etc/profile.d/
- set | wc -l # 统计信息

![[Snipaste/Pasted image 20221027153100.png]]

- shell 能够找出当前 shell 的所有变量
- env 输出全部命令
- export 显示和设置环境变量
- set, declare
- suset name
- readonly name="123"
- awk 对结果进行格式化

![[Snipaste/Pasted image 20221027154814.png]]

- awk 命令是什么鬼

![[Snipaste/Pasted image 20221027155150.png]]

#### 变量的花式操作

#### 特殊状态变量

![[Snipaste/Pasted image 20221027184702.png]]

- man bash
- Special Parameters

![[Snipaste/Pasted image 20221027185344.png]]  
![[Snipaste/Pasted image 20221027185533.png]]  
![[Snipaste/Pasted image 20221027185702.png]]

- $\_ 获取上一次传入的最后一个参数

### Bash 基础命令

- echo
- eval
- exec
- export
- read
- shift
- 我真的要困死辣。

![[Snipaste/Pasted image 20221027190103.png]]

- echo 有换行
- eval 执行多个命令

```shell
eval ls; cd tmp
```

![[Snipaste/Pasted image 20221027190604.png]]

### Shell 子串

![[Snipaste/Pasted image 20221027191808.png]]

- 我的头有带你小痛
- linux 一切皆文件。你这个学期一个重要的任务就是复习之前所有的技术，并且有所精进。
- $(#name) **最快的统计方式**
- echo $name | wc -L # 输出最长的那一行。
- expr ---> 数值计算
- expr length "${name}"
- echo "$(name)" | awk \`{print length($0)}\` —— awk 的方式
- time 命令，统计命令执行时长
- 学习到统计指令运行时间。

## 理解

- 其实相对于其他编程语言，shell 通过各种参数的输入 (指定)。其实 shell 是各种命令的一个集合，通过这些命令去实现自动化。

## Linux 三剑客

- grep，擅长单纯的查找或匹配文本内容；
- sed，擅长文本编辑，处理匹配到的文本内容；
- [awk，适合格式化文本文件，对文本文件进行更复杂的加工处理、分析；](https://blog.csdn.net/zhangcongyi420/article/details/125692179?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166685692616782390522779%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166685692616782390522779&biz_id=0&spm=1018.2226.3001.4187)

## Expect

- [shell expect实现无交互操作_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1wW411K7Zy/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)

```shell
yum install -y expect
```

![[Snipaste/Pasted image 20221027194103.png]]  
![[Snipaste/Pasted image 20221027194209.png]]

- 通过 timeout 设置等待时间

![[Snipaste/Pasted image 20221027194320.png]]  
![[Snipaste/Pasted image 20221027194401.png]]  
![[Snipaste/Pasted image 20221027195520.png]]

- chmod +x ssh.exp
- 如何用一个脚本调用另一个脚本呢？
- 只能针对一个主机，其他主机需要更改脚本。
- 通用的脚本如何实现：通过位置参数传递

![[Snipaste/Pasted image 20221027202324.png]]

![[Snipaste/Pasted image 20221027202336.png]]

![[Snipaste/Pasted image 20221027202445.png]]

- 自定义一个命令，这是最后一个拼图吗？
- 为什么网络这么差呀。

## FAQ

### 如何在一个 Shell 中调用另一个 Shell

- [在 Shell 脚本中调用另一个 Shell 脚本的三种方式](https://blog.csdn.net/m0_46535940/article/details/124959568?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)

fork: 如果脚本有执行权限的话，path/to/foo.sh。如果没有，sh path/to/foo.sh。  
exec: exec path/to/foo.sh  
source: source path/to/foo.sh

- **fork** 是最普通的, 就是直接在脚本里面用 path/to/foo.sh 来调用 foo.sh 这个脚本，比如如果是 foo.sh 在当前目录下，就是 ./foo.sh。运行的时候 terminal 会新开一个子 Shell 执行脚本 foo.sh，子 Shell 执行的时候, 父 Shell 还在。子 Shell 执行完毕后返回父 Shell。 子 Shell 从父 Shell 继承环境变量，但是子 Shell 中的环境变量不会带回父 Shell。
- **exec** 与 fork 不同，不需要新开一个子 Shell 来执行被调用的脚本. 被调用的脚本与父脚本在同一个 Shell 内执行。但是使用 exec 调用一个新脚本以后, 父脚本中 exec 行之后的内容就不会再执行了。这是 exec 和 source 的区别.
- **source** 与 fork 的区别是不新开一个子 Shell 来执行被调用的脚本，而是在同一个 Shell 中执行. 所以被调用的脚本中声明的变量和环境变量, 都可以在主脚本中进行获取和使用。
- source 既可以继续执行，又可以与父 Shell 使用共同的环境变量。---> source 调用构建数据库表的脚本。

## Reference

- [Shell 变量 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-shell-variable.html)
- [dylanaraps/pure-bash-bible: 📖 A collection of pure bash alternatives to external processes. (github.com)](https://github.com/dylanaraps/pure-bash-bible#trim-leading-and-trailing-white-space-from-string)
- [解读天书02——Bash教程（狂秀操作）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV15A411u7nf/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [03 Shebang的正确玩法_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV14L4y157Bv?p=3&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [grep 正则匹配](https://blog.csdn.net/lovedingd/article/details/116532053?spm=1001.2101.3001.6661.1&depth_1-utm_relevant_index=1)
- [(80条消息) linux awk 命令使用详解_小码农叔叔的博客-CSDN博客_linux中awk命令的用法](https://blog.csdn.net/zhangcongyi420/article/details/125692179?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166685692616782390522779%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166685692616782390522779&biz_id=0&spm=1018.2226.3001.4187)
- [Linux三剑客超全超详情教程（grep、sed、awk入门到精通有这一套足够了）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1rA4y1S7Hk/?from=search&seid=15511154463518874849&spm_id_from=333.337.0.0&vd_source=25509bb582bc4a25d86d871d5cdffca3)
