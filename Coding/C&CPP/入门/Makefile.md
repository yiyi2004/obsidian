- Time：2023-06-13 17:17
- Label： #c #makefile

## Abstract

- 简要概述 Makefile 内容

## Content

`-c` 只编译不链接

### 前言

首先，Make 只是一个过渡性的工具，而 CMake 才是最终的构建工具。因此，在使用 CMake 之前，有必要对 Make 有一定的了解。这样，在使用 CMake 时，才能更加得心应手。

### 1.准备文件

新建，项目文件夹 `hello`，及文件 `main.cpp`，`factorial.cpp`，`printhello.cpp`，`functions.h`。

hello 目录的结构如下：

```
hello/
├──main.cpp
├──factorial.cpp
├──printhello.cpp
└──functions.h
```

main.cpp

```c
#define _FUNCTIONS_H_

#include <iostream>
#include "functions.h"
using namespace std;

int main()
{
	printhello();
	
	cout << "This is main:" << endl;
	cout << "The factorial of 5 is:" << factorial(5) << endl;
	return 0;
}
```

printhello.cpp

```c
#include <iostream>
#include "functions.h"
using namespace std;

void printhello()
{
	int i;
	cout << "Hello World!" << endl;
}
```

factorial.cpp

```c
#include "functions.h"

int factorial(int n)
{
	if (n==1)
		return 1;
	else
		return n * factorial(n-1);
}
```

function.h

```c
#ifdef _FUNCTIONS_H_
#define _FUNCTIONS_H_
void printhello();
int factorial(int n);
#endif
```

### 2.编译

使用 g++ 命令直接编译、运行

```bash
g++ main.cpp factorial.cpp printhello.cpp -o main
./main
```

这种方法适用于小型项目。对于大型项目来说，此法编译效率低，这时候 make 工具就派上用场了。

### 3.make 工具

#### 3.1makefile 三要素

![](https://maxwell-lx.vip/content/images/2023/04/image-1-1.png)

makefile 三要素

语法：  
[目标]: [依赖]  
(tab 制表符)[命令]

- 目标：规则的目标，可以是 Object File（一般称它为中间文件），也可以是可执行文件，还可以是一个标签；
- 依赖：是我们的依赖文件，要生成 targets 需要的文件或者是另一个目标。可以是多个，也可以是没有；
- 命令：make 需要执行的命令（任意的 shell 命令）。可以有多条命令，每一条命令占一行。

#### 3.2make 工作原理

![](https://maxwell-lx.vip/content/images/2023/04/pSeQGpF-4.png)

make 工作原理

### 4 实战

#### 4.1version-1

```make
hello: main.cpp printhello.cpp factorial.cpp
	g++ -o hello main.cpp printhello.cpp factorial.cpp
```

#### 4.2version-2

```make
CXX = g++
TARGET = hello 
OBJ = main.o printhello.o factorial.o

$(TARGET): $(OBJ)
	$(CXX) -o $(TARGET) $(OBJ)

main.o: main.cpp
	$(CXX) -c main.cpp

printhello.o: printhello.cpp
	$(CXX) -c printhello.cpp

factorial.o: factorial.cpp
	$(CXX) -c factorial.cpp
```

#### 4.3version-3

```make
CXX = g++
TARGET = hello 
OBJ = main.o printhello.o factorial.o

CXXFLAGS = -c -Wall

$(TARGET): $(OBJ)
	$(CXX) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f *.o $(TARGET)
```

#### 4.4version-4

```make
CXX = g++
TARGET = hello 
SRC = $(wildcard *.cpp)
OBJ = $(patsubst %.cpp, %.o, $(SRC))

CXXFLAGS = -c -Wall

$(TARGET): $(OBJ)
	$(CXX) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f *.o $(TARGET)
```

#### 常见的自动化变量解析符

![[Snipaste/Pasted image 20230613181808.png]]

.PHONY，makefile 的特殊变量，用于生成“伪目标”。make 中的“目标”通常指文件，但有时功能和文件名会重叠。以 clean 为例，我们需要 clean 来清除全部的中间文件，但同时我们不需要真的生成一个名为 "clean" 文件，所以当目标文件夹存在一个“clean”文件时，“clean”功能就不会被执行，所以需要一个 " 伪目标 " 去执行“clean”功能。

wildcard，用于防止通配符解析失败。使变量定义时，括号里的通配符仍然生效。

patsubst，用于防止替换文件解析失效。替换文件后缀。

## Reference

- [make的基础用法 (maxwell-lx.vip)](https://maxwell-lx.vip/basic-usage-make/)
- [Makefile 20分钟入门，简简单单，展示如何使用Makefile管理和编译C++代码_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV188411L7d2/?spm_id_from=333.788.recommend_more_video.0&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [快乐的学习，Makefile语法详细总结及示例解析](https://blog.csdn.net/Luckiers/article/details/124765087?ref=maxwell-lx.vip)
- [B站 于仕琪，Makefile 20分钟入门](https://www.bilibili.com/video/BV188411L7d2/?ref=maxwell-lx.vip)
