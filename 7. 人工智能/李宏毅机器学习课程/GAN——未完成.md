![[Pasted image 20220411225115.png]]
![[Pasted image 20220412091841.png]]
一个简单的想法：让输出是有几率的。

simple distribution：高斯分布、二次分布

![[Pasted image 20220412092032.png]]

这种场景往往需要一些创造力哦。

the same input has different output ---> Creativity
![[Pasted image 20220412092304.png]]

这个例子你可以用哦，辉夜大小姐到底是谁呢？

## Generative Adversarial Network(GAN)
1. 阅读大量的论文
2. 真的是擅长思考哦，你应该引导自己去想一些有意义的事情

不同的 distribution 影响的根据经验来说并不是很大哦
![[Pasted image 20220412093134.png]]

由 simlpe distribution 得到 complex distribution.

输出的值越大，就越接近真是世界的图片。
![[Pasted image 20220412093359.png]]

数字孪生平台
## Basic Idea of GAN
![[Pasted image 20220412094331.png]]
generator and discriminator

![[Pasted image 20220412094525.png]]

## Algorithm
### Step 1
![[Pasted image 20220412094757.png]]

先训练 generator，然后再训练 discriminator

fix discriminator，升高所产生的值。

只更改 generator 的结构哦，gradient decent

两个步骤
1. 固定 discriminator 训练 generator
2. 固定 generator 训练 discriminator

### Step 2
![[Pasted image 20220412095658.png]]

反复对抗，不断提升。
![[Pasted image 20220412095824.png]]

generator update 100 times
![[Pasted image 20220412100004.png]]

![[Pasted image 20220412100025.png]]

Progressive GAN
1. 内差

the first gan
![[Pasted image 20220412100318.png]]
![[Pasted image 20220412100334.png]]

幻想中的角色，网球狗，不错的灵感哦，随意的组合。

# Theory Behind GAN
再这里学习，确实比再宿舍里面强太多

## Our Objective
和真正资料的分布相同

divergence: a measure to measure the divergence between Pg and Pdata

![[Pasted image 20220412101201.png]]

how to compute the divergence?

KL, JS divergence

不需要知道 Pg 和 Pdata 的 formulation 是什么样子。

能够 sample 就能够计算 divergence
![[Pasted image 20220412101604.png]]

把它当成一个 optimazation 的问题哦

![[Pasted image 20220412110623.png]]
