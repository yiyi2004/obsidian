# LM
the same as GRU

是否要看过去的状态，更加在意现在的状态，或者在意现在在的状态，而忽略过去的状态。

![[Pasted image 20220709120535.png]]

- 忘记门
- 输入门
- 输出门

![[Pasted image 20220709120654.png]]

主要解决的问题：
1. 梯度消失
2. 梯度爆炸

相比于 RNN，LSTM 能够在更长的时间保持良好的效果。。

![[Pasted image 20220709121100.png]]

你需要在学术上有一点强迫症，但是不要对身边的人那么苛刻。

前向传播原理
![[Pasted image 20220711090737.png]]

为什么？

- tanh 转化为做题的能力

![[Pasted image 20220711112436.png]]

- [ ] 大家都没搞清楚为什么要这样设计。

确实长得挺奇怪的。

GRU 相似

**候选记忆单元，RNN 里面算 H**

![[Pasted image 20220712155836.png]]

![[Pasted image 20220712155851.png]]

![[Pasted image 20220712160151.png]]

隐状态
- [ ] tanh: +-1 之间

输出门：控制要不要输出。

极端的情况，输入X可能和过去的信息完全不要。

![[Pasted image 20220712160457.png]]

C 是辅助的记忆单元，可以忘记以前的 C。

O 也可以是什么都不要，我重新来。

# LHY
![[Pasted image 20220712195152.png]]

如果让 network 有记忆力的行为。

![[Pasted image 20220712195319.png]]

![[Pasted image 20220712222822.png]]

同一个 network 在 3 个时间点被使用了 3 次。


![[Pasted image 20220712223021.png]]

![[Pasted image 20220712223033.png]]

输入同样的词汇，输出的结果不同，可以实现。


![[Pasted image 20220712223104.png]]

![[Pasted image 20220712223118.png]]
![[Pasted image 20220712223249.png]]

- [ ] 传说 Jordan Network 可以得到不错的结果。

![[Pasted image 20220712223408.png]]

