- Spring 家族
- Spring 发展史
- Spring 全家桶

学习哪些？
1. Sping Framework 简化开发
2. Spring Boot 加速开发
3. Spring Cloud 分布式开发
4. Spring Data
5. Srping Session

- 约定大于配置

# 核心容器

## Spring Framework

![[Pasted image 20221109180607.png]]

系统架构图，上层依赖于下层。

- Spring 是用来管对象的技术
- AOP：面向切面编程，变成的思想。
- Aspect：对 AOP 思想进行实现
- Data Access：数据访问

![[Pasted image 20221109180938.png]]

## 核心概念
- IoC 控制反转，我给你一个对象，哇哦。

![[Pasted image 20221109191941.png]]

![[Pasted image 20221109192117.png]]

![[Pasted image 20221109192417.png]]

![[Pasted image 20221109192508.png]]

## IoC 入门案例

![[Pasted image 20221109193516.png]]

![[Pasted image 20221109193536.png]]
- 项目结构

![[Pasted image 20221109193647.png]]

![[Pasted image 20221109193721.png]]
 
- 导入坐标
- 创建 bean
- 新的 App2
	- 创建 IoC 容器
	- 加载配置文件
	- 获取 bean ctx.getBean("id")

![[Pasted image 20221109194254.png]]

- 代码的修改直接改变配置文件的路径即可？这就是面向接口变成的好处。

![[Pasted image 20221109194515.png]]

![[Pasted image 20221109194526.png]]

![[Pasted image 20221109194536.png]]

![[Pasted image 20221109194601.png]]

- applicationContext
- 有新的方式

## DI 入门案例

![[Pasted image 20221109194823.png]]

![[Pasted image 20221109195100.png]]

![[Pasted image 20221109195124.png]]

![[Pasted image 20221109195158.png]]

## bean
### bean 配置
- bean 基础配置
- bean 别名配置
- bean 作用范围配置

![[Pasted image 20221109201802.png]]

![[Pasted image 20221109202031.png]]

![[Pasted image 20221109202150.png]]

![[Pasted image 20221109202203.png]]

![[Pasted image 20221109202328.png]]
- 有状态的特征不适合 Spring 管理

### bean 实例化
- bean 是如何创建出来的
- 实例化 bean 的创建形式

- 私有的东西竟然能获取到，**反射实现**，构造方法创建的。
- 调用的是无参的构造方法

![[Pasted image 20221109202913.png]]

早些年的方式，不要自己 new 对象，用 Factory 去创建。


![[Pasted image 20221109203259.png]]

- 一般是用来兼容早期代码所使用的方法。

![[Pasted image 20221109203638.png]]

![[Pasted image 20221109203740.png]]

![[Pasted image 20221109203900.png]]

- 第三种方式的改良方法是经常会用到的。

![[Pasted image 20221109204121.png]]

![[Pasted image 20221109204140.png]]

![[Pasted image 20221109204152.png]]

### bean 生命周期
![[Pasted image 20221109204500.png]]

- 为什么 destroy 方法没有执行？因为虚拟机先推出了
	- 关闭 ctx

![[Pasted image 20221109204733.png]]

- 比较暴力的方式不太好
- 另一种方式，**设置关闭钩子**

![[Pasted image 20221109204905.png]]

- 关闭钩子
- **关闭容器会在 web 部分详细教**，这里还先用不到。
- Spring 说，不如你按照我的接  口来

![[Pasted image 20221109205236.png]]


![[Pasted image 20221109205249.png]]

![[Pasted image 20221109205352.png]]

![[Pasted image 20221109205420.png]]

![[Pasted image 20221109205442.png]]

![[Pasted image 20221109205507.png]]

## DI 依赖注入
- 好的今天就先学到这里吧。
- setter 注入
### setter 注入

### 构造器注入
![[Pasted image 20221110104050.png]]
![[Pasted image 20221110104147.png]]

![[Pasted image 20221110104308.png]]
- 简单类型

- 交换顺序没有问题

![[Pasted image 20221110104717.png]]

![[Pasted image 20221110104752.png]]

![[Pasted image 20221110105129.png]]

![[Pasted image 20221110105400.png]]

### 自动装配
- setter 方法要提供
- autowire="byType"

有几种类型需要配置。

- 通过入口的方式将对象给你。
- 如果装配了两个 bean 也会报错。
	- 按类型装配，你的类型必须是唯一的 —— 一般用
	- 你怎么可能写两个实现类呢？
- byName
	- 和类型名字相同

![[Pasted image 20221110111534.png]]

![[Pasted image 20221110111544.png]]

### 集合注入
- 数组
- List
- Set
- Map
- Properties

- 集合注入的开发使用量极低。

![[Pasted image 20221110161707.png]]

- 利用提示

### 记载 properties 文件
![[Pasted image 20221111093732.png]]

系统变量中有个环境变量叫做 username 冲突了，系统变量的优先级更高，所以打印出来是错误的结果。
![[Pasted image 20221111094240.png]]

![[Pasted image 20221111094500.png]]

![[Pasted image 20221111094507.png]]

### 容器
- 创建容器
![[Pasted image 20221111095124.png]]
- 获取 bean
![[Pasted image 20221111095133.png]]

## 核心容器总结
- 容器相关
- bean 相关
- 依赖注入相关

### 容器
![[Pasted image 20221111101110.png]]

### bean
![[Pasted image 20221111101412.png]]

### DI
- 构造器：第三方模块整合

![[Pasted image 20221111101508.png]]


# 注解开发
- 提供了一系列的注解，使用注解，就可以加速开发。

![[Pasted image 20221111103534.png]]

![[Pasted image 20221111103552.png]]

![[Pasted image 20221111103615.png]]
- 递归的而查找，一般写道组织名称

![[Pasted image 20221111103749.png]]

![[Pasted image 20221111103855.png]]

- 功能一样，只是方便理解。

## 纯注解开发
![[Pasted image 20221111104837.png]]
- SpringMVC 有些 bean 不能乱加载

![[Pasted image 20221111104950.png]]

![[Pasted image 20221111104959.png]]

- 工具类会用到 

## bean 管理
- 作用范围
- 生命周期

![[Pasted image 20221111110039.png]]

## 依赖注入
- 自动装配
- 使用了反射里面的**暴力反射**

![[Pasted image 20221111110835.png]]

![[Pasted image 20221111111000.png]]
- 还需要主义类那边要指定不同的名称。

![[Pasted image 20221111111243.png]]

- 注入的内容可能是来自外部的，通过配置文件的方式。那怎么加载配置文件呢？
- PropertySource 数组大括号，不能配置通配符。

![[Pasted image 20221111111823.png]]

## 第三方 bean 管理
### 第三方 bean 管理
![[Pasted image 20221111112432.png]]
![[Pasted image 20221111112717.png]]
- 替代工厂模式

![[Pasted image 20221111112744.png]]

![[Pasted image 20221111112831.png]]

### 第三方 bean 依赖注入
- 简单类型的就是正常注入方式，私有变量配置
- 引用类型作为参数传进去
![[Pasted image 20221112063424.png]]
- 利用自动装配实现，按照 类型

![[Pasted image 20221112063516.png]]

![[Pasted image 20221112063524.png]]

![[Pasted image 20221112063537.png]]

![[Pasted image 20221112063941.png]]

![[Pasted image 20221112064010.png]]

# Spring 整合 Mybatis
- 这部分内容其实没有必要详细去学

## Spring 整合 Mybatis 思路分析
### Mybatis 自动代理

![[Pasted image 20221112070709.png]]

### junit 单元测试
- [(89条消息) 超级详细的Junit单元测试教程_何学长在奔跑的博客-CSDN博客_junit](https://blog.csdn.net/weixin_44170221/article/details/106463482?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166808029616782395311684%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166808029616782395311684&biz_id=0&spm=1018.2226.3001.4187)

### 思路分析
![[Pasted image 20221112071542.png]]
![[Pasted image 20221112071730.png]]
- Spring 应该整合 sqlSesstionFactory

## 整合操作
### 导入必要坐标

![[Pasted image 20221112072022.png]]

- 注意版本不要乱写
- 快速开发用注解
- 这部分代码需要详细看
- 约定大于配置
- 事务处理的部分先忽略

![[Pasted image 20221112081232.png]]

- 以后用的时候
- 不管你以前怎么写，以后都按上面的方法写。

![[Pasted image 20221112081646.png]]

![[Pasted image 20221112081731.png]]

# Spring 整合 JUnit

![[Pasted image 20221112081924.png]]

![[Pasted image 20221112091117.png]]

![[Pasted image 20221112091123.png]]

# AOP
## AOP 简介
- AOP 核心概念
- AOP 作用
- 面向切面变成 
- AOP 也是一套变成思想
- 在不惊动原始设计的时候增强功能的，怎么做到的呢？

![[Pasted image 20221112092552.png]]

![[Pasted image 20221112092831.png]]
- 切面，指定在哪些切入点上 通知。

## AOP 总结
- [ ] AOP 没有学完

![[Pasted image 20221112093202.png]]

![[Pasted image 20221112093333.png]]

![[Pasted image 20221112093655.png]]

![[Pasted image 20221112093733.png]]

![[Pasted image 20221112093758.png]]

# Spring 事务

## Spring 事务简介

## Spring 事务角色

## Sping 事务属性

# Reference
- [SpringBoot - 配置文件application.yml使用详解（附：Profile多环境配置） (hangge.com)](https://www.hangge.com/blog/cache/detail_2459.html)
- 但是我忘记在哪里了 QAQ