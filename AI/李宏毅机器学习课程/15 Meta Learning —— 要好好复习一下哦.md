# 基础知识
Meta Learning: Learn to learn

Network 的架构，Learning Rate，Hyper Parameter 买多张 GPU。

一次开 1000 张 GPU，看看哪组能给你最好 Model。

经验和直觉，哈哈哈哈。

![[Pasted image 20220425100959.png]]

## Machine Learning
Machine Learning == Looking for a Function.

![[Pasted image 20220425101343.png]]

## Introduce of Meta Learning
![[Pasted image 20220425101649.png]]

Meta Learning 通过学习一个数据集，输出一个 function，根据 ML 的三个步骤可以学习到这样一个 Function(Learning Algorithm) 嘛。

### Step 1
![[Pasted image 20220425102106.png]]

phi 代表一个 learning algorithm 中想要被学出来的东西。

学习不同的 component 就会有不同的 meta learning 的方法

### Step 2
在 ML 中，Loss 来自训练资料

在 Meta Learning 中来自于 task

比如我想要训练一个二元的分类器，所以我们要准备很多的二元分类任务。

![[Pasted image 20220425102519.png]]


## 元学习概述
Machine Learning 和 Meta Learning 之间的区别
![[Pasted image 20220425104956.png]]

几个不清楚的概念
- [ ] AutoML
- [ ] Transfer Learning
- [ ] Life Long Learning

N-ways K-shots，N 类，每类有 K 张

> 构建的任务分为训练任务（Train Task），测试任务（Test Task）。特别地，每个任务包含自己的训练数据、测试数据，在元学习里，分别称为Support Set和Query Set。

MAML的目的是获取一组更好的模型**初始化参数**（即让模型自己学会初始化）。我们通过（许多）N-ways，K-shot的任务（训练任务）进行元学习的训练，使得模型学习到“先验知识”（初始化的参数）。这个“先验知识”在新的N-ways，K-shot任务上可以表现的更好。

元学习的目的其实是为了得到一组更好的初始值.

![[Pasted image 20220427165314.png]]

Learning Algorithm。我真的吐了哦![[Pasted image 20220427165610.png]]

N 是任务的数量，可能是一个很大的值哦。

在 meta learning 中 Loss 是用**测试资料**计算的
![[Pasted image 20220427170022.png]]

我不理解，你在说什么啊。听起来有点乱哦。meta learning 和 machine learning 之间的区别是什么呢？

## Reinforcement Learning 增强学习，这里需要补充知识点
![[Pasted image 20220427170427.png]]

few-shot learning：期待达成的目标、meta learning：学会如何学习

meta learning ---> few-shot learning

![[Pasted image 20220427170936.png]]

## ML 和 Meta Learning 之间的区别
### Goal
![[Pasted image 20220427171438.png]]

### Train Data
![[Pasted image 20220427171520.png]]

- Support set and query set 一个 task 中的训练资料和测试资料。

### Within|Across-task training
![[Pasted image 20220427171655.png]]

因为科研是需要快速的发论文的，所以设计的神经网络架构不一定是最优的哦，这并不是企业级的，其实还蛮有道理的哦。

在 meta learning 中还包含了 within-task learning

- Episode

![[Pasted image 20220427172043.png]]

### Loss function
![[Pasted image 20220427172207.png]]

### Training 的时候会发生什么呢？

#随记
Learning to initial 似乎对你的研究工作有很大的借鉴意义哦

### Outer loop and Inner loop
![[Pasted image 20220427172623.png]]

#随记 
设置工作的 CPU 就行了，看一下自己的 CPU 是几核的。

### 相同点

![[Pasted image 20220427173006.png]]

learn "learning algorithm" 的参数调节。

**可以用在任何 task 上面，一劳永逸哦**

development task 这是验证集嘛？你读文献还是相对较慢的哦。

fai 如果是离散的东西，不能做微分。fai 包含一些神经元链接的资源。

不同的 learning rate 得到不同的 model，用 development task 上测试那个是最好的，然后才在 testing task 上进行测试，防止出现 overfitting 在 test task 上。

**development dataset**

不要用 test data 挑参数。
# What is learnable in a learning algorithm
Review: Gradient Descent

seta_0 is learnable, 初始化参数很重要，可能对训练特别有帮助。
![[Pasted image 20220428162052.png]]

## MAML: Learning to initialize
learning to initialize
![[Pasted image 20220428162147.png]]

MAML: Learn initialized hyper parameters

MAML++: Paper, how to train you maml
![[Pasted image 20220428162435.png]]

**what is proxy task**

#问题 
self-supervised learning 的问题
![[Pasted image 20220428162857.png]]

一个区别就是有无标注
![[Pasted image 20220428163124.png]]

more typical ways 将很多的资料倒在一起，也能够得到一组 init，经常作为 meta learning 的 baseline。

为什么用做 baseline，用到的资料是相同的。
![[Pasted image 20220428163311.png]]
这个影片一定要看哦。

训练的任务和测试的任务不是很大哦。。。

meta learning 其实是一种 domain adaptation 的方法哦，不同的任务或者不同的 domain。

MAML 为什么会好呢？
![[Pasted image 20220428163905.png]]

![[Pasted image 20220428164059.png]]

Frist order MAML 快速的变形

## Optimizer
paper: learning to learn by gradient descent by gradient descent.

哈哈哈，大家真的是会其有梗的名字呢。

#问题 
LSTM 是什么
![[Pasted image 20220428164456.png]]

## Network Architecture Search(NAS)
其实在学习 network 的架构
![[Pasted image 20220428164702.png]]

参数和 hyper parameter 是不同的概念哦。
![[Pasted image 20220428164937.png]]

这个架构我懂了，只能说确实可以的。

近年的 NAS 的 work，training task 和 testing task 可以是不同的 task 哦。

![[Pasted image 20220428165606.png]]

![[Pasted image 20220428165627.png]]

### Darts
上面是处理不可微分的情况
![[Pasted image 20220428165659.png]]

### Data Augmentation 数据增强
Data processing 意思是处理数据吧。

![[Pasted image 20220428170038.png]]

### Sample Rewighting
![[Pasted image 20220428170359.png]]
自动学习样本的权重，boundary 近的到底是 noisy or important?

### Beyond Gradient Descent
![[Pasted image 20220428170620.png]]

输入是 data，输出是 network（其实是一些参数而已），NB 啊，但是目前仍然处于研究的阶段吧，专业的问题交给专业的人去解决。

### Learning to compare
![[Pasted image 20220428170935.png]]
## Application
### Few-shot image classification
![[Pasted image 20220428171313.png]]

这个数据集经常用来做 N-ways K-shot 问题，可以制造 nwks 问题
![[Pasted image 20220428171336.png]]
![[Pasted image 20220428171705.png]]
![[Pasted image 20220428171738.png]]
语音识别和自然语言处理，meta learning 推向更加复杂的应用。

# Reference
- [元学习概述（Meta-Learning）](https://blog.csdn.net/qq_40913465/article/details/112608242?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522165085461516781483790039%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=165085461516781483790039&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-112608242.142^v9^control,157^v4^control&utm_term=meta+learning&spm=1018.2226.3001.4187)

