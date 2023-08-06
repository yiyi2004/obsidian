- Time：2023-06-21 08:25
- Label： #deeplocker #test #go

## Abstract

- 注意加切换样本的时候要**删除文件**
- 回去之后尽量**多测试几次**，万一有问题要尽快解决了

操作步骤

1. 修改 payload 的后缀 **suffix**
2. 加密 payload
3. 将加密后的 payload 传播到靶机相应的位置 (提前预置好的）

接下来是操作过程：

1. 完成启动操作，例如 `go run main.go --test video --kind txt`
2. 然后演示不同的人坐在相机前、或者麦克风前进行测试 —— 结果是打咩
3. 然后请 **目标** 进行测试，结果是释放载荷

---

两个核心：

1. 我们要测试什么
2. 怎么测试

### 基本介绍

Windows 这部分要进行两类测试，一个是基于**人脸识别模型的载荷激活**测试，另一个是**基于声音识别模型的载荷激活**测试。每一类测试分别包含四种载荷，分别是文本、图片、视频和音频载荷。载荷的展示在我们测试过程中，包括加密载荷的展示，因为载荷一开始是处于攻击机上面的。

Windows 激活程序测试这部分包含**两台笔记本**，一台是这个 Windows11 机器作为靶机，另一台是这台 Mac 作为攻击机。

以上是对 Windows 载荷激活程序测试的简要说明，我们接下来先测试**基于人脸识别的载荷激活程序**，然后测试**基于声音识别的载荷激活程序**。

因为载荷植入过程在每个测试过程中都会有，所以第一个测试项即**载荷植入**会在测试过程中体现。

四种载荷的测试顺序是：  

1. 图片载荷
2. 文本载荷
3. 音频载荷
4. 视频载荷

### 测试流程

**测试流程**是这样的：

1. 植入载荷
2. 启动激活程序
3. 测试非目标的效果 (预期效果是不能释放载荷)
4. 测试目标的效果 (预期效果是可以释放载荷)

然后我们每个测试项都会重复上述过程。

## Content

### Video

基于**人脸识别**模型的**图片**载荷激活程序

- [x] Video + Jpg

```powershell
go run main.go --test video --kind jpg
```

基于**人脸识别**模型的**文本**载荷激活程序

- [x] Video + Txt

```powershell
go run main.go --test video --kind txt
```

基于**人脸识别**模型的**音频**载荷激活程序

- [x] Video + Wav

```powershell
go run main.go --test video --kind wav
```

基于**人脸识别**模型的**视频**载荷激活程序

- [x] Video + Mp4

```powershell
go run main.go --test video --kind mp4
```

### Audio

基于**声音识别**模型的**图片**载荷激活程序

- [x] Audio + Jpg

```powershell
go run main.go --test audio --kind jpg
```

基于**声音识别**模型的**文本**载荷激活程序

- [x] Audio + Txt

```powershell
go run main.go --test audio --kind txt
```

基于**声音识别**模型的**音频**载荷激活程序

- [x] Audio + Wav

```powershell
go run main.go --test audio --kind wav
```

基于**声音识别**模型的**视频**载荷激活程序

- [x] Audio + Mp4

```powershell
go run main.go --test audio --kind mp4
```

### 脚本

## Reference
