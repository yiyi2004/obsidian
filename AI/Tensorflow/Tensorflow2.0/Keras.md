# Keras

![[Pasted image 20221020152047.png]]

![[Pasted image 20221020152419.png]]
![[Pasted image 20221020152438.png]]
![[Pasted image 20221020152452.png]]
![[Pasted image 20221020152641.png]]
![[Pasted image 20221020152720.png]]

- 需要找时间安装一下 tensorflow2.0 的环境。注意安装好你的 cudnn 和 cuda 接口。

![[Pasted image 20221020160636.png]]

- for x,y in dataset 没有指定

![[Pasted image 20221020160818.png]]

![[Pasted image 20221020160848.png]]
![[Pasted image 20221020161056.png]]

- 寻找相同类型应用之间的共同点并且统一化接口时重要的，上层接口的设计尤其重要(面向接口编程)。

- [ ] 晚上要把文档整理出来

![[Pasted image 20221020163542.png]]
- validation_freq 多少个 epoch 做一次 validation。你嘴上说着不做。但是身体上却很诚实。

![[Pasted image 20221020163745.png]]
- 但是神经网络要用 tensorflow 中的接口去构建。

![[Pasted image 20221020163936.png]]
![[Pasted image 20221020164029.png]]
- early stopping
- 在中间进行 evaluation 
- 因为深度学习好发论文，好的 papers 

![[Pasted image 20221020164256.png]]
- 客户拿到模型之后要进行预测

![[Pasted image 20221020164321.png]]
- 预测的逻辑

## 自定义神经网络
- keras.Sequential
- keras.layers.Layer
- keras.Model

![[Pasted image 20221020165319.png]]
- 如果不知道输入的尺寸是什么
	- 像上面的例子例子一样 build input shape
	- network(x) 根据 x 的 shape 创建  w 和 b 的 shape

![[Pasted image 20221020165828.png]]

![[Pasted image 20221020170145.png]]
- 所有的自定义层的母类

![[Pasted image 20221020170424.png]]
![[Pasted image 20221020170743.png]]

# 模型的保存和读取
- 适合对代码的清晰认识，有代码
- 都保存下来
- saved_model 不需要给源代码
	- 保存之后可以通过 C++ 进行读取
	- [galeone/tfgo: Tensorflow + Go, the gopher way (github.com)](https://github.com/galeone/tfgo#go-code)
	- 最后用 Golang 将算法部署到服务器上

![[Pasted image 20221020195117.png]]
![[Pasted image 20221020195249.png]]
- 第一种方式必须知道网络的结构。

![[Pasted image 20221020195439.png]]
- 有关模型的所有信息都保存下来，包括网络结构等等。
- tf.keras.models.load_model('model.h5') // 如果不在乎效率的情况下。

![[Pasted image 20221020195703.png]]
- 第三种是工业环境的部署

# CNN
![[Pasted image 20221020195854.png]]
- 全局共享
- 滑动窗口

![[Pasted image 20221020200431.png]]
- 可以通过 stride 去进行降维的操作

![[Pasted image 20221020201757.png]]
- 标准的公式计算



# Reference
- [76. 【08.Keras高层接口】76 Keras高层API-1_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Ge4y1i76A?p=77&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- 【最完整版】深度学习与TensorFlow2入门实战+ tensorflow 2.0 + GPU安装配置——我感觉这个可能随时会下架，好像下载下来(这个是下周学习的内容)
- [(141条消息) one-hot理解_Dorothy_Xue的博客-CSDN博客_one-hot](https://blog.csdn.net/Dorothy_Xue/article/details/84641417/?ops_request_misc=&request_id=&biz_id=102&utm_term=%E4%BB%80%E4%B9%88%E6%98%AF%20one_hot&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-84641417.142^v59^control,201^v3^add_ask&spm=1018.2226.3001.4187)
- 代码是有的
