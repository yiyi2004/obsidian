## 基本概念

自编码器（auto-encoder）是一种无监督的神经网络，其目标是将输入数据压缩到一个低维度的编码表示，并且在解码时将其重建回原始形式，尽可能地保留输入数据的信息。自编码器通常由一个编码器和一个解码器组成，编码器将输入数据压缩到一个编码向量，解码器则将编码向量映射回原始数据空间。  
自编码器在很多领域都有应用，例如图像压缩、特征提取、异常检测等。自编码器也是深度学习的基础模型之一，很多高级模型都基于自编码器进行改进，如变分自编码器（Variational Autoencoder，VAE）、生成对抗网络（Generative Adversarial Networks，GAN）等。

## Basic Auto-encoder

- 无监督学习嘛，还是人们对这种技术有了进一步的认识。

![[Pasted image 20221016150738.png]]  
![[Pasted image 20221016151154.png]]

- 可以将 decoder 的参数定位 encoder 的参数，这样参数的数量会少一半，缓解 overfitting。但是也没必要这样做，就直接训练就好。

![[Pasted image 20221016151616.png]]

- 如果降到 2 维回怎么样呢？

![[Pasted image 20221016151712.png]]  
![[Pasted image 20221016153014.png]]

- 重要的是区分，可以对数据进行压缩。

![[Pasted image 20221016153235.png]]

- unsupervised

![[Pasted image 20221016153438.png]]  
![[Pasted image 20221016200811.png]]  
![[Pasted image 20221016200845.png]]

- 就是这样循环下去

![[Pasted image 20221016200925.png]]  
![[Pasted image 20221016201021.png]]

- 现在往往不用 pre-train 的方式就能训练得到。最后是 fine-tune ，大多数时候是有效的。
- 当你有大量的 label data 的时候是有效的
- De-noise auto-encoder

![[Pasted image 20221016201259.png]]

- more robust
- 相当于也学习到了过滤噪音这一步

![[Pasted image 20221016201411.png]]  
![[Pasted image 20221016201440.png]]

## Auto-encoder for CNN

![[Pasted image 20221016201718.png]]  
![[Pasted image 20221016201947.png]]

- De-convolution is convolution

![[Pasted image 20221016202652.png]]

- 不需要写一个 de-convolution 但是是什么意思，它是怎么转化的。
- 将学习变成一种常态

## Reference

- [机器学习 第17讲 无监督学习 - Auto-encoder_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Yx411976B/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
