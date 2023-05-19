# ResNet 论文阅读
解决的问题：深度神经网络训练困难

微软研究院实习？

提出不同架构的文章，一些特别结构的文章，竞赛中获得名次的算法架构，通常来说要往下读一读哦

CNN ---> ResNet
CoCo 物体检测的数据集

CVPR，要求正文不超过 8 页，没有结论的部分，哈哈哈哈。

#tips
- 第一页一般会放上一张好看的图，CMU，最后一堂课，小时候的梦想 randy。

这个假期你要提高代码能力

图 + 表

你不会对中国学者做出的成果有一些刻板印象吧。

低级的视觉特征、高级的视觉特征

梯度消失或者爆炸
1. 初始化

不是 overfitting 训练误差和测试误差都变得很高。

identity mapping x ---> x

SGD: unable to find.

显示的构造一个 identity mapping，使深得网络不会比浅的网络差。

# ResNet 网络详解
先了解网络的架构，半吊子研究生

- [ ] dropout 层是用来干什么的
![[Pasted image 20220430161916.png]]

![[Pasted image 20220430162029.png]]g
gradient > 1 梯度爆炸现象
1. 数据标准化处理
2. 权重初始化
3. BN **batch normalization**：不需要使用 dropout 了

退化问题
1. 残差结构
用了relu 可能不会出现梯度消失，可能会出现梯度爆炸问题。

残差架构，加深网络

short cut 捷径哦

residual 结构
![[Pasted image 20220430223620.png]]
节省参数情况

网络结构
![[Pasted image 20220430223709.png]]

通过残差结构构件更加深的网络

![[Pasted image 20220507205934.png]]

左边的残差结构用在层数比较少的网络结构，右边相反。



输出的 shape 必须是相同的，相同的维度进行累加。

卷积核的个数是 64，第一层是进行将为的功能。
![[Pasted image 20220507210643.png]]

![[Pasted image 20220507210925.png]]

实线和虚线之间的区别是什么？
![[Pasted image 20220507211045.png]]![[Pasted image 20220507211047.png]

![[Pasted image 20220507211104.png]]
![[Pasted image 20220507211151.png]]

虚线通过 stride 来控制shape，shortcut 上面的卷积层是为了保证主分支和 shortcut 的输出的 shape 是相同的。

![[Pasted image 20220507211647.png]]

option B 是通过试出来的。

虚线的结构一般是放在一个残差结构的开始的地方，用来将上一层输出的形状，转变为这一层的输入的形状。

下采样操作。

3、4、5 有虚线残差结构。
![[Pasted image 20220507212018.png]]

层数更多的 resnet c2 层有虚线结构，因为要求的输入是不一样的。

如何 1 个小时读完一篇论文呢？

只是调增了深度，细节。但是 3.4.5 更改了形状（长、宽、channels）都改变了。

# Batch Normalization
![[Pasted image 20220507212400.png]]

可以加速网络的训练，并且能够提升准确率。

很小的一个数字是为了防止分母 == 0 的情况。
![[Pasted image 20220507213751.png]]

迁移学习是比较普遍的方法。

使用别人预训练的模型，要注意人家的预处理方法。而且要防止过拟合的情况。
![[Pasted image 20220507214006.png]]

![[Pasted image 20220507215853.png]]

![[Pasted image 20220507220005.png]]

添加一层全裂阶层，这样可以载入所有的参数。好棒哦。

联系方式

![[Pasted image 20220507220238.png]]

# Reference
- [ResNet网络结构，BN以及迁移学习详解](https://www.bilibili.com/video/BV1T7411T7wa?spm_id_from=333.337.search-card.all.click)
