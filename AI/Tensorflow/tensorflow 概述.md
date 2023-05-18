- 连接主义：理性思维　＋　感性思维
- 行为主义：控制论，机器人的单脚站立
- 符号主义：基于表达式，将问题描述为表达式，ｉｆ．．．ｃａｓｅ．．　理性思维

![[Pasted image 20221017144654.png]]

你在干什么？注意力集中一点

```
import tensorflow as tf

w = tf.Variable(tf.Constent(5, dtype=float32))
```

- 我的评价是如果遇到什么不会的先跳过，记录一下，后面再学，不要打乱自己的节奏。
- pandas 通过 pandas 展示数据确实不错哦
- sklearn
- 使用相同的随机种子，所以打乱后的样本和标签还是一一对应的?
- 神经网络搭建的代码很重要，希望你能背下来。
- 可以对模型优化一下，看看模型的准确率是否会有提升。
- numpy 的随机数操作还是蛮重要的哦

![[Pasted image 20221017155635.png]]
![[Pasted image 20221017155716.png]]
- vstack 纵向叠加了


- 生成网格坐标点

![[Pasted image 20221017160255.png]]
- 我懂了，还是弹幕大神牛哇。

- sigmod 函数会导致梯度消失的问题。

![[Pasted image 20221017160905.png]]

![[Pasted image 20221017160921.png]]

![[Pasted image 20221017160951.png]]

- 导致神经元死亡的原因是输入神经网络的负特征太多了，**有几种方式可以避免这种情况的出现**。

![[Pasted image 20221017161156.png]]
- 实际上都选择 relu

![[Pasted image 20221017161225.png]]

![[Pasted image 20221017163426.png]]
![[Pasted image 20221017163833.png]]
- 正则化的方法你是真的不熟悉啊。
- 不行辣，我要睡着了，明天再学吧。
- matlib 需不需要学习一下呢，数据分析和处理

# 神经网络搭建八股
- keras 官方文档：[Module: tf  |  TensorFlow v2.10.0 (google.cn)](https://tensorflow.google.cn/api_docs/python/tf)
- 这部分内容在笔记 3 里面。

快速搭建神经网络，加速实验。

- 第一步：import 相关模块，如 import tensorflow as tf。
- 第二步：指定输入网络的训练集和测试集，如指定训练集的输入 x_train 和标签 y_train，测试集的输入 x_test 和标签 y_test。 
- 第三步：逐层搭建网络结构，model = tf.keras.models.Sequential()。 
- 第四步：在 model.compile()中配置训练方法，选择训练时使用的优化器、损失 函数和最终评价指标。 
- 第五步：在 model.fit()中执行训练过程，告知训练集和测试集的输入值和标签、 每个 batch 的大小（batchsize）和数据集的迭代次数（epoch）。
- 第六步：使用 model.summary()打印网络结构，统计参数数目。

1. import
2. dataset
3. model
4. model.compile
5. model.fit
6. model.summary

- 其他的东西都是锦上添花。pandas

# Dataset 处理方式

## mnist

- 数据集要考虑哪些方面呢？
	- 特征 ——> 标签
	- 什么类型的文件呢？csv text 如何和标签对应上
	- 文件的读写和处理
	- 框架用什么数据结构接住呢？
	- 如何删减属性呢？
	- 如何拆分数据集呢？
	- 如何对数据集进行合并呢？
	- 其实都是对数据集的操作吧。

![[Pasted image 20221017193600.png]]
- 非常详细，可以把代码背下来。
- 数据增强 image_gen_train=tf.keras.preprocessing.image.ImageDataGenerator(增强方法)

![[Pasted image 20221017195239.png]]

![[Pasted image 20221017195338.png]]


# tensorflow4
- matplotlib 画图的部分

![[Pasted image 20221018181956.png]]
- predict
	- verbose
	- 二值化，模型可能会出现不收敛的情况，需要对数据进行归一化。

![[Pasted image 20221018182436.png]]
- 显示数据的方式哦

# Tensorflow5 卷积神经网络
- 恶意流量是怎么标注的呢？那它和正常的流量有什么区别呢？

![[Pasted image 20221018184133.png]]
- BN：batch normalization
- 是否进行全零填充
- [批归一化](https://blog.csdn.net/junqing_wu/article/details/105431919)操作，有什么类型的归一化操作呢？
	- 归一化、标准化、中心化(一般不单独使用)
- BN 操作就是为了让平均值变为 0，标准差变为 1.
- tf.keras.layers.BatchNormalization
- 卷积就是 CBAPD

![[Pasted image 20221018185510.png]]
- 构建模型的八股——六步法 + CBAPD
- 如果长时间掰手指头，得关节炎得
- **tensorflow 如何使用预训练的模型呢？比如 ResNet50**

- 其实你不知道如何体现出自己的工作量。

# Tensorflow6 循环神经网络

- colab 查看能否使用 GPU
- print('GPU', tf.test.is_gpu_available())

# Reference
- [2.5-缓解过拟合_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1B7411L7Qt/?p=13&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- 笔记在北京大学 tensorflow2.0 里面哦，注意查收。
- [(138条消息) TensorFlow的reduce_sum()函数_Maples丶丶的博客-CSDN博客_reduce_sum](https://blog.csdn.net/qq_16137569/article/details/72568793?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166599778116800186558618%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166599778116800186558618&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-72568793-null-null.142^v58^control,201^v3^add_ask&utm_term=reduce_sum&spm=1018.2226.3001.4187)
- [(138条消息) softmax_cross_entropy_with_logits详解_weixin_42713739的博客-CSDN博客_softmaxcrossentropywithlogits](https://blog.csdn.net/weixin_42713739/article/details/103235556?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166599816616800180654498%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166599816616800180654498&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-103235556-null-null.142^v58^control,201^v3^add_ask&utm_term=softmax_cross_entropy_with_logits&spm=1018.2226.3001.4187)
- [models/official at master · tensorflow/models (github.com)](https://github.com/tensorflow/models/tree/master/official)

- 使用 GPU
- [(140条消息) 2020年Tensorflow2-GPU 完整安装过程总结_ResNet-xf的博客-CSDN博客](https://blog.csdn.net/AIHUBEI/article/details/105045715)
- [(140条消息) 如何使用Google colab gpu跑tensorflow_喵了个咪mr的博客-CSDN博客](https://blog.csdn.net/weixin_42704669/article/details/106878624?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166616549616782395378082%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166616549616782395378082&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-2-106878624-null-null.142^v59^control,201^v3^add_ask&utm_term=colab%20tensorflow%20gpu%20%E4%BD%BF%E7%94%A8&spm=1018.2226.3001.4187)
- [(140条消息) Tensorflow2.0 之开启 GPU 模式_cofisher的博客-CSDN博客_tensorflow开启gpu](https://blog.csdn.net/qq_36758914/article/details/107152997)

- 如果遇到什么问题一定要立刻解决，不然你后来一定会忘记的。
- 明天开始复现吧
- 想到不一定能够做到，让自己的时间变得更有意义一点。
