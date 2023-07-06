# 1 正则表达式

## 1.1 进阶知识

### 1.1.1 扩展符号

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
字母模式匹配
    [:alnum:] 字母和数字
    [:alpha:] 代表任何英文大小写字符，亦即 A-Z, a-z
    [:lower:] 小写字母,示例:[[:lower:]],相当于[a-z]
    [:upper:] 大写字母
数字模式匹配
    [:digit:] 十进制数字
    [:xdigit:]十六进制数字
符号模式匹配
    [:blank:] 空白字符（空格和制表符）
    [:space:] 包括空格、制表符(水平和垂直)、换行符、回车符等各种类型的空白
    [:cntrl:] 不可打印的控制字符（退格、删除、警铃...）
    [:graph:] 可打印的非空白字符
    [:print:] 可打印字符
    [:punct:] 标点符号
    
注意：
	在使用该模式匹配的时候，一般用[[ ]]，
		- 第一个中括号是匹配符[] 匹配中括号中的任意一个字符
		- 第二个[]是格式 如[:digit:]
```

```powershell
属性模式匹配
    \s 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [\f\r\t\v]。
    \S 匹配任何非空白字符。等价于 [^\f\r\t\v]
    \w 匹配一个字母,数字,下划线,汉字,其它国家文字的字符，等价于[_[:alnum:]字]
    \W 匹配一个非字母,数字,下划线,汉字,其它国家文字的字符，等价于[^_[:alnum:]字]
```



**简单实践**

准备文件

```
[root@localhost ~]# cat file1.txt
acd
abc
a_c
aZc
aZd
a c
a3c
```

精确匹配实践

```powershell
以a开头c结尾  中间a-zA-Z0-9任意字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:alnum:]]c$" file1.txt
abc
aZc
a3c

以a开头c结尾  中间是a-zA-Z任意字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:alpha:]]c$" file1.txt
abc
aZc

以a开头c结尾  中间是0-9任意字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:digit:]]c$" file1.txt
a3c

以a开头c结尾  中间是a-z任意字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:lower:]]c$" file1.txt
abc



以a开头c结尾  中间是A-Z任意字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:upper:]]c$" file1.txt
aZc

以a开头c结尾  中间是可打印符号  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:print:]]c$" file1.txt
abc
a_c
aZc
a c
a3c

以a开头c结尾  中间是符号字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:punct:]]c$" file1.txt
a_c

以a开头c结尾  中间是空格或者TAB符字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:blank:]]c$" file1.txt
a c
[root@localhost ~]# egrep "^a[[:space:]]c$" file1.txt
a c

以a开头c结尾  中间是十六进制字符  长度为三个字节的字符串
[root@localhost ~]# egrep "^a[[:xdigit:]]c$" file1.txt
abc
a3c
```



**小结**

```

```

### 1.1.2 目标检测

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

需求

```
	定制站点或目标主机的检测平台，在对站点域名和主机ip检测之前，判断输入的语法是否正确。
```

ip检测

```powershell
定制ip地址文件
[root@localhost ~]# cat testip.txt
112.456.44.55
256.18.56.1
10.0.0.12

匹配ip地址
[root@localhost ~]# egrep '(^([1-9]|1[0-9]|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.)(([0-9]{1,2}|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.){2}([0-9]{1,2}|1[1-9]{2}|2[0-5][0-9]|25[0-4])$'  testip.txt
10.0.0.12
```

网址检测

```powershell
定制ip地址文件
[root@localhost ~]# cat testsite.txt
http://www.baidu.com
www.126.com
163.com
http.example.comcom

匹配ip地址
[root@localhost ~]# egrep '((http|https|ftp):\/\/)?(www\.)?([0-Z]+\.)([a-Z]{2,5})$'  testsite.txt
http://www.baidu.com
www.126.com
163.com
```

**简单实践**

脚本内容

```powershell
查看脚本内容
[root@localhost ~]# cat target_check.sh
#!/bin/bash
# 功能：定制主机存活的检测功能
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制目标类型变量
target_type=(主机 网站)

# 定制检测ip地址格式的函数
check_ip(){
    # 接收函数参数
    IP=$1
    ip_regex='(^([1-9]|1[0-9]|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.)(([0-9]{1,2}|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.){2}([0-9]{1,2}|1[1-9]{2}|2[0-5][0-9]|25[0-4])$'
    # 判断ip地址是否有效
    echo $IP | egrep "${ip_regex}" >/dev/null && echo "true" || echo "false"
}

# 定制网址的格式检测函数
check_url(){
    # 接收函数参数
    site=$1
    site_regex='((http|https|ftp):\/\/)?(www\.)?([0-Z]+\.)([a-Z]{2,5})$'
    # 判断网址地址是否有效
    echo $site | egrep "${site_regex}" >/dev/null && echo "true" || echo "false"
}

# 定制服务的操作提示功能函数
menu(){
    echo -e "\e[31m---------------确定检测目标类型---------------"
    echo -e " 1: 主机  2: 网站"
    echo -e "-------------------------------------------\033[0m"
}

# 目标主机检测过程
host_ip_check(){
    read -p "> 请输入要检测的主机ip: " ip_addr
    result=$(check_ip ${ip_addr})
    if [ ${result} == "true" ];then
       ping -c1 -W1 ${ip_addr} &> /dev/null && echo "${ip_addr} 状态正常" || echo "${ip_addr} 状态不可达"
    else
       echo "目标ip格式异常"
    fi
}

# 目标站点检测过程
net_site_check(){
    read -p "> 请输入要检测的网站地址: " site_addr
    result=$(check_url ${site_addr})
    if [ ${result} == "true" ];then
        curl -s -o /dev/null ${site_addr} && echo "${site_addr} 状态正常" || echo "${site_addr} 状态异常"
    else
        echo "目标网址格式异常"
    fi
}

# 定制帮助信息
Usage(){
    echo "请输入正确的检测目标类型"
}

# 定制业务逻辑
while true
do
    menu
    read -p "> 请输入要检测的目标类型: " target_id
    if [ ${target_type[$target_id-1]} == "主机" ];then
        host_ip_check
    elif [ ${target_type[$target_id-1]} == "网站" ];then
        net_site_check
    else
        Usage
    fi
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash target_check.sh
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 1
> 请输入要检测的主机ip: 1aaa
目标ip格式异常
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 1
> 请输入要检测的主机ip: 10.0.0.12
10.0.0.12 状态正常
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 1
> 请输入要检测的主机ip: 10.0.0.13
10.0.0.13 状态不可达
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 2
> 请输入要检测的网站地址: www
目标网址格式异常
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 2
> 请输入要检测的网站地址: www.baidu.com
www.baidu.com 状态正常
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: 2
> 请输入要检测的网站地址: www.nihaoxxxxxx.com
www.nihaoxxxxxx.com 状态异常
---------------确定检测目标类型---------------
 1: 主机  2: 网站
-------------------------------------------
> 请输入要检测的目标类型: ^C
[root@localhost ~]#
```

**小结**

```

```



### 1.1.3 登录检测

学习目标

这一节，我们从 需求简介、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	在很多的应用交互页面，经常会出现一些用户输入的信息：
		账号登录场景: 比如用户名、密码、手机号、邮箱之类的校验信息
```

手机号匹配

```powershell
准备手机号文件
[root@localhost ~]# cat phone.txt
13412345678
135666666667
13a12345678
198123456

过滤真正的手机号
[root@localhost ~]# egrep '\<1[3-9][0-9]{9}\>' phone.txt
13412345678
```

邮箱地址匹配

```powershell
定制邮箱地址文件
[root@localhost ~]# cat testemail.txt
admin@qq.com
1881111@gmail.eduedu
10.0.0.12
"shuji@qq.com
123_shuji@12306.cn

匹配邮箱地址
[root@localhost ~]# egrep  "^[0-Z_]+\@[0-Z]+\.[0-Z]{2,5}$" testemail.txt
admin@qq.com
123_shuji@12306.cn
```

**简单实践**

脚本内容

```powershell
查看脚本内容
[root@localhost ~]# cat register_login_manager.sh
#!/bin/bash
# 功能：定制管理界面的登录注册功能
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制目标类型变量
target_type=(登录 注册)

# 定制普通变量
user_regex='^[0-Z_@.]{6,15}$'
passwd_regex='^[0-Z.]{6,8}$'
phone_regex='^\<1[3-9][0-9]{9}\>$'
email_regex='^[0-Z_]+\@[0-Z]+\.[0-Z]{2,5}$'

# 检测用户名规则
check_func(){
    # 接收函数参数
    target=$1
    target_regex=$2
    # 判断目标格式是否有效
    echo $target | egrep "${target_regex}" >/dev/null && echo "true" || echo "false"
}

# 定制服务的操作提示功能函数
menu(){
    echo -e "\e[31m---------------管理平台登录界面---------------"
    echo -e " 1: 登录  2: 注册"
    echo -e "-------------------------------------------\033[0m"
}

# 定制帮助信息
Usage(){
    echo "请输入正确的操作类型"
}

# 管理平台用户注册过程
user_register_check(){
    read -p "> 请输入用户名: " login_user
    user_result=$(check_func ${login_user} ${user_regex})
    if [ ${user_result} == "true" ];then
        read -p "> 请输入密码: " login_passwd
        passwd_result=$(check_func ${login_passwd} ${passwd_regex})
        if [ ${passwd_result} == "true" ];then
            read -p "> 请输入手机号: " login_phone
            phone_result=$(check_func ${login_phone} ${phone_regex})
            if [ ${phone_result} == "true" ];then
                read -p "> 请输入邮箱: " login_email
                email_result=$(check_func ${login_email} ${email_regex})
                if [ ${email_result} == "true" ];then
                    echo -e "\e[31m----用户注册信息内容----"
                    echo -e " 用户名称: ${login_user}"
                    echo -e " 登录密码: ${login_passwd}"
                    echo -e " 手机号码: ${login_phone}"
                    echo -e " 邮箱地址: ${login_email}"
                    echo -e "------------------------\033[0m"
                    read -p "> 是否确认注册[yes|no]: " login_status
                    [ ${login_status} == "yes" ] && echo "用户 ${login_user} 注册成功" && exit || return
                else
                   echo "邮箱地址格式不规范"
                fi
            else
                echo "手机号码格式不规范"
            fi
        else
            echo "登录密码格式不规范"
        fi
    else
        echo "用户名称格式不规范"
    fi
}

# 定制业务逻辑
while true
do
    menu
    read -p "> 请输入要操作的目标类型: " target_id
    if [ ${target_type[$target_id-1]} == "登录" ];then
        echo "开始登录管理平台..."
    elif [ ${target_type[$target_id-1]} == "注册" ];then
        user_register_check
    else
        Usage
    fi
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash register_login_manager.sh
---------------管理平台登录界面---------------
 1: 登录  2: 注册
-------------------------------------------
> 请输入要操作的目标类型: 2
> 请输入用户名: root12345
> 请输入密码: 12345678
> 请输入手机号: 13412345678
> 请输入邮箱: qq@123.com
----用户注册信息内容----
 用户名称: root12345
 登录密码: 12345678
 手机号码: 13412345678
 邮箱地址: qq@123.com
------------------------
> 是否确认注册[yes|no]: yes
用户 root12345 注册成功
[root@localhost ~]# /bin/bash register_login_manager.sh
---------------管理平台登录界面---------------
 1: 登录  2: 注册
-------------------------------------------
> 请输入要操作的目标类型: 2
> 请输入用户名: admin123
> 请输入密码: 12345678
> 请输入手机号: 14456789090
> 请输入邮箱: qq@qq.com
----用户注册信息内容----
 用户名称: admin123
 登录密码: 12345678
 手机号码: 14456789090
 邮箱地址: qq@qq.com
------------------------
> 是否确认注册[yes|no]: no
---------------管理平台登录界面---------------
 1: 登录  2: 注册
-------------------------------------------
> 请输入要操作的目标类型:
```



**小结**

```

```



# 2 sed命令

## 2.1 基础实践

### 2.1.1 基础语法

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

场景

```powershell
	shell脚本虽然功能很多，但是它最常用的功能还是处理文本文件，尤其是在正常的业务操作流程场景中，比如检查日志文件、读取配置、处理数据等现象，虽然我们能够使用echo、cat、<<、>>、|等符号实现文件内容的操作，但是整个过程有些繁琐。所以我们需要一种更为轻便的文本编辑工具，sed就是其中的一种。
```

简介

```powershell
	sed(Stream EDitor) 属于一种数据流式的行文件编辑工具。因为它编辑文件的时候，在内存中开辟一块额外的模式空间(pattern space)，然后以行为单位读取文件内容到该空间中，接着sed命令处理该空间中的内容，默认在当前终端界面打印内容，然后清空模式空间内容，再来读取第二行内容，依次循环下去。
```

![image-20220618012401672](image/image-20220618012401672.png)

```powershell
    作用：用来自动编辑一个或多个文件，简化对文件的反复操作，编写转换程序等。
    参考：http://www.gnu.org/software/sed/manual/sed.html
```

语法格式

```powershell
基本格式	
	sed [参数] '<匹配条件> [动作]' [文件名]
注意：
	匹配条件和动作两侧有'
	动作可以有多个，彼此间使用;隔开，比如 '2p;4p'
```

```powershell
参数详解：
    参数为空	 表示sed的操作效果，实际上不对文件进行编辑，缓存区所有信息都显示
    -n			不输出模式空间内容到屏幕，即不自动打印所有内容
    -e			基于命令实现对文件的多点编辑操作
    -f			从指定文件中读取编辑文件的”匹配条件+动作”
    -r			支持使用扩展正则表达式
    -i.bak		复制文件原内容到备份文件，然后对原文件编辑
    -i			表示对文件进行编辑

注意：
   mac版本的bash中使用 -i参数，必须在后面单独加个东西： -i ''
    -i -r 支持  -ri   支持
    -ir   不支持
    -ni   危险选项,会清空文件
```

```powershell
匹配条件分为两种：数字行号或者关键字匹配
数字行号：
	空 表示所有行				n 表示第n行				$ 表示末尾行
	n,m 表示第n到m行内容		n,+m 表示第n到n+m行
	~步进	1~2 表示奇数行		2~2 表示偶数行

关键字匹配格式：
	'/关键字/'
    注意：
        隔离符号 / 可以更换成 @、#、！等符号
        根据情况使用，如果关键字和隔离符号有冲突，就更换成其他的符号即可。
        /关键字1/,/关键字2/ 表示关键字1所在行到关键字2所在行之间的内容
        n,/关键字2/ 表示从第n行到关键字2所在行之间的内容
```

```powershell
动作详解
    -a[\text]			在匹配到的内容下一行增加内容，支持\n实现多行追加
    -i[\text]			在匹配到的内容当前行增加内容
    -c[\text]			在匹配到的内容替换内容
    -d|p				删除|打印匹配到的内容
    -s					替换匹配到的内容
    W /path/somefile 	保存模式匹配的行至指定文件
    r /path/somefile	读取指定文件的文本至模式空间中
    =					为模式空间中的行打印行号
    !					模式空间中匹配行取反处理
注意：
	上面的动作应该在参数为-i的时候使用，不然的话不会有效果
```

**简单实践**

准备工作

```powershell
模板文件内容
[root@localhost ~]# cat sed.txt
nihao sed1 sed2 sed3
nihao sed4 sed5 sed6
nihao sed7 sed8 sed9
```

实践1-打印信息

```powershell
默认打印信息
[root@localhost ~]# sed '2p' sed.txt
nihao sed1 sed2 sed3
nihao sed4 sed5 sed6
nihao sed4 sed5 sed6			# 这一行才是操作的内容，其他的都是缓存区自动输出
nihao sed7 sed8 sed9

打印第2行，不输出缓存区默认的其他信息
[root@localhost ~]# sed -n '2p' sed.txt 
nihao sed4 sed5 sed6

打印第1,3行，不输出缓存区默认的其他信息
[root@localhost ~]# sed -n '1p;3p' sed.txt
nihao sed1 sed2 sed3
nihao sed7 sed8 sed9

打印网卡信息
[root@localhost ~]# ifconfig eth0 | sed -n '2p'
        inet 10.0.0.12  netmask 255.255.255.0  broadcast 10.0.0.255
        
打印磁盘信息
[root@localhost ~]# df | sed -n '/^\/dev\/sd/p'
/dev/sda2      19911680 2772988 17138692   14% /
/dev/sda1       1038336  145380   892956   15% /boot
```

实践2-匹配内容打印

```powershell
打印包含sed4的行
[root@localhost ~]# sed -n '/sed4/p' sed.txt 
nihao sed4 sed5 sed6

打印奇数行
[root@localhost ~]# sed -n '1~2p' sed.txt      
nihao sed1 sed2 sed3
nihao sed7 sed8 sed9

打印偶数行
[root@localhost ~]# sed -n '0~2p' sed.txt
nihao sed4 sed5 sed6
```

实践3-文件编辑

```powershell
-e实现多次文件编辑动作
[root@localhost ~]# sed -n -e '1p' -e '3p' sed.txt    
nihao sed1 sed2 sed3
nihao sed7 sed8 sed9

将文件操作命令输出到一个文件
[root@localhost ~]# echo -e "1p\n3p" > sed_script
借助文件里面的命令实现文件编辑
[root@localhost ~]# sed -n -f sed_script sed.txt 
nihao sed1 sed2 sed3
nihao sed7 sed8 sed9
```

实践4-其他信息显示

```powershell
取反显示
[root@localhost ~]# sed -n '2!p' sed.txt            
nihao sed1 sed2 sed3
nihao sed7 sed8 sed9


查看内容属于第几行
[root@localhost ~]# sed -n '/sed4/=' sed.txt  
2
```





**小结**

```

```



### 2.1.2 内容替换

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	sed的文本替换动作是使用频率最高的一种样式。它的基本表现样式如下：
```

```powershell
命令格式：
	sed -i [替换格式] [文件名]
	源数据 | sed -i [替换格式]
	
注意：替换命令的写法
	's###'  --->  's#原内容##' ---> 's#原内容#替换后内容#'
	隔离符号 / 可以更换成 @、#、！等符号
```

```powershell
表现样式：
    样式一：替换指定匹配的内容
        sed -i '行号s#原内容#替换后内容#列号' [文件名]
        echo "源数据" | sed -i '行号s#原内容#替换后内容#列号'
    样式二：替换所有的内容
        sed -i 's#原内容#替换后内容#g' [文件名]
    	echo "源数据" | sed -i '行号s#原内容#替换后内容#g'
    样式三: 替换指定的内容
    	sed -i '行号s#原内容#&新增信息#列号' [文件名]
    	- 这里的&符号代表源内容，实现的效果是 '原内容+新内容'
```

**简单实践**

实践1-替换每行首个匹配内容

```powershell
格式：sed -i 's#原内容#替换后内容#' 文件名

替换首每行的第1个sed为SED
[root@localhost ~]# sed -i 's#sed#SED#' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED1 sed2 sed3
nihao SED4 sed5 sed6
nihao SED7 sed8 sed9
```

实践2-替换全部匹配内容

```powershell
格式：sed -i 's#原内容#替换后内容#g' 文件名

替换全部sed为des
[root@localhost ~]# sed -i 's#sed#SED#g' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED1 SED2 SED3
nihao SED4 SED5 SED6
nihao SED7 SED8 SED9

关于全部替换还有另外一种命令叫直接转换 y
[root@localhost ~]# sed 'y/SED/sed/' sed.txt
nihao sed1 sed2 sed3
nihao sed4 sed5 sed6
nihao sed7 sed8 sed9
```

实践3-指定行号替换首个匹配内容

```powershell
格式：sed -i '行号s#原内容#替换后内容#' 文件名

替换第2行的首个SED为sed
[root@localhost ~]# sed -i '2s#SED#sed#' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED1 SED2 SED3
nihao sed4 SED5 SED6
nihao SED7 SED8 SED9
```

实践4-首行指定列号替换匹配内容

```powershell
格式：sed -i 's#原内容#替换后内容#列号' 文件名

替换每行的第2个SED为sed
[root@localhost ~]# sed -i 's#SED#sed#2' sed.txt
[root@localhost ~]# cat sed.txt 
nihao SED1 sed2 SED3
nihao sed4 SED5 sed6
nihao SED7 sed8 SED9
```

实践5-指定行号列号匹配内容

```powershell
格式：sed -i '行号s#原内容#替换后内容#列号' 文件名

替换第3行的第2个SED为sed
[root@localhost ~]# sed -i '3s#SED#sed#2' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED sed2 SED3
nihao sed4 SED5 sed6
nihao SED7 sed8 sed9
```

实践6-综合实践

```powershell
借助正则的分组功能实现ip地址获取
[root@localhost ~]# ifconfig eth0 | sed -n '2p' | sed -r 's#.*inet (.*) net.*#\1#'
10.0.0.12
[root@localhost ~]# ifconfig eth0 | sed -n '2p' | sed -r 's#.*inet ##' | sed -r 's# net.*##' 
10.0.0.12

借助正则的分组功能实现信息的精确获取
[root@localhost ~]# echo '/etc/sysconfig/network' | sed -r 's#(.*\/)([^/]+\/?$)#\2#'
network
[root@localhost ~]# echo '/etc/sysconfig/network' | sed -r 's#(.*\/)([^/]+\/?$)#\1#'
/etc/sysconfig/
```



**小结**

```

```



### 2.1.3 增加操作

学习目标

这一节，我们从 追加实践、插入实践、小结 三个方面来学习

**追加实践**

基本语法

```powershell
作用：
	在指定行号的下一行增加内容
格式：
	sed -i '行号a\增加的内容' 文件名
注意：
    如果增加多行，可以在行号位置写个范围值，彼此间使用逗号隔开，例如
    sed -i '1,3a\增加内容' 文件名
```

实践1-基于行号实践

```powershell
指定行号增加内容
[root@localhost ~]# sed -i '2a\zengjia-2' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED sed2 SED3
nihao sed4 SED5 sed6
zengjia-2
nihao SED7 sed8 sed9
指定1~3每行都增加内容
[root@localhost ~]# sed -i '1,3a\tongshi-2' sed.txt 
[root@localhost ~]# cat sed.txt 
nihao SED sed2 SED3
tongshi-2
nihao sed4 SED5 sed6
tongshi-2
zengjia-2
tongshi-2
nihao SED7 sed8 sed9
```

**插入实践**

基本语法

```powershell
作用：
	在指定行号的当行增加内容
格式：
	sed -i '行号i\增加的内容' 文件名
注意：
    如果增加多行，可以在行号位置写个范围值，彼此间使用逗号隔开，例如
    sed -i '1,3i\增加内容' 文件名
```

实践1-基于行号实践

```powershell
指定行号增加内容
[root@localhost ~]# sed -i '1i\insert-1' sed.txt 
[root@localhost ~]# cat sed.txt 
insert-1
nihao SED sed2 SED3
tongshi-2
nihao sed4 SED5 sed6
tongshi-2
zengjia-2
tongshi-2
nihao SED7 sed8 sed9

指定1~3每行都增加内容
[root@localhost ~]# sed -i '1,3i\insert-2' sed.txt 
[root@localhost ~]# cat sed.txt
insert-2
insert-1
insert-2
nihao SED sed2 SED3
insert-2
tongshi-2
nihao sed4 SED5 sed6
tongshi-2
zengjia-2
tongshi-2
nihao SED7 sed8 sed9
```

**小结**

```

```

### 2.1.4 删除替换

学习目标

这一节，我们从 删除实践、替换实践、小结 三个方面来学习

**删除实践**

基本语法

```powershell
作用：
	指定行号删除
格式：
	sed -i '行号d' 文件名
注意：
    如果删除多行，可以在行号位置多写几个行号，彼此间使用逗号隔开，例如
    sed -i '1,3d' 文件名
```

实践1-基于行号实践

```powershell
删除第4行内容
[root@localhost ~]# sed -i '4d' sed.txt 
[root@localhost ~]# cat sed.txt 
insert-2
insert-1
insert-2
insert-2
tongshi-2
nihao sed4 SED5 sed6
tongshi-2
zengjia-2
tongshi-2
nihao SED7 sed8 sed9

删除多行(1-6行)内容
[root@localhost ~]# sed -i '1,6d' sed.txt
[root@localhost ~]# cat sed.txt
tongshi-2
zengjia-2
tongshi-2
nihao SED7 sed8 sed9
```

**替换实践**

基本语法

```powershell
作用：
	指定行号进行整行替换
格式：
	sed -i '行号c\内容' 文件名
注意：
    如果替换多行，可以在行号位置多写几个行号，彼此间使用逗号隔开，例如
    sed -i '1,3c\内容' 文件名
```

实践1-基于行号实践

```powershell
替换第3行内容
[root@localhost ~]# sed -i '3c\tihuan-1' sed.txt
[root@localhost ~]# cat sed.txt
tongshi-2
zengjia-2
tihuan-1
nihao SED7 sed8 sed9


指定1~3行都替换成一行内容
[root@localhost ~]# sed -i '1,3c\tihuan-3' sed.txt
[root@localhost ~]# cat sed.txt
tihuan-3
nihao SED7 sed8 sed9
```

**小结**

```

```

### 2.1.5 加载保存

学习目标

这一节，我们从 加载实践、保存实践、小结 三个方面来学习

**加载实践**

基本语法

```powershell
作用：
	加载文件内容到指定行号的位置
格式：
	sed -i '行号r 文件名1' 文件名
注意：
    如果在多行位置加载，可以在行号位置多写几个行号，彼此间使用逗号隔开，例如
    sed -i '1,3r 文件名1' 文件名
```

实践1-基于行号实践

```powershell
加载第3行内容
[root@localhost ~]# sed -i '2r sed.txt' sed.txt
[root@localhost ~]# cat sed.txt
tihuan-3
nihao SED7 sed8 sed9
tihuan-3
nihao SED7 sed8 sed9
注意；
	由于缓存区中文件内容的顺序变化，导致加载的内容顺序不一致

制定内容文件，加载到2-4行下面
[root@localhost ~]# sed -i '2,4r sed_script' sed.txt
[root@localhost ~]# cat sed_script
1p
3p
[root@localhost ~]# cat sed.txt
tihuan-3
nihao SED7 sed8 sed9
1p
3p
tihuan-3
1p
3p
nihao SED7 sed8 sed9
1p
3p
```

**保存实践**

基本语法

```powershell
作用：
	指定行号保存到其他位置
格式：
	sed -i '行号w 文件名' 文件名
注意：
    如果多行保存，可以在行号位置多写几个行号，彼此间使用逗号隔开，例如
    sed -i '1,3w 文件名' 文件名
    文件名已存在，则会覆盖式增加
```

实践1-基于行号实践

```powershell
保存第3行内容
[root@localhost ~]# sed -i '2w sed_test' sed.txt
[root@localhost ~]# cat sed_test
nihao SED7 sed8 sed9



指定2~4行内容保存到一个文件中
[root@localhost ~]# sed -i '1,4w sed_test' sed.txt
[root@localhost ~]# cat sed_test
tihuan-3
nihao SED7 sed8 sed9
1p
3p
```

**小结**

```

```



## 2.2 进阶实践

### 2.2.1 匹配进阶

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	我们之前的所有操作基本上都是基于行的操作，其实本质上还有另外一些操作 -- 基于内容的操作。语法格式如下：
```

```powershell
内容匹配：
	'/关键字内容/'
    注意：
        隔离符号 / 可以更换成 @、#、！等符号
        根据情况使用，如果关键字和隔离符号有冲突，就更换成其他的符号即可。
        /关键字1/,/关键字2/ 表示关键字1所在行到关键字2所在行之间的内容
        n,/关键字2/ 表示从第n行到关键字2所在行之间的内容
        /关键字1/,n, 表示从关键字1所在行到第n行之间的内容
        /关键字1/,+n, 表示从关键字1所在行到(所在行+n行)之间的内容
```

**简单实践**

实践1-内容的简单匹配显示

```powershell
查看匹配的内容
[root@localhost ~]# sed -n '/send/p' nginx.conf
    sendfile        on;

匹配内容间的多行信息
[root@localhost ~]# sed -n '/send/,/server/p' nginx.conf
    sendfile        on;
    keepalive_timeout  65;

    server {

查看匹配内容到第6行的内容
[root@localhost ~]# sed -n '/send/,6p' nginx.conf
    sendfile        on;
    keepalive_timeout  65;
 
查看第1行到匹配行的内容
[root@localhost ~]# sed -n '1,/send/p' nginx.conf
#user  nobody;
worker_processes  1;

http {
    sendfile        on;
    
查看匹配内容和下面三行的内容
[root@localhost ~]# sed -n '/send/,+3p' nginx.conf
    sendfile        on;
    keepalive_timeout  65;

    server {

通过 !p 去除空行匹配
[root@localhost ~]# sed -n '/^$/!p' nginx.conf
#user  nobody;
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
借助分组功能，实现多信息的剔除
[root@localhost ~]# sed -rn '/^(#|$)/!p' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
```

实践2-分组信息显示

```powershell
获取制定文件所在的路径信息
[root@localhost ~]# echo "/etc/sysconfig/network" |sed -r 's#(^/.*/)([^/]+/?)#\1#'
/etc/sysconfig/

获取制定文件名称
[root@localhost ~]# echo "/etc/sysconfig/network" |sed -r 's#(^/.*/)([^/]+/?)#\2#'
network

获取ip地址
[root@localhost ~]# ifconfig eth0 |sed -nr "2s/[^0-9]+([0-9.]+).*/\1/p"
10.0.0.12

获取MAC地址
[root@localhost ~]# ifconfig eth0 |sed -nr "4s/[^0-9]+([0-Z:]+).*/\1/p"
00:0c:29:23:23:8c
```



**小结**

```

```



### 2.2.2 修改实践

学习目标

这一节，我们从 多点操作、增改实践、小结 三个方面来学习

**多点操作**

简介

```powershell
我们可以借助 '动作1;动作2' 或者 -e '动作1' -e '动作2' 的方式实现多操作的并行实施
```

实践1-内容的过滤编辑

```powershell
不显示所有空行和注释信息
[root@localhost ~]# sed '/^#/d;/^$/d' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}

先剔除空行，然后不显示所有包含注释的信息
[root@localhost ~]# sed -rn '/^$/d;/^[[:space:]]*#/!p' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
```

实践2-借助于 i.bak 方式对有效信息进行过滤

```powershell
编辑文件的时候，原内容备份到一个额外的文件
[root@localhost ~]# sed -i.bak '/^#/d;/^$/d' nginx.conf
[root@localhost ~]# cat nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
[root@localhost ~]# grep '#' nginx.conf.bak
#user  nobody;
```



**增改实践**

实践1-借助于&符号实现内容的扩充式更改编辑

```powershell
查看原内容
[root@localhost ~]# head -n 1 /etc/passwd
root:x:0:0:root:/root:/bin/bash

对原内容进行扩充替换
[root@localhost ~]# head -n 1 /etc/passwd | sed -n 's/root/&user/1p'
rootuser:x:0:0:root:/root:/bin/bash
[root@localhost ~]# head -n 1 /etc/passwd | sed -n 's/root/&user/gp'
rootuser:x:0:0:rootuser:/rootuser:/bin/bash
```

实践2-借助于s实现内容的替换式更改编辑

```powershell
获取没有被注释的信息
[root@localhost ~]# sed -n '/^#/!p' /etc/fstab

UUID=5583bd7c-cc9f-4e19-b453-c224102f3ed5 /      xfs     defaults        0 0
UUID=cbd246cd-1df8-4fe7-9040-823cd0978837 /boot  xfs     defaults        0 0

将注释的信息进行替换
[root@localhost ~]# sed -rn '/^#/!s@^@#@p' /etc/fstab
#
#UUID=5583bd7c-cc9f-4e19-b453-c224102f3ed5 /     xfs     defaults        0 0
#UUID=cbd246cd-1df8-4fe7-9040-823cd0978837 /boot xfs     defaults        0 0
```

实践3-借助于 i|a 对文件进行 插入|追加 式更改编辑

```powershell
基于内容匹配相关信息并打印
[root@localhost ~]# sed -n '/listen/p' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
基于内容匹配追加1行内容
[root@localhost ~]# sed '/listen/a\\tlisten\t\t80;' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       8000;
        listen          80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
基于内容匹配插入2行内容 -- 借助于\n的换行功能，将1行变成两行
[root@localhost ~]# sed '/listen/i\\tlisten\t\t80;\n\tlisten\t\t8080;' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen          80;
        listen          8080;
        listen       8000;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
```

实践4-借助于 环境变量和s|c 对文件进行 修改|替换 式更改编辑

```powershell
定制环境变量
[root@localhost ~]# port=8080

使用多点修改
[root@localhost ~]# sed -r -e "s/listen.*;/listen\t$port;/" -e '/server_name/c \\tserver_name '$(hostname):$port';' nginx.conf
worker_processes  1;
http {
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen  8080;
        server_name localhost:8080;
        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
注意：
	这里涉及到环境变量的解读，千万不要被单引号转义了
```



**小结**

```

```

### 2.2.3 高阶用法1

学习目标

这一节，我们从 基础知识、缓存实践、小结 三个方面来学习。

**基础知识**

简介

```powershell
	对于sed命令来说，除了我们经常使用的模式空间之外，它还支持一个叫暂存空间(Hold Space)的模式,所谓的暂存空间，也就是说，将模式空间中的数据，临时保存到暂存空间，从而实现更为强大的功能。
	相关业务逻辑流程如下:
```

![image-20220618113930348](image/image-20220618113930348.png)

```powershell
空间解读：
	缓存空间用于sed的内容模式匹配，一般称为模式空间
		- 模式空间内的信息可以输出到终端界面，除非模式空间的内容被删除或取消打印导致模式空间清空
	附加于缓存空间的附加缓存空间，一般称为暂存空间
		- 通过相关命令可以在模式空间信息清零之前，暂存到附加缓存空间，便于后续使用
	两个空间之间，可以基于一些高阶命令实现信息的传递
```

```powershell
常见的高阶命令  
    n 读取匹配到的行的下一行覆盖至模式空间
    N 读取匹配到的行的下一行追加至模式空间
    d 删除模式空间中的行
    D 如果模式空间包含换行符，则循环删除换行符前的内容，直至不包含任何换行符后，执行后续d操作
```

**简单实践**

实践1-模式空间覆盖

```powershell
查看逐行读取的信息
[root@localhost ~]# seq 6 | sed -n "p"
1
2
3
4
5
6

n 读取匹配到的行的下一行覆盖至模式空间
[root@localhost ~]# seq 6 | sed -n "n;p"
2
4
6
解读：
	第一次读的是1，"n;"的作用是读取2，然后覆盖模式空间的1

2次n代表读取到第3行，将前的内容覆盖
[root@localhost ~]# seq 6 | sed -n "n;n;p"
3
6

3次n代表读取到第4行，将前面的内容覆盖
[root@localhost ~]# seq 6 | sed -n "n;n;n;p"
4

获取匹配内容的下一行，覆盖匹配的内容
[root@localhost ~]# seq 6 | sed -n "/3/{n;p}"
4
解读：
	/3/ 代表的是匹配的3内容，然后{} 代表一个表达式区域，n;p 代表下一行覆盖式打印
```

实践2-模式空间清零

```powershell
n 读取匹配到的行的下一行覆盖至模式空间
[root@localhost ~]# seq 6 | sed -n "n;p"
2
4
6
解读：
	第一次读的是1，"n;"的作用是读取2，然后覆盖模式空间的1
	
d 删除模式空间中的行
[root@localhost ~]# seq 6 | sed -n "n;d"
[root@localhost ~]#
解读：
	n每覆盖一次，都用d删除一次，最终导致不会输出任何内容
```

实践3-模式空间扩容

```powershell
查看默认的信息输出
[root@localhost ~]# seq 6
1
2
3
4
5
6

N 读取匹配到的行的下一行追加至模式空间
[root@localhost ~]# seq 6 | sed 'N;s/\n//'
12
34
56
解读：
	第一次读的是1，"N;"的作用是读取2，然后追加到模式空间的1的后面
	然后使用s将换行\n替换为空，实现1和2的合并
	
通过-e，多一个N，就相当于为模式空间扩容了一个位置
[root@localhost ~]# seq 6 | sed -e 'N;s/\n//' -e 'N;s/\n//'
123
456
可以看到：
	1个空间+2个扩容 一共三个空间内容
```

**小结**

```

```

### 2.2.4 高阶用法2

学习目标

这一节，我们从  暂存实践、其他实践、小结 三个方面来学习。

 **暂存实践**

简介

```
	我们可以在缓存空间和暂存空间中进行数据的简单读取，还可以对数据进行一些复杂性的编辑操作
```

![image-20220618113930348](image/image-20220618113930348.png)

```powershell
常见的高阶命令
    P 打印模式空间开端至\n内容，并追加到默认输出之前
    h 把模式空间中的内容覆盖至暂存空间中
    H 把模式空间中的内容追加至暂存空间中
    g 从暂存空间取出数据覆盖至模式空间
    G 从暂存空间取出内容追加至模式空间
    x 把模式空间中的内容与暂存空间中的内容进行互换
```

实践1-暂存空间基本实践

```powershell
获取指定内容信息
[root@localhost ~]# seq 4 > seq.txt
[root@localhost ~]# cat -e seq.txt
1$
2$
3$
4$
结果显示；
	每一行后面都有换行符号$
```

```powershell
h 把模式空间中的内容覆盖至暂存空间中 G 从暂存空间取出内容追加至模式空间
[root@localhost ~]# sed -e '/2/h' -e '$G' seq.txt
1
2
3
4
2
解读：
	/2/h 将匹配到的内容存储到 暂存空间
	$ 正常信息输出的时候，不输出暂存空间的信息
	G 代表信息操作完毕后，将暂存区的内容，追加到模式空间

取消$,每次输出信息的时候，同时输出缓存区和暂存区的内容
[root@localhost ~]# sed -e '/2/h' -e 'G' seq.txt
1
					# 此时暂存区为空
2
2					# 此时暂存区内容为2
3
2					# 此时暂存区内容为2
4
2					# 此时暂存区内容为2
结果显示：
	每次输出信息的时候，都会输出暂存区信息

numG 代表仅在num位置输出暂存区信息
[root@localhost ~]# sed -e '/2/h' -e '1G' seq4.txt
1
				# 在第1个位置输出暂存区信息
2
3
4

num1,num2G 代表仅在num1-num2范围的位置输出暂存区信息
[root@localhost ~]# sed -e '/2/h' -e '1,2G' seq4.txt
1
				# 在第1个位置输出暂存区信息
2
2				# 在第2个位置输出暂存区信息
3
4

num!G 代表在num之外的位置输出暂存区信息
[root@localhost ~]# sed -e '/2/h' -e '1!G' seq4.txt
1
2
2
3
2
4
2
```

实践2-暂存区使用后，清理模式空间内容

```powershell
查看文件内容
[root@localhost ~]# cat -e seq.txt
1$
2$
3$

将匹配的内容转移至暂存区，然后清理模式空间
[root@localhost ~]# sed -e '/2/{h;d}' -e 'G' seq.txt
1
					# 此时暂存区为空
3					# 缓存区被清理，所以没有输出2
2
4
2
```

实践3-暂存区使用后，处理清理模式空间内容,

```powershell
将匹配的内容转移至暂存区，然后清理模式空间，接着将暂存区信息输出到特定的位置
[root@localhost ~]# sed -e '/2/{h;d}' -e '/3/{G;}' seq4.txt
1
3
2
4
解读：
	暂存区的信息在/3/后面显示
	-e '/3/{G;}' 可以简写为 -e '/3/G'

g 从保持空间取出数据覆盖至模式空间
[root@localhost ~]# sed -e '/2/{h;d}' -e '/3/g' seq4.txt
1
2
4
解读：
	g 的作用，是将/3/匹配到的缓存区内容被暂存区的信息覆盖，则缓存区内容是2
	
x 把模式空间中的内容与暂存空间中的内容进行互换
[root@localhost ~]# sed -e '/2/{h;d}' -e '/3/{x;G}' seq4.txt
1
2				# 缓存区的3被暂存区的2替换了
3				# 暂存区的2被缓存区的3替换了
4
解读：
	x 的作用，是将/3/匹配到的缓存区内容和暂存区的信息交换，则缓存区内容是2，暂存区是3
```

**其他实践**

实践1-内容倒序实践

```powershell
查看文件内容
[root@localhost ~]# cat seq.txt
1
2
3
4
除了第1行不输出暂存区，其他都输出暂存区值
[root@localhost ~]# sed -e '1!G' seq.txt
1
2
					# 第2处位置的暂存区为空
3
					# 第3处位置的暂存区为空
4
					# 第4处位置的暂存区为空

h将所有模式空间的内容覆盖到暂存区 
[root@localhost ~]# sed -e '1!G;h' seq.txt
1					# 暂存区在第1处缓存区不输出
----
2					# 缓存空间的1覆盖暂存区，然后在当前缓存区的2之后输出--追加
1					
---
3					# 缓存空间的21覆盖暂存区，然后在当前缓存区的3之后输出--追加
2					
1
--- 
4					# 缓存空间的321覆盖暂存区，然后在当前缓存区的4之后输出--追加
3
2
1

$!d 代表除了最后一个位置内容不删除，其他的都清除掉
[root@localhost ~]# sed -e '1!G;h;$!d' seq.txt
4
3
2
1
```

实践2-提取关键信息的前一行

```powershell
查看文件内容
[root@localhost ~]# cat seq4.txt
1
2
3
4

除了第1行不被暂存区覆盖，其他缓存区被暂存区覆盖
[root@localhost ~]# sed -e '1!g' seq4.txt
1
 					# 第2处位置被暂存区的空覆盖
					# 第3处位置被暂存区的空覆盖
					# 第4处位置被暂存区的空覆盖 
将匹配到的3不打印，存放到暂存区，然后仅输出缓存区信息
[root@localhost ~]# sed -n '/3/!p;h' seq4.txt
1
2
4
解读：
	/3/ 匹配到第3行的内容3，使用!p不输出，然后依次将缓存区内容覆盖暂存区
	最终输出的时候仅有一个区显示，另一个区为空
```

```powershell
[root@localhost ~]# sed -n '/3/g;p;h' seq4.txt
1		# 条件不匹配，交给h动作，缓存区的1会覆盖到暂存区
2		# 条件不匹配，交给h动作，缓存区的2会覆盖到暂存区
2		# 条件不匹配，交给h动作，暂存区的2通过g覆盖缓存区的3，所以输出2
4

{} 是shell中的一种独立区域，所做操作会直接影响当前的shell环境
[root@localhost ~]# sed -n '/3/{g;p};h' seq4.txt
2	
	{g;p} 代表直接将暂存区域的数据2覆盖缓存空间，由于{} 直接作用于shell环境
	所以p输出的时候，暂存区没有信息，缓存区域有2，仅仅输出2
```

**小结**

```

```

