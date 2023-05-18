# 导入 kaggle 数据
```python
# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))

# You can write up to 5GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session
```

![[Pasted image 20221019103545.png]]

# 导入依赖包
```python
import pandas as pd
import numpy as np
import sys
import keras
import sklearn
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Embedding, Flatten
from keras.layers import LSTM, SimpleRNN, GRU, Bidirectional, BatchNormalization,Convolution1D,MaxPooling1D, Reshape, GlobalAveragePooling1D
from keras.utils import to_categorical
import sklearn.preprocessing
from sklearn import metrics
from scipy.stats import zscore
from tensorflow.keras.utils import get_file, plot_model
from sklearn.model_selection import train_test_split
from tensorflow.keras.callbacks import EarlyStopping
import matplotlib.pyplot as plt
print(pd.__version__)
print(np.__version__)
print(sys.version)
print(sklearn.__version__)
```

![[Pasted image 20221019103641.png]]

# Dataset ---> DataFrame
```python
#Loading training set into dataframe
df = pd.read_csv('../input/unsw-nb15/UNSW_NB15_testing-set.csv')
df.head()
```

![[Pasted image 20221019103817.png]]

```python
#Loading testing set into dataframe
qp = pd.read_csv('../input/unsw-nb15/UNSW_NB15_training-set.csv')
qp
```
![[Pasted image 20221019103907.png]]
# sklearn.model_selection(数据预处理)
```python
from sklearn.model_selection import StratifiedKFold
from imblearn.over_sampling import RandomOverSampler
oversample = RandomOverSampler(sampling_strategy='minority')
```
- 需要小小的研究一下



# 学习笔记
- 不同的版本的接口会发生改变，改变的接口要去查文档

# BiLSTM
- 将编码后的文字输入到前向和后向的 LSTM 中，然后相同的字拼接在一起
- 或者最后输出拼接在一起 —— 对于情感分类来说 bert 是吧
- 给了一个二分类的数据，给了一个总共分类的数据。

## 一维卷积

![](https://images2017.cnblogs.com/blog/1223117/201802/1223117-20180212193102531-761358003.png)

- 图中的输入的数据维度为8，过滤器的维度为5。与二维卷积类似，卷积后输出的数据维度为8−5+1=4 8−5+1=4。
- 如果过滤器数量仍为1，输入数据的channel数量变为16，即输入数据维度为8×168×16。这里channel的概念相当于自然语言处理中的embedding，而该输入数据代表8个单词，其中每个单词的词向量维度大小为16。在这种情况下，过滤器的维度由55变为5×165×16，最终输出的数据维度仍为44。
- 如果过滤器数量为nn，那么输出的数据维度就变为4×n4×n。
- 一维卷积常用于序列模型，自然语言处理领域。

# 进一步完善
1. CNN 方面可以替换成更有深度的神经网络 ResNet-RS
2. 数据预处理方面

困难的解决方案：
1. 更为丰富的数据集(合并数据集、构造数据集)——但是这个数据集真的是不好处理哦。
2. tensorflow 如何引入其他人的网络结构
3. tensorflow 如何用 GPU 去跑深度学习算法捏？

- 现在就是预训练模型的导入问题了。
- 怎么将不同的网络拼接在一起呢？——公式是什么？
- 如果有数据的特征缺失的，应该怎么处理。

# 数据集整理
UNSW-NB15
1. Fuzzers
2. Analysis
3. Backdoors
4. Dos
5. Exploits
6. Generic
7. Reconnaissance
8. Shellcode
9. Worms

Intrusion Detection Evaluation Dataset (CIC-IDS2017)

[NSL-KDD dataset](https://www.unb.ca/cic/datasets/nsl.html)

![[Pasted image 20221020145744.png]]
- 他的标签是标到小类的内容的

# 测试
## UNSW-NB15
### k=2
![[Pasted image 20230316145301.png]]

![[Pasted image 20230316145317.png]]
![[Pasted image 20230316145333.png]]

### k=4
![[Pasted image 20230316224105.png]]
![[Pasted image 20230316224122.png]]
![[Pasted image 20230316224151.png]]
### k=6
![[Pasted image 20230320063703.png]]
![[Pasted image 20230320063731.png]]
![[Pasted image 20230320063745.png]]


## KDD
### k=2
![[Pasted image 20230316214435.png]]
![[Pasted image 20230316214503.png]]
![[Pasted image 20230316214516.png]]

### k=4
![[Pasted image 20230319091047.png]]
![[Pasted image 20230319091103.png]]
![[Pasted image 20230319091118.png]]

### k=6
![[Pasted image 20230319152428.png]]
![[Pasted image 20230319152449.png]]
![[Pasted image 20230319152516.png]]

### k=10
![[Pasted image 20230316201919.png]]

![[Pasted image 20230316201935.png]]

![[Pasted image 20230316202031.png]]
# 记录
TP 攻击正确分类的数量
TN 正常流量正常分类
FN 攻击误分为正常流量
FP 正常流量分为攻击流量
![[Pasted image 20230322203913.png]]
1 / 1 + 3


![[Pasted image 20230322203932.png]]

# Reference
- https://paperswithcode.com/paper/efficient-deep-cnn-bilstm-model-for-network
- [讲的挺明白的“LSTM和BiLSTM”分享_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV15A411n7b1/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- https://www.jiqizhixin.com/articles/2018-10-24-13
- [卷积神经网络（CNN）之一维卷积、二维卷积、三维卷积详解 - szx_spark - 博客园 (cnblogs.com)](https://www.cnblogs.com/szxspark/p/8445406.html)

语言：
java 架构

交付的东西，架构
1. 数据结构与算法，图书 500+以上
2. 计组 + 生态
3. 架构 Java

Go
1. devops
2. 微服务痛点：高性能
3. 并发能力不如 java 好

![[Pasted image 20230316225358.png]]