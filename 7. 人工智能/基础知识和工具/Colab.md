> Colaboratory 是一个免费的 Jupyter 笔记本环境，不需要进行任何设置就可以使用，并且完全在云端运行。 借助 Colaboratory，可以编写和执行代码、保存和共享分析结果，以及利用强大的计算资源，所有这些都可通过浏览器免费使用。

# 读取数据常用方法

## wget 方法
Colab其实是一台带有GPU的Centos虚拟机，可以直接使用linux的`wget`命令下载数据集到服务器，默认是下载到/content路径，下载速度可以达到60-130mb/s

```shell
!wget https://download.pytorch.org/tutorial/hymenoptera_data.zip
!unzip hymenoptera_data.zip -d ./
```
## 挂载谷歌云盘加载数据集

```python
from google.colab import drive
drive.mount('/content/drive/')
```

```python
import os
#改变当前工作目录到谷歌云盘的路径
path="/content/drive/My Drive/Colab Notebooks/"
os.chdir(path)
os.listdir(path)
#使用wget命令下载数据集到这个路径
!wget https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/data.csv
```

- 加载数据
```python
train = pd.read_csv('/content/drive/My Drive/Colab Notebooks/data/data.csv')
```

- 我发现可以在 notebook 中上传自己的数据哦
- 数据读取应该没什么问题了

然后把train.csv数据上传上去，点击获取共享链接，把链接中id后面的字符串复制出来。
```python
# Code to read csv file into colaboratory:
!pip install -U -q PyDrive
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from google.colab import auth
from oauth2client.client import GoogleCredentials

# 1. Authenticate and create the PyDrive client.
auth.authenticate_user()
gauth = GoogleAuth()
gauth.credentials = GoogleCredentials.get_application_default()
drive = GoogleDrive(gauth)


#2. Get the file   #在此处吧你的文件id改进去
downloaded = drive.CreateFile({'id':'XXXXXXXXXXX'}) # replace the id with id of file you want to access
#输入你的文件名字
downloaded.GetContentFile('train.csv') 

#3. Read file as panda dataframe
import pandas as pd  # 数据分析

data_train = pd.read_csv("train.csv")
data_train
```

Reference
- [(140条消息) 使用colab实现数据导入_有情有义又是有米无炊的博客-CSDN博客](https://blog.csdn.net/wly0709/article/details/105375092?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166616643016782412580368%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166616643016782412580368&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-105375092-null-null.142^v59^control,201^v3^add_ask&utm_term=colab%20%E5%A6%82%E4%BD%95%E5%AF%BC%E5%85%A5%E6%95%B0%E6%8D%AE&spm=1018.2226.3001.4187)
- [(140条消息) 在colab上使用自己的数据集_姬小野的博客-CSDN博客](https://blog.csdn.net/wjh2622075127/article/details/88925201?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-2-88925201-blog-105375092.pc_relevant_vip_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-2-88925201-blog-105375092.pc_relevant_vip_default&utm_relevant_index=3)
