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
- [ ] Python API Flask，API + 有验证的文件服务器 | 这个实现起来还是比较简单的 | **1 天左右时间**
- [ ] 接入模块的开发 ---> API ---> 打包成 APP | 后端开发**大概 1 个星期**
	- [ ] config.json 配置所有内容
- [ ] 项目前端开发 | 安排在后面的**一个星期**
- [ ] 最后要打包成 APP
- [ ] 安装程序的开发 | **安装脚本**

#### 1️⃣模板开发

#### 2️⃣Python API

1. 约定一些文件夹
	1. 上传图片所需的文件夹，注意文件文件上传漏洞
2. 压缩之后再传输
3. 搭建文件服务器，**但是要有验证**，因为你不能让任何人都可以下载你的模型 basic or token

API

- [ ] upload target image | target_name + image | + new line
- [ ] get training info | get the info: loss, precision, epoch, completed, **key** and so on
- [ ] download model | **key** string is the folder name of model
- [ ] retrain model
- [ ] delete model | default save the model
- [ ] get model info
- [ ] get model list key ---> model info

maybe you should build a mysql on pythono API server

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

#### 4️⃣Frontend

#### 5️⃣Windows Install or Script

#### 6️⃣如何实现自启动和权限提升

## ℹ️指标

- [x] 可以获取目标的照片 ✅ 2023-07-04
- [x] 将目标的照片输入模型 ✅ 2023-07-04
- [x] 模型输出密钥 ✅ 2023-07-04
- [x] 用密钥做 hash 然后解出载荷 ✅ 2023-07-04

## ✅ Checklist Inspiration

- [x] 完成指标的编写 #deeplocker ✅ 2023-07-04
