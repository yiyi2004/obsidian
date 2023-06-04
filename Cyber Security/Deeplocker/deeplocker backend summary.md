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

1. 前端的开发 | react + antd(web) or [[../../Coding/Go/Third-party library/fyne/fyne|fyne]]
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
- [ ] Python API Flask，API + 有验证的文件服务器
- [ ] 接入模块的开发 ---> API ---> 打包成 APP
- [ ] 项目前端开发
- [ ] 安装程序的开发 | 安装脚本

#### 1️⃣模板开发

#### 2️⃣Python API

#### 3️⃣接入模块

#### 4️⃣Frontend

#### 5️⃣Windows Install or Script

## ✅ Checklist Inspiration

你这又是为了什么呢？做好你自己的事情，帮你
