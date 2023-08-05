---
created: ["2023-06-04 08:26"]
aliases: ["Blog Post Code"]
tags: [deeplocker, security]
---

## ❓ Information

Type:: summary  
Writer:: rongyi  
Tags:: #deeplocker #security  
Subject:: Deeplocker  

---

## ❗ Relevant Data

### 🎯 What Is The Objective

1. Summary of deeplocker's work so far
2. Detailed operation
3. 5 parts of development
4. the extent of 4 parts

### 📦 Information Resources

- [[../调研/Deeplocker|Deeplocker]]
- [[deeplcoker backend]]
- [[deeplocker frontend]]
- [[deeplocker python API development]]
- [[deeplocker 信息整合(memos)]]
- [[mtcnn 开发]]
- [[工具开发/deeplocker 工具构建|deeplocker 工具构建]]

## 🔰 Blog post -> Mine

It's a a summary of deeplocker

### 1️⃣ Summary of Deeplocker

目前 deeplocker 开发主要分为 5 个部分

1. 前端的开发 | react + antd(web) or [[../../Coding/Go/GUI/fyne/fyne-old|fyne-old]]
2. 服务端开发，配置模板，打包载荷 + 模板 + 应用 | Go
3. 模板的开发 | Go
4. 包装深度学习模型 API | [[../../Coding/Python/Repository/Flask/Flask Quickstart|Flask Quickstart]]
5. 安装程序的开发 | Windows Installer or install script | 因为 tensorflow.dll 静态编译失败 ---> 静态链接失败

### 2️⃣ Detailed Operation

1. windows 上 make
2. windows 上 opencv 的安装 ---> 最后希望形成一个安装脚本 ---> 用我们的静态资源
3. gocv 库的更改 (其实后来发现不是很需要更改了) ---> fork ---> git clone
4. [[../../AI/Tensorflow/tfgo/gocv + tensorflow-go|gocv + tensorflow-go]] 的修改 c_core API
5. generated key length
6. 安装包的问题 ---> 可以通过安装脚本的方式实现 (盗版的软件)

### 📃 Steps

五个模块的还发顺序

- [x] 接入载荷模板开发 ---> 完成 80% 因为还没有联测过 ✅ 2023-06-04
	- [x] 人脸识别模型接入结束 ✅ 2023-06-30
	- [x] 声音识别模型接入 | 这周完成 ✅ 2023-07-04
		- [x] 可以成功读取了 ✅ 2023-07-09
		- [ ] 接下来完成音频的转换，然后输入到模型中
- [ ] Python API Flask，API + 有验证的文件服务器 | 这个实现起来还是比较简单的 | **1 天左右时间**
	- [x] 需要一个数据库存储持久化存储模型的信息 ✅ 2023-08-03
	- [x] redis 存储临时信息 | 临时信息 ✅ 2023-08-03
	- [x] 存储客户端上传的目标图片 | 音频 以及一些基本信息，基本信息要以什么形式存在呢？json ---> 但似乎需要用户自己创建了 ✅ 2023-08-03
		- [x] 给上传的文件起一个名字，如果没有名字，会创建一个名字，这个名字最好不是随机的，因为随机的不好记忆和获取 —— 这之后就是开始训练的过程了 | 取名字是随机的，在初始化的时候为每个名字创建一个 hash 表 ✅ 2023-08-03
		- [x] 不同版本的模型对应相同的人的生成的密钥很**大概率**是不同的 ✅ 2023-08-03
		- [x] 数据库表设计 ✅ 2023-07-09
		- [x] 如何表示训练的进度呢？通过训练轮数的数值。—— 两份部分 | 一个进度条 | 或者返回中间的指标以及最终的指标 | 可以在中间增加一个**消息队列** ✅ 2023-08-03
		- [ ] Android 部分
			- [ ] 在训练之后自动调用函数生成 Android 的部分
			- [ ] 下载的部分需要改一下代码
		- [ ] Clear 函数 ---> 清理临时文件
		- [ ] 修改模板
			- [ ] 各种配置信息也要修改一下捏
			- [ ] 默认模式 ---> 或的关系
			- [ ] 严格模式 ---> 与的关系
- [x] 接入模块的开发 ---> API ---> 打包成 APP | 后端开发**大概 1 个星期** ✅ 2023-08-03
	- [x] config.json 配置所有内容 ✅ 2023-08-03
- [x] 项目前端开发 | 安排在后面的**一个星期** ✅ 2023-08-03
- [ ] 最后要打包成 APP——**APP 先不找了**
- [ ] **安装脚本**——因为更改了许多第三方库的文件，所以不得不进行这步

- 还需要安装 sqlite 到 windows 上，但实际上根本就不需要，内置的数据库。  
数据库表的字段

- **密钥表**
	- 模型版本
	- 目标 ID
	- 鲁棒性密钥

| 模型版本 | 目标 ID | 鲁棒性密钥 |
| -------- | ------- | ---------- |
|          |         |            |

- **模型信息表**
	- 模型版本
	- 准确率
	- 误报率
	- 攻击成功率
	- 存储路径

| 模型版本 | 准确率 | 误报率 | 攻击成功率 | 存储路径 |
| -------- | ------ | ------ | ---------- | -------- |
|          |        |        |            |          |

- **目标信息表**，前端需要展示他的照片信息，不然怎么确定是谁呢，随机挑选一张。
	- 目标 ID
	- 目标命名
	- 目标信息 json 格式
	- 目标照片存储路径

| 目标 ID | 目标命名 | 目标信息 | 目标照片存储路径 |
| ------- | -------- | -------- | ---------------- |
|         |          |          |                  |

**载荷信息**

- Name 名称 | 应该是带有扩展名的
- Data []byte 存储载荷二进制信息 | 加密的过程在后面

还有一部分是**激活程序的配置部分
	
- [ ] 激活时间段 time.Now() 进行判断

所以反应到前端，**选择一个模型** ---> **选择多个目标**，之后进行打包。—— 模型配置部分

- [x] 学习一门新技术对于我来说是非常快的。 ✅ 2023-07-10

- info 模块包含几个内容
	- irm info
	- vrm info
	- payload info
	- target info

bind delete function on button

- **文件名随机生成**

#### 1️⃣模板开发

- [ ] 整理模板
	- [ ] 删除冗余的内容
	- [ ] 考虑哪些内容是需要**配置**的

#### 2️⃣Python API

1. 约定一些文件夹
	1. 上传图片所需的文件夹，注意文件文件上传漏洞
2. 上传目标图片 | 声音，声音在另一台服务器上
3. 搭建文件服务器，**但是要有验证**，因为你不能让任何人都可以下载你的模型 basic or token

数据库中仅仅存放一些描述信息，因为文件实在是太大了，没有必要存进去 (要有一个**配置文件**，里面指定了对应的信息，比如数据库的名字 ---> 模型存储的位置等等)

1. 数据库中模型的 UUID 和模型的文件名是对应的
2. 数据库中

简单来说就是以 []byte 的形式存储。

API 需求文档，音频实际上已经开发结束了。

- [ ] upload target image | target_name + image | + new line
- [ ] get training info | get the info: loss, precision, epoch, completed, **key** and so on
- [ ] download model | **key** string is the folder name of model
- [ ] retrain model
- [ ] delete model | default save the model
- [ ] get model info
- [ ] get model list key ---> model info

maybe you should build a mysql on python API server

and you should install a docker

师姐我们 Python API 需要约定一些文件夹

1. 上传目标照片的位置
2. 下载模板的位置

上传图片的位置可以是：  
workspace/target/image/{{name}}/XXX.jpg

下载模型的位置是：  
workspace/model/{{key}}/xxx

因为分配的 key 是唯一的  
其他信息会被写道数据库里面

#### 3️⃣接入模块

- [ ] config the template | such as the sampling frequency

接入模块的逻辑

#### 4️⃣Frontend

开发的问题在于你要如何将数据接入，并且创建对应的窗口捏。

#### 5️⃣Windows Install or Script

1. 打包之后把所需要的动态加载库放在统一文件夹下就好了 (不久之前才发现的)

#### 6️⃣如何实现自启动和权限提升

## ℹ️指标

- [x] 可以获取目标的照片 ✅ 2023-07-04
- [x] 将目标的照片输入模型 ✅ 2023-07-04
- [x] 模型输出密钥 ✅ 2023-07-04
- [x] 用密钥做 hash 然后解出载荷 ✅ 2023-07-04

## ✅ Checklist Inspiration

- [x] 完成指标的编写 #deeplocker ✅ 2023-07-04
