- Time：2023-06-13 16:22
- Label： #cpp #c #编译原理

## Abstract

- 简要介绍编译基础
- 他是怎么做到对各种快捷键和命令如此熟练的

## Content

```
gcc a.cpp
clang++ a.cpp
```

```cpp
int main(){

	return 0;
}
```

编译错误有：

1. 词法错误
2. 语法错误
3. 语义错误（这涉及到编译原理的部分）

链接：  
出现背景：多文件  
好处：降低复杂度

![[Snipaste/Pasted image 20230613163820.png]]

编译成一个个 .o 的文件，有缺陷的中间文件，可以忍受符号的缺失。

```shell
gcc -c b.cpp
gcc b.o c.o
> a.out


```

不推荐使用 `ld` 去链接 (但问题是，你可能只能用 `ld` 去链接了)

```shell
readelf -d a.out
```

- 所以建议编译起来链接
- 汇编一个源文件，但是不会去 link

### 常见编译错误大赏

#### 头文件缺失

即便你创建了 a.h，也可能找不到头文件，因为不会到任何路径下去找。因为编译的指令是不同的，你可能需要修改编译指令，指定你的 `a.h` 文件在哪里。

为什么需要一个 APP 呢？

![[Snipaste/Pasted image 20230613165033.png]]

一般不推荐这么做

![[Snipaste/Pasted image 20230613165116.png]]

![[Snipaste/Pasted image 20230613165145.png]]

- error 编译报错
- warning 警告
- expected 语法错误
- ld 连接器，这里是一个链接器的问题

![[Snipaste/Pasted image 20230613165847.png]]

![[Snipaste/Pasted image 20230613170044.png]]

- 永假问题，逻辑错误。有些编译器是可以检测出来的逻辑错误。

![[Snipaste/Pasted image 20230613170157.png]]

如果指针是空的，那么它就是不可写的，这是 C 的一个约定。

### 三种常见的编译目标

1. 可执行文件
2. 动态链接库
3. 静态链接库

#### 可执行文件

1. 必须有 main 函数
2. 所有符号都得找到

#### 动态链接库

- 所有符号都得找得到
- 可以导出符号作为拼图突出部：可以导出一些函数
- 运行时共享内存映射

![[Snipaste/Pasted image 20230613170841.png]]

- `-f` feature

![[Snipaste/Pasted image 20230613171023.png]]

- 是的已经没有问题了，

![[Snipaste/Pasted image 20230613171305.png]]

- gcc 编译之后找到

![[Snipaste/Pasted image 20230613171519.png]]

#### 静态链接库

1. 大号中间文件
2. 可以缺少符号
3. 编译时代码附加在被依赖的目标上

![[Snipaste/Pasted image 20230613171651.png]]

### 静态链接详解

## Reference
