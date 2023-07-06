# 1 流程控制

## 1.1 函数进阶

### 1.1.1 函数嵌套

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

简介

```powershell
	所谓的函数嵌套，主要是在函数间或者文件间相互使用的一种方式。它主要有三种样式：
```

```powershell
样式1：函数间调用
	- 函数体内部调用其他的函数名
样式2：文件间调用
	- 函数体内部调用另外一个文件的函数名
	- 需要额外做一步文件source的加载动作
	注意：我们将专门提供函数的文件称为 -- 函数库
样式3：函数自调用
	- 函数体内部调用自己的函数名，将复杂的逻辑简单化
```

**简单实践**

函数间调用实践1-图形信息打印

```powershell
	按照信息提示，分别打印 三角形 和 等腰梯形
        *                  *****
       * *                *******
      * * *              *********
     * * * *            ***********
    * * * * *          *************
```

```powershell
[root@localhost ~]# cat function_drawn_graph.sh
#!/bin/bash
# 功能：打印相关图形
# 版本：v0.2
# 作者：书记
# 联系：www.superopsmsb.com

graph_type=(三角形 梯形)
# 定制服务的操作提示功能函数
menu(){
    echo -e "\e[31m---------------查看可以绘制的图形---------------"
    echo -e " 1: 三角形  2: 梯形"
    echo -e "-------------------------------------------\033[0m"
}

# 定制打印左侧空格效果
left_bland_func(){
   layer_num="$1"
   sub_num="$2"
   for m in $(seq $[${layer_num}-${sub_num}]);do
        echo -n " "
   done
}

# 打印图形的核心内容部分
kernel_character_func(){
   char_num="$1"
   char_mark="$2"
   for j in $(seq ${char_num});do
       echo -n "${char_mark}"
   done
}
# 定制打印三角形的函数
triangle_func(){
    # 接收函数传参
    layer_num=$1
    # 定制打印n层的三角形
    for i in $(seq 1 ${layer_num});do
       # 定制打印三角形左侧的空格效果
       left_bland_func ${layer_num} $i
       # 定制打印三角形核心部分
       kernel_character_func $i "* "
       # 打印完每行就换行
       echo
   done
}
# 定制梯形的功能函数
trapezium_func(){
    print_num=${layer_num}
    for i in $(seq 1 ${layer_num});do
        # 定制打印梯形左侧的空格效果
        left_bland_func ${layer_num} $i
        # 定制打印梯形核心部分
        kernel_character_func $print_num "*"
        let print_num+=2
        echo
    done
}
# 选择服务操作类型
while true;do
    menu
    read -p "> 请输入要查看的资源信息类型: " graph_id
    case ${graph_type[$graph_id-1]} in
        "三角形")
            read -p "> 请输入三角形绘制的层数: " layer_num
            triangle_func ${layer_num}
            ;;
        "梯形")
            read -p "> 请输入梯形绘制的层数: " layer_num
            # 定制打印n层的梯形
            trapezium_func ${layer_num}
            ;;
        *)
            echo -e "\e[31m\t请输入正确的绘图类型id\e[0m";;
    esac
done
```

```powershell
脚本执行后效果
[root@localhost ~]# /bin/bash function_drawn_graph.sh
---------------查看可以绘制的图形---------------
 1: 三角形  2: 梯形
-------------------------------------------
> 请输入要查看的资源信息类型: 1
> 请输入三角形绘制的层数: 5
    *
   * *
  * * *
 * * * *
* * * * *
---------------查看可以绘制的图形---------------
 1: 三角形  2: 梯形
-------------------------------------------
> 请输入要查看的资源信息类型: 2
> 请输入梯形绘制的层数: 5
    *****
   *******
  *********
 ***********
*************
---------------查看可以绘制的图形---------------
 1: 三角形  2: 梯形
-------------------------------------------
> 请输入要查看的资源信息类型: ^C
[root@localhost ~]#
```

文件间调用实践2-拆分function_drawn_graph.sh脚本

```powershell
需求：拆分绘图脚本文件
	1 将脚本文件中的功能逻辑函数拆分出来以单独的文件存在
	2 脚本文件保留核心逻辑功能
```

```powershell
创建功能函数库文件目录
[root@localhost ~]# mkdir lib

查看库文件内容
[root@localhost ~]# cat lib/drawn_func.sh
#!/bin/bash
# 功能：打印相关图形功能函数库
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制服务的操作提示功能函数
menu(){
    echo -e "\e[31m---------------查看可以绘制的图形---------------"
    echo -e " 1: 三角形  2: 梯形"
    echo -e "-------------------------------------------\033[0m"
}

# 定制打印三角形左侧空格效果
left_bland_func(){
   layer_num="$1"
   sub_num="$2"
   for m in $(seq $[${layer_num}-${sub_num}]);do
        echo -n " "
   done
}

# 打印图形的核心内容部分
kernel_character_func(){
   char_num="$1"
   char_mark="$2"
   for j in $(seq ${char_num});do
       echo -n "${char_mark}"
   done
}
# 定制打印三角形的函数
triangle_func(){
    # 接收函数传参
    layer_num=$1
    # 定制打印n层的三角形
    for i in $(seq 1 ${layer_num});do
       # 定制打印三角形左侧的空格效果
       left_bland_func ${layer_num} $i
       # 定制打印三角形核心部分
       kernel_character_func $i "* "
       # 打印完每行就换行
       echo
   done
}
# 定制梯形的功能函数
trapezium_func(){
    print_num=${layer_num}
    for i in $(seq 1 ${layer_num});do
        # 定制打印梯形左侧的空格效果
        left_bland_func ${layer_num} $i
        # 定制打印梯形核心部分
        kernel_character_func $print_num "*"
        let print_num+=2
        echo
    done
}
```

```powershell
查看脚本框架文件
[root@localhost ~]# cat function_drawn_graph-lib.sh
#!/bin/bash
# 功能：打印相关图形
# 版本：v0.3
# 作者：书记
# 联系：www.superopsmsb.com

# 定制数组变量
graph_type=(三角形 梯形)

# 加载功能函数库文件
source ./lib/drawn_func.sh

# 选择服务操作类型
while true;do
    menu
    read -p "> 请输入要查看的资源信息类型: " graph_id
    case ${graph_type[$graph_id-1]} in
        "三角形")
            read -p "> 请输入三角形绘制的层数: " layer_num
            triangle_func ${layer_num}
            ;;
        "梯形")
            read -p "> 请输入梯形绘制的层数: " layer_num
            # 定制打印n层的梯形
            trapezium_func ${layer_num}
            ;;
        *)
            echo -e "\e[31m\t请输入正确的绘图类型id\e[0m";;
    esac
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash function_drawn_graph-lib.sh
---------------查看可以绘制的图形---------------
 1: 三角形  2: 梯形
-------------------------------------------
> 请输入要查看的资源信息类型: 1
> 请输入三角形绘制的层数: 5
    *
   * *
  * * *
 * * * *
* * * * *
---------------查看可以绘制的图形---------------
 1: 三角形  2: 梯形
-------------------------------------------
> 请输入要查看的资源信息类型: ^C
[root@localhost ~]#
```

**小结**

```

```



### 1.1.2 函数自调用

这一节，我们从 简单实践、案例实践、小结 三个方面来学习。

**简单实践**

简介

```powershell
	函数自调用也称函数递归，说白了就是 函数调用自身，实现数据递归能力的实现
```

实践-函数自调用

```powershell
需求: 实现数学阶乘的实践
	示例：5的阶乘
		 完整格式：5! = 1 * 2 * 3 * 4 * 5 = 120
		 简写格式：5! = 5 * (1 * 2 * 3 * 4) = 5 * 4!
	公式: x! = x * (x-1)!
```

```powershell
查看脚本内容
[root@localhost ~]# cat function_func_test1.sh
#!/bin/bash
# 功能：函数自调用实践

# 定制功能函数框架
self_func(){
    # 接收一个参数
    num=$1
    if [ ${num} -eq 1 ];then
        echo 1
    else
        # 定制一个临时本地变量，获取递减后的值
        local temp=$[ ${num} - 1 ]
        # 使用函数自调用方式获取内容
        local result=$(self_func $temp)
        # 格式化输出信息
        echo $[ $result * ${num} ]
    fi
}

# 检测逻辑效果
while true
do
    read -p "请输入一个您要查询的阶乘：" value
    result=$(self_func ${value})
    echo "${value}的阶乘是: ${result}"
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash function_func_test1.sh
请输入一个您要查询的阶乘：5
5的阶乘是: 120
请输入一个您要查询的阶乘：6
6的阶乘是: 720
请输入一个您要查询的阶乘：7
7的阶乘是: 5040
请输入一个您要查询的阶乘：^C
[root@localhost ~]#
```

**案例实践**

实践1-遍历制定目录下的所有文件

```powershell
准备工作
[root@localhost ~]# mkdir -p dir/{softs/{nginx,tomcat},logs,server/{java,python}}
[root@localhost ~]# touch dir/softs/{nginx/nginx.conf,tomcat/server.xml}
[root@localhost ~]# touch dir/logs/user{1..3}.log
[root@localhost ~]# touch dir/server/{java/java.jar,python/python.py}
[root@localhost ~]# tree dir/
dir/
├── logs
│   ├── user1.log
│   ├── user2.log
│   └── user3.log
├── server
│   ├── java
│   │   └── java.jar
│   └── python
│       └── python.py
└── softs
    ├── nginx
    │   └── nginx.conf
    └── tomcat
        └── server.xml

7 directories, 7 files
```

```powershell
[root@localhost ~]# cat function_scan_dir.sh
#!/bin/bash
# 功能：扫描目录下所有文件
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制功能函数框架
# 定制目录扫描功能函数
scan_dir() {
    # 定制临时局部功能变量
	# cur_dir 当前目录 workdir 工作目录
    local cur_dir workdir
	
	# 接收要检查的目录，进入到目录中
    workdir=$1
    cd ${workdir}
	
	# 对工作目录进行简单判断，根目录没有父目录
    if [ ${workdir} = "/" ]
    then
        cur_dir=""
    else
        cur_dir=$(pwd)
    fi
    
	# 查看当前目录下的文件列表
    for item in $(ls ${cur_dir})
    do
        # 如果文件是目录，则继续查看目录下文件
        if test -d ${item};then
            cd ${item}
            scandir ${cur_dir}/${item}
            cd ..
        # 如果文件是普通文件，则输出信息即可
        else
            echo ${cur_dir}/${item}
        fi
    done
}

# 检测逻辑效果
while true
do
    read -p "请输入一个您要查询的目录：" value
    if [ -d ${value} ]
    then
        scandir ${value}
    else
        echo "您输入的不是目录，请重新输入!"
    fi
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash function_scan_dir.sh
请输入一个您要查询的目录：dir
/root/dir/logs/user1.log
/root/dir/logs/user2.log
/root/dir/logs/user3.log
/root/dir/server/java/java.jar
/root/dir/server/python/python.py
/root/dir/softs/nginx/nginx.conf
/root/dir/softs/tomcat/server.xml
请输入一个您要查询的目录：^C
[root@localhost ~]#
结果显示：
	该脚本达到了我们需要的目录遍历效果
```

**小结**

```

```

### 1.1.3 综合练习

学习目标

这一节，我们从 案例解读、脚本实践、小结 三个方面来学习。

**案例解读**

案例需求

```powershell
使用shell脚本绘制一个杨辉三角
```

![image-20220627121352845](image/image-20220627121352845.png)

案例解读

![](image/杨辉三角示意图.gif)

```powershell
1、每行数字左右对称，从1开始变大，然后变小为1。 　　
2、第n行的数字个数为n个，所有数字和为 2^(n－1)。　　
3、每个数字等于上一行的左右临近两个数字之和。
4、第n行的数字依次为 1、1×(n-1)、1×(n-1)×(n-2)/2、1×(n-1)×(n-2)/2×(n-3)/3 ... 　　
...
```

**脚本实践**

脚本实践

```powershell
查看脚本内容
[root@localhost ~]# cat yanghui_triangle.sh
#!/bin/bash
# 功能：shell定制杨辉三角功能
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 判断输入是否为整数
check_int(){
    # 设定数据标识
    flag=true
    read -p "请输入一个数据值: " layer_num
    # 通过在循环内部进行数据操作判断是否是数据
    while $flag;do
      expr $layer_num + 0 > /dev/null 2>&1
      if [ $? -eq 0 ]
      then
          flag=false
      else
          read -p "请输入一个数据值: " layer_num
      fi
    done
}

# 定制一个数组
declare -a num_array

check_int
# 定制杨辉三角的行数变量 row
for(( row=1; row<=layer_num; row++ ))
do
   #打印杨辉三角的左侧空白
   for k in $(seq $[$layer_num - $row])
   do
       echo -n "    "
   done
   # 定制每行的数据获取
   for(( col=1; col<=row; col++ ))
   do
       # 第n行的第1个和第n行的第n个数字为1
       if [ $col -eq 1  -o $row -eq $col ]
       then
         # 设定每行的两个边界数字为1
         num_array[$row$col]=1
       else
         # 获取上一行的两个临近数据
         let row_up=row-1  # 获取上一行的数据
         let col_up=col-1  # 获取上一行的临近数据
         # 获取当前行的数据值为 上一行临近数据的数据和
         let num_array[$row$col]=${num_array[$row_up$col_up]}+${num_array[${row_up}${col}]}
       fi
   done
   # 打印每行的数据
   for(( col=1; col<=row; col++ ))
   do
       printf "%-8s" ${num_array[$row$col]}
   done
   echo
done
```

```powershell
脚本执行效果
[root@localhost ]# /bin/bash yanghui_triangle.sh
请输入一个数据值: 8
                            1
                        1       1
                    1       2       1
                1       3       3       1
            1       4       6       4       1
        1       5       10      10      5       1
    1       6       15      20      15      6       1
1       7       21      35      35      21      7       1
```

函数嵌套改造

```powershell
脚本改造后内容
[root@localhost ~]# cat yanghui_triangle.sh
#!/bin/bash
# 功能：shell定制杨辉三角功能
# 版本：v0.2
# 作者：书记
# 联系：www.superopsmsb.com

# 定制一个数组
declare -a num_array

# 判断输入是否为整数
check_int(){
    # 设定数据标识
    flag=true
    read -p "请输入一个数据值(q退出): " layer_num
    [ $layer_num == "q" ] && exit
    # 通过在循环内部进行数据操作判断是否是数据
    while $flag;do
      expr $layer_num + 0 > /dev/null 2>&1
      if [ $? -eq 0 ]
      then
          flag=false
      else
          read -p "请输入一个数据值: " layer_num
      fi
    done
}

# 定制左侧空格打印逻辑
left_blank_func(){
   # 获取参数值
   layer_num=$1
   row=$2
   # 空格打印逻辑
   for k in $(seq $[$layer_num - $row])
   do
       echo -n "    "
   done
}

# 获取每行的数据值
col_num_count(){
   # 获取参数值
   row=$1
   # 数据获取逻辑   
   for(( col=1; col<=row; col++ ))
   do
       # 第n行的第1个和第n行的第n个数字为1
       if [ $col -eq 1  -o $row -eq $col ]
       then
         # 设定每行的两个边界数字为1
         num_array[$row$col]=1
       else
         # 获取上一行的两个临近数据
         let row_up=row-1  # 获取上一行的数据
         let col_up=col-1  # 获取上一行的临近数据
         # 获取当前行的数据值为 上一行临近数据的数据和
         let num_array[$row$col]=${num_array[$row_up$col_up]}+${num_array[${row_up}${col}]}
       fi
   done
}
# 每行数据打印逻辑
col_num_print(){
   # 获取参数值
   row=$1
   # 数据打印逻辑
   for(( col=1; col<=row; col++ ))
   do
       printf "%-8s" ${num_array[$row$col]}
   done
   echo
}
while true
do
  check_int
  # 定制杨辉三角的行数变量 raw
  for(( row=1; row<=layer_num; row++ ))
  do
     #打印杨辉三角的左侧空白
     left_blank_func $layer_num $row
     # 获取数据的值
     col_num_count $row
     # 打印每行的所有数据
     col_num_print $row
  done
done
```

```powershell
[root@localhost ~]# /bin/bash yanghui_triangle.sh
请输入一个数据值(q退出): 5
                1
            1       1
        1       2       1
    1       3       3       1
1       4       6       4       1
请输入一个数据值(q退出): q
[root@localhost ~]#
```



**小结** 

```powershell

```



# 2 脚本自动化

## 2.1 脚本信号

### 2.1.1 信号基础

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

简介

```powershell
	当我们在构建一些更高级的脚本的时候，就会涉及到如何在linux系统上来更好的运行和控制它们，到目前为止，我们运行脚本的方式都是以实时的模式，在命令行来运行它。但是这并不是脚本唯一的运行方式，我们可以在linux系统中以更丰富的方式来运行它们，甚至在脚本遇到不可查的异常中止时候，以关闭linux终端界面的方式终止脚本。
	这些能力都是基于信号的机制来实现了
```

信号

```powershell
	linux使用信号与系统上运行的进程进行通信，想要对shell的脚本控制，只需要传递相关信号给shell脚本即可。
```

| 信号 | 值      | 描述           | 信号 | 值      | 描述                       |
| ---- | ------- | -------------- | ---- | ------- | -------------------------- |
| 1    | SIGHUP  | 挂起进程       | 15   | SIGTERM | 优雅的终止进程             |
| 2    | SIGINT  | 终止进程       | 17   | SIGSTOP | 无条件停止进程，不终止进程 |
| 3    | SIGQUIT | 停止进程       | 18   | SIGTSTP | 停止或暂停进程，不终止进程 |
| 9    | SIGKILL | 无条件终止进程 | 19   | SIGCONT | 继续运行停止的进程         |

```powershell
    默认情况下，bash shell会忽略收到的任何SIGQUIT(3)和SIGTERM(15)信号（正因为这样交互式shell才不会被意外终止）。但是bash shell会处理收到的SIGHUP(1)和SIGINT(2)信号。

    如果bash shell收到SIGHUP信号，它会退出。但在退出之前，它会将信号传给shell启动的所有进程（比如shell脚本）。通过SIGINT信号，可以中断shell，Linux内核停止将CPU的处理时间分配给shell，当这种情况发生时，shell会将SIGINT信号传给shell启动的所有进程。
```

生成信号

```powershell
终止进程：
	ctrl+c,
暂停进程：
	ctrl+z,停止的进程继续保留在内存中，并能从停止的位置继续运行
恢复进程:
	jobs查看运行任务，fg num 重新执行
杀死进程:
	kill -9 pid
```

**简单实践**

实践1-终止进程

```powershell
[root@localhost ~]# sleep 1000
^C
[root@localhost ~]#
```

实践2-挂起进程

```powershell
[root@localhost ~]# sleep 1000
^Z
[1]+  已停止               sleep 1000
[root@localhost ~]# ps aux  | grep sleep
root      39067  0.0  0.0 108052   360 pts/0    T    17:28   0:00 sleep 1000
```

实践3-恢复进程

```powershell
查看所有挂起进程
[root@localhost ~]# jobs
[1]+  已停止               sleep 1000

恢复挂起进程的id
[root@localhost ~]# fg 1
sleep 1000
^C
[root@localhost ~]#
```

实践4-杀死进程

```powershell
后台执行命令
[root@localhost ~]# sleep 1000 &
[1] 39074
[root@localhost ~]# ps aux  | grep sleep | grep -v grep
root      39074  0.0  0.0 108052   360 pts/0    S    17:30   0:00 sleep 1000

强制杀死进程
[root@localhost ~]# kill -9 39074
[root@localhost ~]#
[1]+  已杀死               sleep 1000
[root@localhost ~]# jobs
```

**小结**

```

```



### 2.1.2 信号捕捉

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

简介

```powershell
	shell编程提供了一种方式，让我们可以随意的控制脚本的运行状态，这就需要涉及到信号的捕获操作。在shell编程中，我们可以借助于 trap命令实现指定shell脚本要watch哪些linux信号并从shell中拦截。如果脚本收到了trap命令中列出的信号，它会阻止它被shell处理，而在本地处理。
```

trap命令格式

```powershell
命令格式
	trap commands signals
	
命令示例：
	# 收到指定信号后，执行自定义指令，而不会执行原操作
    trap '触发指令' 信号
     
    # 忽略信号的操作
    trap '' 信号

    # 恢复原信号的操作
    trap '-' 信号
    
    # 列出自定义信号操作
    trap -p
    
    # 当脚本退出时，执行finish函数
    trap finish EXIT
```



**简单实践**

实践1-捕获终止信号

```powershell
查看脚本内容
[root@localhost ~]# cat signal_trap_test1.sh
#!/bin/bash
# 功能：脚本信号捕捉

# 捕获关闭信号
trap "你敢关我，就不关，气死你" SIGINT SIGTERM
trap "走了，不送" EXIT

# 检测逻辑效果
while true
do
    read -p "请输入一个数据：" value
    echo "您输入的数据是: ${value}"
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash signal_trap_test1.sh
请输入一个数据：4
您输入的数据是: 4
请输入一个数据：^Csignal_trap_test1.sh:行1: 你敢关我，就不关，气死你: 未找到命令

您输入的数据是:
请输入一个数据：^Z
[1]+  已停止               /bin/bash signal_trap_test1.sh
[root@localhost ~]#
[root@localhost ~]# jobs
[1]+  已停止               /bin/bash signal_trap_test1.sh
[root@localhost ~]# fg 1
/bin/bash signal_trap_test1.sh

您输入的数据是:
请输入一个数据：3
您输入的数据是: 3
```

```powershell
另开一个终端，直接kill进程
[root@localhost ~]# ps aux | grep sign
root      39142  0.0  0.0 113288  1460 pts/0    S+   17:43   0:00 /bin/bash signal_trap_test1.sh
[root@localhost ~]# kill -9 39142

回到之前的终端查看效果
[root@localhost ~]# fg 1
/bin/bash signal_trap_test1.sh

您输入的数据是:
请输入一个数据：3
您输入的数据是: 3
请输入一个数据：已杀死
```

实践2-捕获正常退出

```powershell
查看脚本内容
[root@localhost ~]# cat signal_trap_test2.sh
#!/bin/bash
# 功能：脚本信号捕捉

# 捕获关闭信号
trap "echo '走了.不送'" EXIT

value="0"
# 检测逻辑效果
while true
do
    read -p "请输入一个数据：" value
    if [ ${value} == "9" ]
    then
        exit
    else
        echo "您输入的数据是: ${value}"
    fi
done
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash signal_trap_test2.sh
请输入一个数据：3
您输入的数据是: 3
请输入一个数据：9
走了.不送
```

实践3-移除捕获

```powershell
查看脚本内容
[root@localhost ~]# cat signal_trap_test3.sh
#!/bin/bash
# 功能：移除脚本信号捕捉

# 捕获关闭信号
trap "echo '走了.不送'" EXIT

i=1
# 检测逻辑效果
while [ $i -le 3 ]
do
    read -p "请输入一个数据：" value
    if [ ${value} == "9" ]
    then
        exit
    else
        echo "您输入的数据是: ${value}"
    fi
    let i+=1
done

# 移除捕获信号
trap - EXIT
echo "移除了捕获信号"
```

```powershell
脚本执行效果
[root@localhost ~]# /bin/bash signal_trap_test3.sh
请输入一个数据：9
走了.不送
[root@localhost ~]# /bin/bash signal_trap_test3.sh
请输入一个数据：1
您输入的数据是: 1
请输入一个数据：2
您输入的数据是: 2
请输入一个数据：3
您输入的数据是: 3
移除了捕获信号

结果显示：
	在没有走到信号捕获移除的时候，捕获仍然生效
```

**小结**

```

```



## 2.2 expect

### 2.2.1 expect基础

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

场景需求

```powershell
在日常工作中，经常会遇到各种重复性的"手工交互"操作，虽然没有什么技术含量，但是相当的重要。在实际的工作场景中，这种重复性的手工操作动作，非常的繁多，但是对于量大的工作来说，效率就非常低效了。所以我们就需要有一种工具，能够简化我们重复的手工操作。
```

expect简介

```powershell
expect是一个免费的编程工具，由DonLibes制作，作为Tcl脚本语言的一个扩展,它可以根据程序的提示，模拟标准输入提供给程序，从而实现自动的交互式任务，而无需人为干预,可以用作Unix系统中进行应用程序的自动化控制和测试的软件工具。

说白了，expect就是一套用来实现自动交互功能的软件。它主要应用于执行命令和程序时，系统以交互形式要求输入指定字符串，实现交互通信。在使用的过程中，主要是以脚本文件的样式来存在

官方网站：
	https://www.nist.gov/services-resources/software/expect
工具手册：
	man expect
```

软件部署

```powershell
安装软件
[root@localhost ~]# yum install expect -y

查看效果
[root@localhost ~]# expect -v
expect version 5.45
```

```powershell
进入专用的命令交互界面
[root@localhost ~]# expect
expect1.1>  ls
anaconda-ks.cfg
expect1.2> exit
```

```powershell
命令帮助
    -c:	执行脚本前先执行的命令，可多次使用，多个命令之间使用；隔开
    -d:	debug模式，可以在运行时输出一些诊断信息，与在脚本开始处使用exp_internal 1相似。
    -D:	启用交换调式器,可设一整数参数。
    -f:	从文件读取命令，仅用于使用#!时。如果文件名为"-"，则从stdin读取(使用"./-"从文件名为-的文件读取)。
    -i:	交互式输入命令，使用"exit"或"EOF"退出输入状态。
    --:	标示选项结束(如果你需要传递与expect选项相似的参数给脚本时)，可放到#!行:#!/usr/bin/expect --。
    -v:	显示expect版本信息
```



**简单实践**

语法解读

```powershell
	在进行expect脚本编写的时候，我们需要记住 -- expect 用的不是我们普通的shell或者python语法，它使用的是tlc语法。

	Tcl 全称是 Tool command Language。它是一个基于字符串的命令语言，基础结构和语法非常简单，易于学习和掌握。Tcl 语言是一个解释性语言，所谓解释性是指不象其他高级语言需要通过编译和联结，它象其他 shell 语言一样，直接对每条语句顺次解释执行。

	Tcl 数据类型简单。对 Tcl 来说，它要处理的数据只有一种——字符串。Tcl 将变量值以字符串的形式进行存储，不关心它的实际使用类型。
```

输出语法

```powershell
输出：tcl使用”puts"关键字来作为输出语句
样式：puts <-nonewline> string
属性解析：
	如果string中间有特殊字符，可以使用 {} 或者 "" 将其作为一个小组，共同输出
	-nonewline 代表输出结果的时候，不输出换行符
	put 和 puts 都可以在命令行使用，但是脚本中，最好用puts
```

```powershell
[root@localhost ~]# expect
expect1.1> puts hello				# 输出一个字符串内容
hello
expect1.2> puts "hello world"		# 输出包含特殊字符的字符串,不能用单引号
hello world
expect1.3> puts {hello world}		# 输出包含特殊字符的字符串
hello world
expect1.4> puts -nonewline "hello world"  # 输出内容的时候，不换行
hello worldexpect1.5>
```

脚本基础

```powershell
1 文件名后缀   
	.expect 作为标识符
2 文件首行，要指定命令的执行解释器 
	#!/usr/bin/expect
3 脚本文件的执行
	expect 脚本名
```

```powershell
脚本内容示例
[root@localhost ~]# cat expect_test.expect
#!/usr/bin/expect
# 设定一个环境变量
set var nihao
# 输出环境变量
puts $var

脚本执行效果
[root@localhost ~]# expect expect_test.expect
nihao
```

**小结**

```

```



### 2.2.2 语法实践

这一节，我们从 基础知识、简单实践、小结 三个方面来学习。

**基础知识**

赋值语法

```powershell
赋值：tcl 使用“set”关键字来定义参数，不必指定变量值的类型，因为变量值的类型仅一种——字符串
样式：set varName [value] 
注意：
	变量名是由 数字、下划线、字符组成，数字不能开头，大小写敏感。
```

```powershell
expect1.7> set a Hello			# 设定一个变量名a
Hello
expect1.8> put $a				# 使用$ 符号获取变量名的存储值
Hello
expect1.9> put "$a"				# 使用 "" 方式打印变量的值
Hello
expect1.10> put {$a}			# {} 有别于"" 的特点在于原字符输出
$a
expect1.11> set b $a			# 变量的传递
Hello
expect1.12> puts $b
Hello
```

替换语法

```powershell
替换(解析)：
	- $符号可以实现引用替换，用于引用变量名代替的参数值，但是TCL对嵌套的”$”不于理睬
	- [] 方括号“[]”完成命令替换。用“[]”将一条命令括起来，命令执行完成后，返回结果
```

```powershell
expect1.20> set b [set a 5]					# 相当于 set b $a,传递赋值
5
expect1.21> puts $b
5
expect1.22> set c [expr 5 * 10 ]			# expr是执行系统命令，将计算结果交给c
50
expect1.24> puts $c
50
```

注意事项

```powershell
变量的设定
expect1.13> set var value					# 设定一个普通变量名
value
expect1.14> puts $var						# 获取变量名的值
value

不支持嵌套$
expect1.15> set var1 $$value				# TCL不支持嵌套的$
can't read "value": no such variable
    while executing
"set var1 $$value"
expect1.16> set var1 $$var					# 由于$var 已经是变量，所以前面的$就无效了
$value
expect1.17> puts $var1
$value

原字符输出
expect1.18> set var2 {$var1}				# {} 代表原字符输出
$var1
expect1.19> puts $var2
$var1
```



**脚本实践**

内置变量

```powershell
对于tcl来说，它内部包含了大量的内置变量，可以让我们实现快速的功能操作。

常见的内置变量有：
	argc	指命令行参数的个数。
	argv	指包含命令行参数的列表。
	argv0	是指被解释的文件或由调用脚本的名称的文件名。
	env		用于表示是系统环境变量的内容，普通变量我们还是使用$即可
	tcl_version	返回Tcl解释器的最新版本，注意不是expect的版本号
```

内置参数实践

```powershell
[root@localhost ~]# cat expect_test1.expect
#!/usr/bin/expect
# 查看当前文件传递的参数数量
puts "当前文件传递的参数数量: $argc"

# 查看当前文件传递的参数
puts "当前文件传递的参数: $argv"

# 查看当前文件名称
puts "当前文件名称: $argv0"

# 获取变量值
puts "当前系统变量PATH的值是: $env(PATH)"
set key value
puts "普通变量 key 的值是: $key"

# 查看版本信息
puts "当前tcl版本信息: $tcl_version"
```

```powershell
脚本执行效果
[root@localhost ~]# expect expect_test1.expect
当前文件传递的参数数量: 0
当前文件传递的参数:
当前文件名称: expect_test1.expect
当前系统变量PATH的值是: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
普通变量 key 的值是: value
当前tcl版本信息: 8.5
```



**小结**

```

```



### 2.2.3 交互基础

这一节，我们从 脚本基础、简单实践、小结 三个方面来学习。

**脚本基础**

命令解释器

```powershell
命令解释器
#!/usr/bin/expect
#!/usr/bin/expect -f    从文件中读取自动化命令
#!/usr/bin/expect -     如果文件名为 - ，那么从终端输入中读取
#!/usr/bin/expect -i	交互式输入命令
#!/usr/bin/expect -- 	脚本传递的选项参数和expect选项相似的参数给脚本
注意：
	#!是对脚本的解释器程序路径，脚本的内容是由解释器解释的
	
注释信息
# 被注释的信息
```

常见符号

```powershell
{ }：
	作用1：保留所有字符原有的意思，而不做解释，类似于shell中的单引号
		样式：set var {"nihao hehehe"}
	作用2：代码块儿，但是两个 {} 边界必须在一起。
		正确样式：
		if {代码块1 } {
   			代码块2
			}
		错误示例：
		if {$count < 0}
        {
           break;
        }
	注意：
		无论什么时候，{}边界符号与其他内容都最好有空格隔开，尤其是边界外的内容
[]：
	作用：执行命令，类似shell中的 ``(反引号)或者 $()
	样式：set count [expr $count - 1 ]
	
注意：
	在expect 中，没有小括号的概念和应用
```

常用命令

```powershell
set 		设定环境变量
				格式：set 变量名 变量值
				样式：set host "192.168.8.12"

				
spawn 		启动新的进程，模拟手工在命令行启动服务
				格式：spawn 手工执行命令
				样式：spawn ssh python@$host

expect 		接收一个新进程的反馈信息，我们根据进程的反馈，再发送对应的交互命令
				格式：expect "交互界面用户输入处的关键字"
				样式：expect "*password*"
				
send 		接收一个字符串参数，并将该参数发送到新进程。
				格式：send "用户输入的信息"	
				样式：send "$password\r"
				
interact 	退出自动化交互界面，进入用户交互状态，如果需要用户交互的话，这条命令必须在最后一行
				格式：interact
				样式：interact
				
其他命令
	exit		退出expect脚本
	expect eof	expect执行内容的结束标识符，退出当前脚本，与interact只能存在一个
	puts		输出变量的信息，相当于linux命令中的echo
	wait		退出程序后，等待时间，回收僵尸进程
	disconnect	断开一个进程连接，但让它在后台继续运行。
	exp_continue 	expect获取期望后，还会有另外的期望，那么我们就把多个期望连续执行
```



**简单实践**

实践1-简单的登录交互脚本

```powershell
查看脚本内容
[root@localhost ~]# cat login_test.expect
#!/usr/bin/expect

# 1 设定环境变量
set username python

# 2 发起远程登录请求
spawn ssh $username@10.0.0.12

# 3 识别用户输入的位置关键字
expect "yes/no"

# 4 发送正确的信息
send "yes\r"

# 5 识别密码关键字，并传递密码信息
send "\r"
expect "password:"
send "123456\r"

# 6 切换回用户交互界面
interact

注意:
	由于password前面会涉及到一次Enter操作，所以在password匹配前，输入一次 \r
```

```powershell
清理历史记录
[root@localhost ~]# rm -f .ssh/know_hosts

执行脚本内容
[root@localhost ~]# expect login_test.expect
spawn ssh python@10.0.0.12
The authenticity of host '10.0.0.12 (10.0.0.12)' can't be established.
ECDSA key fingerprint is SHA256:XUJsgk4cTORxdcswxIKBGFgrrqFQzpHmKnRRV6ABMk4.
ECDSA key fingerprint is MD5:71:74:46:50:3f:40:4e:af:ad:d3:0c:de:2c:fc:30:c0.
Are you sure you want to continue connecting (yes/no)? yes

Warning: Permanently added '10.0.0.12' (ECDSA) to the list of known hosts.
python@10.0.0.12's password:
[python@localhost ~]$ id
uid=1000(python) gid=1000(python) 组=1000(python)
```

实践2-脚本结合

```powershell
expect 除了使用专用的expect脚本来实现特定功能之外，它还可以与其他脚本嵌套在一起进行使用。最常用的结合方式就是 shell结合。

在于shell结合使用的时候，无非就是将expect的执行命令使用 <<-EOF  。。。 EOF 包装在一起即可。
样式：
/usr/bin/expect<<-EOF
spawn ...
...
expect eof 
EOF

注意：
	由于expect在shell中是作为一个子部分而存在的，所以，一般情况下，expect结束的时候，使用eof命令表示expect的内容到此结束
```

```powershell
查看脚本内容
[root@localhost ~]# cat expect_auto_login.sh
#!/bin/bash
# 功能：shell自动登录测试
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制普通变量
host="$1"
username="$2"
password="$3"

/usr/bin/expect <<-EOF
# 发出连接进程
spawn ssh ${username}@${host}

# - 正常登陆
expect {
    "yes/no*" {  send "yes\n"; exp_continue  }
    "password:" {send "${password}\n";}
}
puts "测试完毕!!!"
expect eof
EOF
```

```powershell
脚本测试效果
[root@localhost ~]# /bin/bash expect_auto_login.sh 10.0.0.12 python 123456
spawn ssh python@10.0.0.12
python@10.0.0.12's password: 测试完毕!!!

[python@localhost ~]$ exit
[root@localhost ~]#
```



**小结**

```

```



### 2.2.4 综合案例

这一节，我们从 自动分区、用户实践、小结 三个方面来学习。

**基础知识**

简介

```powershell
	当系统配置完毕后，我们可以采用fdisk命令对额外的磁盘进行磁盘分区。而expect可以实现这个效果。
```

手工演示

```powershell
[root@localhost ~]# fdisk /dev/sdc
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

Device does not contain a recognized partition table
使用磁盘标识符 0x17fc4c8a 创建新的 DOS 磁盘标签。

命令(输入 m 获取帮助)：n					# 输入n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p				 # 输入p
分区号 (1-4，默认 1)：					# 输入 Enter
起始 扇区 (2048-41943039，默认为 2048)：# 输入 Enter
将使用默认值 2048
Last 扇区, +扇区 or +size{K,M,G} (2048-41943039，默认为 41943039)：# 输入Enter
将使用默认值 41943039
分区 1 已设置为 Linux 类型，大小设为 20 GiB

命令(输入 m 获取帮助)：wq				# 输入wq
The partition table has been altered!

Calling ioctl() to re-read partition table.
正在同步磁盘。
[root@localhost ~]# mkfs -t ext4 /dev/sdc
mke2fs 1.42.9 (28-Dec-2013)
/dev/sdc is entire device, not just one partition!
无论如何也要继续? (y,n) y
文件系统标签=
OS type: Linux
块大小=4096 (log=2)
分块大小=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
1310720 inodes, 5242880 blocks
262144 blocks (5.00%) reserved for the super user
第一个数据块=0
Maximum filesystem blocks=2153775104
160 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000

Allocating group tables: 完成
正在写入inode表: 完成
Creating journal (32768 blocks): 完成
Writing superblocks and filesystem accounting information: 完成

[root@localhost ~]# mkdir /haha
[root@localhost ~]# mount /dev/sdc /haha
[root@localhost ~]# echo nihao > /haha/h.txt
[root@localhost ~]# ls /haha
h.txt  lost+found
```

脚本实践

```powershell
查看脚本内容
[root@localhost ~]# cat expect_auto_partition.sh
#!/bin/bash
# 功能：shell自动磁盘分区格式化测试
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制普通变量
mount_dir='/disk_check'

# 检测基本环境
[ -f /usr/bin/expect ] && echo "expect 环境正常" || ("expect 环境异常" && exit)

# 查看磁盘列表
fdisk -l | grep "磁盘 /dev/s"

# 定制磁盘分区操作
read -p "请输入需要挂载得硬盘路径: " disk_name
	
# expect自动分区操作
/usr/bin/expect << EOF
set timeout 30
spawn bash -c "fdisk ${disk_name}"
expect "命令*" {send "n\r"} 
expect "*default p*" {send "p\r"}
expect "*默认 1*" {send "\r"}
expect "起始 扇区*" {send "\r"}
expect "Last 扇区*" {send "\r"}
expect "命令*" {send "wq\r"} 
expect eof
interact	
EOF

# expect自动格式化操作
read -p "请输入硬盘的类型: " disk_type
/usr/bin/expect << EOF
set timeout 30
spawn bash -c "mkfs -t ${disk_type} ${disk_name}"
expect "*y,n*" {send "y\r"} 
expect eof
interact	
EOF

# 磁盘挂载测试
[ -d ${mount_dir} ] && rm -rf ${mount_dir} 
mkdir ${mount_dir}
mount ${disk_name} ${mount_dir}
echo disk_check > ${mount_dir}/check.txt
[ -f ${mount_dir}/check.txt ] && echo "${mount_dir} 挂载成功" || (echo "${mount_dir} 挂载失败" && exit)
umount ${mount_dir}
[ ! -f ${mount_dir}/check.txt ] && echo "${mount_dir} 卸载成功" || (echo "${mount_dir} 卸载失败" && exit)
rm -rf ${mount_dir}
```

**创建用户实践**

案例需求

```powershell
	借助于expect实现在特定的主机上批量创建用户
```

脚本实践

```powershell
查看脚本内容
[root@localhost ~]# cat expect_auto_register.sh
#!/bin/bash
# 功能：shell自动远程主机创建用户测试
# 版本：v0.1
# 作者：书记
# 联系：www.superopsmsb.com

# 定制初始变量
login_user='root'
login_pass='123456'
host_file='ip.txt'
new_user='shuji-1'
new_pass='123456'

# 批量创建用户
cat ${host_file} | while read ip
do
    expect <<-EOF
        set timeout 30
        spawn ssh $login_user@$ip
        expect {
            "yes/no" { send "yes\n";exp_continue }
            "password" { send "${login_pass}\n" }
        }

        expect "]#" { send "useradd ${new_user}\n" }
        expect "]#" { send "echo ${new_pass} |passwd --stdin ${new_user}\n" }
        expect "]#" { send "who\n" }
        expect "]#" { send "exit\n" }
        expect eof
	EOF
done
```

```powershell
脚本执行后效果
[root@localhost ~]# /bin/bash expect_auto_register.sh
spawn ssh root@10.0.0.12
root@10.0.0.12's password:
[root@localhost ~]# useradd shuji-1
[root@localhost ~]# echo 123456 |passwd --stdin shuji-1
更改用户 shuji-1 的密码 。
passwd：所有的身份验证令牌已经成功更新。
[root@localhost ~]# who
root     pts/1        2022-06-26 08:47 (10.0.0.12)
root     pts/2        2022-06-26 07:15 (10.0.0.1)
[root@localhost ~]# exit
登出
Connection to 10.0.0.12 closed.
spawn ssh root@10.0.0.13
The authenticity of host '10.0.0.13 (10.0.0.13)' can't be established.
ECDSA key fingerprint is SHA256:XUJsgk4cTORxdcswxIKBGFgrrqFQzpHmKnRRV6ABMk4.
ECDSA key fingerprint is MD5:71:74:46:50:3f:40:4e:af:ad:d3:0c:de:2c:fc:30:c0.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.0.0.13' (ECDSA) to the list of known hosts.
root@10.0.0.13's password:
Last login: Sun Jun 26 07:16:20 2022 from 10.0.0.1
[root@localhost ~]# useradd shuji-1
[root@localhost ~]# echo 123456 |passwd --stdin shuji-1
更改用户 shuji-1 的密码 。
passwd：所有的身份验证令牌已经成功更新。
[root@localhost ~]# who
root     tty1         2022-06-25 23:57
root     pts/0        2022-06-26 08:47 (10.0.0.12)
root     pts/1        2022-06-26 07:16 (10.0.0.1)
[root@localhost ~]# exit
登出
Connection to 10.0.0.13 closed.
```

```powershell
校验用户创建
[root@localhost ~]# id shuji-1
uid=1001(shuji-1) gid=1001(shuji-1) 组=1001(shuji-1)
[root@localhost ~]# ssh root@10.0.0.13 id shuji-1
root@10.0.0.13's password:
uid=1001(shuji-1) gid=1001(shuji-1) 组=1001(shuji-1)
```



**小结**

```

```

# 3 正则表达式

## 3.1 基础实践

### 3.1.1 基础知识

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

需求

```powershell
	我们之前的一些操作，很大程度上都是基于特定的关键字来进行实践的，尤其是面对一些灵活的场景，我们因为过于限定一些关键字，导致灵活性上表现比较差。在shell中，它其实有一种机制，能够让我们结合特定的符号，实现非常灵活的内容操作。
	这就是正则表达式，正则表达式是用于描述字符排列和匹配模式的一种语法规则，通过它我们可以实现字符串的模式分割、匹配、查找及替换等操作。从而在各种业务逻辑的基础上，扩充数据层面的匹配，让脚本的适用性更大。
```

简介

```powershell
	REGEXP 全称Regular Expressions，它是我们通过一些字符所定义的’linux程序用来筛选文本的模式模板。linux相关程序(比如sed、awk、grep、等)在输入数据的时候，使用正则表达式对数据内容进行匹配，将匹配成功的信息返回给我们。
	正则表达式被非常多的程序和开发语言支持：你能够想象到的编程语言，linux几乎所有编辑信息、查看信息的命令 等。
```

基本逻辑

![image-20220617192509857](image/image-20220617192509857.png)

```powershell
	正则表达式模式，可以接收大量的数据来源，然后借助通配符、元字符、关键字等来标识数据流中的信息，将匹配成功的数据留存下来，为我们使用。
```

表达式分类

```powershell
基本正则表达式：
	BRE Basic Regular Expressions
	- 借助于基本的属性信息实现内容的精准匹配
扩展正则表达式：
	ERE Extended Regular Expressions
	- 借助于扩展符号的能力，实现更大范围的信息匹配
```

**简单实践**

通配符和正则

```powershell
1 正则表达式用来在文件中匹配符合条件的字符串，主要是目的是包含匹配。
	- grep、awk、sed 等命令可以支持正则表达式。
2 通配符用来匹配符合条件的文件名，通配符是完全匹配。
	- ls、find、cp 之类命令不支持正则表达式，可以借助于shell通配符来进行匹配。
		 .：匹配任意一个字符
         *：匹配任意内容
         ?：匹配任意一个内容
        []：匹配中括号中的一个字符
```

通配符实践

```powershell
创建基本环境
[root@localhost ~]# touch user-{1..3}.sh  {a..d}.log
[root@localhost ~]# ls
a.log  b.log  d.log c.log 
user-1.sh  user-2.sh  user-3.sh

*匹配任意字符
[root@localhost ~]# ls *.log
a.log  b.log  c.log  d.log
[root@localhost ~]# ls u*
user-1.sh  user-2.sh  user-3.sh

?匹配一个字符
[root@localhost ~]# ls user?3*
user-3.sh

[]匹配中括号中的一个字符
[root@localhost ~]# ls user-[13]*
user-1.sh  user-3.sh
```





**小结**

```

```



### 3.1.2 字符匹配

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	正则存在的根本就是对数据的匹配，而数据基本上都是有字符组成的，而正则表达式提供了非常多的字符匹配表达式，常见的表达式模式有：
```

```powershell
单字符匹配
	.   匹配任意单个字符，当然包括汉字的匹配
	[]  匹配指定范围内的任意单个字符
		- 示例：[shuji]、[0-9]、[a-z]、[a-zA-Z]
	[^] 匹配指定范围外的任意单个字符
		- 示例：[^shuji] 
	 |  匹配管道符左侧或者右侧的内容
```

**简单实践**

准备配置文件

```powershell
[root@localhost ~]# cat keepalived.conf
! Configuration File for keepalived

global_defs {
   router_id kpmaster
}

vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 50
    nopreempt
    priority 100
    advert_int 1
    virtual_ipaddress {
        192.168.8.100
    }
}
```

实践1-单字符过滤

```powershell
.过滤单个字符
[root@localhost ~]# grep 'st..e' keepalived.conf
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
[root@localhost ~]# grep 'ens..' keepalived.conf
    interface ens33
```

实践2-范围单字符过滤

```powershell
[] 过滤范围字符
[root@localhost ~]# grep 'i[a-z]t' keepalived.conf
    interface ens33
    virtual_router_id 50
    advert_int 1
    virtual_ipaddress {
[root@localhost ~]# grep 'i[a-n]t' keepalived.conf
    interface ens33
    advert_int 1
[root@localhost ~]# grep '[b-c]' keepalived.conf
global_defs {
vrrp_instance VI_1 {
    interface ens33
[root@localhost ~]# egrep '[x-z]' keepalived.conf
    priority 100
```

实践3-反向单字符过滤

```powershell
只要包括的内容，都不要显示
[root@localhost ~]# grep '[^a-Z_ }{0-5]' keepalived.conf
! Configuration File for keepalived
        192.168.8.100
```

实践4-过滤特定的字符范围

```powershell
[root@localhost ~]# egrep 'state|priority' keepalived.conf
    state MASTER
    priority 100
    
[root@localhost ~]# egrep 'st|pri' keepalived.conf
   router_id kpmaster
vrrp_instance VI_1 {
    state MASTER
    priority 100
```

**小结**

```

```



### 3.1.3 锚定匹配

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	所谓的锚定匹配，主要是在字符匹配的前提下，增加了字符位置的匹配
```

```powershell
常见符号
    ^ 					行首锚定, 用于模式的最左侧
    $ 					行尾锚定，用于模式的最右侧
    ^PATTERN$ 			用于模式匹配整行
    ^$ 					空行
    ^[[:space:]]*$ 		空白行
    \< 或 \b   		   词首锚定，用于单词模式的左侧
    \> 或 \b        	   词尾锚定，用于单词模式的右侧
    \<PATTERN\>     	匹配整个单词
注意: 
	单词是由字母,数字,下划线组成
```

**简单实践**

准备实践文件

```powershell
[root@localhost ~]# cat nginx.conf
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
```

实践1-行首位地址匹配

```powershell
行首位置匹配
[root@localhost ~]# grep '^wor' nginx.conf
worker_processes  1;

行尾位置匹配
[root@localhost ~]# grep 'st;$' nginx.conf
        server_name  localhost;
```

实践2-关键字匹配

```powershell
关键字符串匹配
[root@localhost ~]# grep '^http {$' nginx.conf
http {
[root@localhost ~]# grep '^w.*;$' nginx.conf
worker_processes  1;
```

实践3-空行匹配

```powershell
空行匹配
[root@localhost ~]# grep '^$' nginx.conf


[root@localhost ~]# grep  '^[[:space:]]*$' nginx.conf


# 反向过滤空行
[root@localhost ~]# grep -v '^$' nginx.conf
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
```

实践4-单词匹配

```powershell
单词首部匹配
[root@localhost ~]# grep '\bloca' nginx.conf
        server_name  localhost;
        location / {
[root@localhost ~]# grep '\<loca' nginx.conf
        server_name  localhost;
        location / {
        
单词尾部匹配
[root@localhost ~]# grep 'ion\>' nginx.conf
        location / {
[root@localhost ~]# grep 'ion\b' nginx.conf
        location / {
        
单词内容匹配
[root@localhost ~]# grep '\<index\>' nginx.conf
            index  index.html index.htm;
[root@localhost ~]# grep '\<sendfile\>' nginx.conf
    sendfile        on;
```



**小结**

```

```



### 3.1.4 分组符号

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	当我们使用正则模式匹配到的内容有很多项的时候，默认会全部输出。如果我们仅仅需要特定顺序的一个匹配内容的话，就用到我们这一节的知识点 -- 分组。
```

```powershell
所谓的分组，其实指的是将我们正则匹配到的内容放到一个()里面
    - 每一个匹配的内容都会在一个独立的()范围中
    - 按照匹配的先后顺序，为每个()划分编号
    - 第一个()里的内容，用 \1代替，第二个()里的内容，用\2代替，依次类推
    - \0 代表正则表达式匹配到的所有内容
注意：
	() 范围中支持|等字符匹配内容。从而匹配更多范围的信息
	关于()信息的分组提取依赖于文件的编辑工具，我们可以借助于 sed、awk功能来实现
	提示: sed -r 's/原内容/修改后内容/'
```

```powershell
示例:
	(M|m)any  	可以标识 Many 或者 many
```

**简单实践**

准备配置文件

```powershell
准备zookeeper的配置文件
[root@localhost ~]# cat zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/server/zookeeper/data
dataLogDir=/data/server/zookeeper/logs
clientPort=2181
server.1=10.0.0.12:2182:2183
server.2=10.0.0.13:2182:2183
server.3=10.0.0.14:2182:2183:observer
4lw.commands.whitelist=stat, ruok, conf, isro
```

实践1-分组信息匹配实践

```powershell
获取zookeeper的集群相关信息
[root@localhost ~]# egrep  '(server.[0-9])' zoo.cfg
server.1=10.0.0.12:2182:2183
server.2=10.0.0.13:2182:2183
server.3=10.0.0.14:2182:2183:observer

[root@localhost ~]# egrep  '(init|sync)Limit' zoo.cfg
initLimit=10
syncLimit=5
```

实践2-信息的提取

```powershell
借助于sed的编辑文件功能，实现特定信息的提取
[root@localhost ~]# grep server.1 zoo.cfg  | sed -r "s/(.*)=(.*):(.*):(.*)/\1/"
server.1
[root@localhost ~]# grep server.1 zoo.cfg  | sed -r "s/(.*)=(.*):(.*):(.*)/\2/"
10.0.0.12
[root@localhost ~]# grep server.1 zoo.cfg  | sed -r "s/(.*)=(.*):(.*):(.*)/\3/"
2182
[root@localhost ~]# grep server.1 zoo.cfg  | sed -r "s/(.*)=(.*):(.*):(.*)/\4/"
2183
```



**小结**

```

```



## 3.2 进阶知识

### 3.2.1 限定符号

学习目标

这一节，我们从 基础知识、简单实践、小结 三个方面来学习

**基础知识**

简介

```powershell
	所谓的限定符号，主要指的是，我们通过正则表达式匹配到内容后，前面内容重复的次数，常见的服号如下：
```

```powershell
常见符号
	* 		匹配前面的字符任意次，包括0次，贪婪模式：尽可能长的匹配
    .* 		任意长度的任意字符
    ? 		匹配其前面的字符出现0次或1次,即:可有可无
    + 		匹配其前面的字符出现最少1次,即:肯定有且 >=1 次
    {m} 	匹配前面的字符m次
    {m,n} 	匹配前面的字符至少m次，至多n次
    {,n}  	匹配前面的字符至多n次,<=n
    {n,}  	匹配前面的字符至少n次
```

**简单实践**

准备文件

```powershell
[root@localhost ~]# cat file.txt
ac
abbcd
abbbce
abbbbbc
abcf
```

实践1-精确匹配

```powershell
精确匹配 以a开头 c结尾 中间是有b或者没有b 长度不限的字符串
[root@localhost ~]# egrep "^ab*c$" file.txt
ac
abbbbbc

精确匹配 以a开头 c结尾 中间只出现一次b或者没有b的字符串
[root@localhost ~]# egrep "^ab?c$" file.txt
ac

精确匹配 以a开头 中间是有b且至少出现一次 长度不限的字符串
[root@localhost ~]# egrep "^ab+" file.txt
abbcd
abbbce
abbbbbc
abcf

精确匹配 以a开头 中间是有b且至少出现两次最多出现四次 长度不限的字符串
[root@localhost ~]# egrep "^ab{2,4}" file.txt
abbcd
abbbce
abbbbbc

精确匹配 以a开头 中间是有b且正好出现三次的字符串
[root@localhost ~]# egrep "^ab{3}" file.txt
abbbce
abbbbbc

精确匹配 以a开头 中间是有b且至少出现两次的字符串
[root@localhost ~]# egrep "^ab{2,}" file.txt
abbcd
abbbce
abbbbbc
```

**小结**

```

```

