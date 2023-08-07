你需要说明的几个问题

1. 数据结构
2. 数据库结构
3. 代码逻辑

## 项目架构

1. 训练服务器 (2)
	1. 训练服务的封装 (Flask)
2. 数据库
	1. Redis 缓存
	2. MySQL 存储模型信息，目标信息以及密钥信息
	3. SQLite 存储载荷 (Golang 完全封装，不需要额外安装)
3. Go 前端 (Fyne)
4. 模板：分为两个模板，一个是 and 逻辑，另一个是 or 逻辑
5. 中间件：golang 作为中间件，进行中间的数据处理

### 训练服务器

包含两台训练服务器，一台用来训练人脸识别模型，一台用来训练声音识别模型。训练框架选择 Tensorflow，用 Flask 包装深度学习服务，包含一下 API：

1. 上传目标

## 功能划分

1. 配置  
   1. 人脸识别模型训练服务器  
   2. 声音识别模型训练服务器  
   3. 输出路径  
2. 模型列表  
   1. 手动添加模型  
   2. 展示模型参数  
3. 载荷列表  
   1. 添加载荷  
   2. 展示载荷参数  
   3. 删除载荷  
4. 目标列表  
   1. 添加目标  
   2. 更新目标 (未实现)  
   3. 展示当前所有目标  
   4. 删除目标  
5. 开始训练  
   1. 开始训练人脸识别模型 (模型包含当前所有目标)  
   2. 开始训练声音识别模型 (模型包含当前所有目标)  
6. 生成  
   1. 生成恶意软件: 对于 Windows，最终生成的应该是一个 APP(目前生成到 dll 部分)，对于 Android，最终需要用 Java 打包成 APK，需要用 Golang 去调用命令行 java -jar … 去进行打包操作 (未实现)
       1. 选择 Mode，包含两种模式，标准模式代表 or 的关系，而且可以缺少某一模型，严格模式代表 and 的关系，模型选择不能缺少  
       2. IRM Sampling Duration: 代表采样人脸图像的间隔实践，单位是秒，IRM(Image Recognition Model)  
       3. VRM Sampling Duration: 代表采样音频的时间长度，单位是秒，VRM(Voice Recognition Model)  
       4. 选择操作系统，包含 Windows 和 Android  
       5. 选择人脸识别模型  
       6. 选择声音识别模型  
       7. 选择目标，根据 IRM 和 VRM 的选择会列出不同的目标，隐性功能 (未实现)  
       8. 选择载荷

## 优化

1. 数据库 SQL 优化
2. Android 的逻辑方面
3. 安全问题
4. Clear 临时文件
5. 打包成最终 APP
6. 静态变量 ---> config
7. 训练服务器代码优化

## 文件目录说明

1. 忽略一些文件时因为 Github 不推荐上传大文件，下面附有下载链接。

## FAQ

1. [tensorflow.dll](https://pan.baidu.com/s/1G_yf5PRDTwNMD08tptCWLg?pwd=7zsc) 下载

| Field | Type | Null | Key | Default | Extra |  
|---------------------|--------------|------|-----|---------|----------------|  
| id | int(11) | NO | PRI | NULL | auto_increment |  
| version | varchar(200) | YES | UNI | NULL |                |  
| key_length | int(11) | NO |     | NULL |                |  
| prec | float | NO |     | NULL |                |  
| false_positive_rate | float | NO |     | NULL |                |  
| attack_success_rate | float | NO |     | NULL |                |  
| false_negative_rate | float | NO |     | NULL |                |  
| path | varchar(200) | YES | UNI | NULL |                |  
| date | int(11) | NO |     | NULL |                |  
| description | text | NO |     | NULL |                |  

| Field       | Type         | Null | Key | Default | Extra          |
|---------------------|--------------|------|-----|---------|----------------|
| id          | int(11)      | NO   | PRI | NULL    | auto_increment |
| name        | text         | NO   |     | NULL    |                |
| random_name | varchar(20)  | YES  | UNI | NULL    |                |
| info        | longblob     | NO   |     | NULL    |                |
| image_path  | varchar(200) | YES  |     | NULL    |                |
| voice_path  | varchar(200) | YES  |     | NULL    |                |
| date        | int(11)      | NO   |     | NULL    |                |
| description | text         | NO   |     | NULL    |                |

| Field         | Type         | Null | Key | Default | Extra          |
|---------------------|--------------|------|-----|---------|----------------|
| id            | int(11)      | NO   | PRI | NULL    | auto_increment |
| key_string    | varchar(512) | NO   |     | NULL    |                |
| model_id      | int(11)      | NO   |     | NULL    |                |
| model_version | text         | NO   |     | NULL    |                |
| target_id     | int(11)      | NO   |     | NULL    |                |
| random_name   | varchar(20)  | YES  |     | NULL    |                |
| date          | int(11)      | NO   |     | NULL    |                |
| description   | text         | NO   |     | NULL    |                |
