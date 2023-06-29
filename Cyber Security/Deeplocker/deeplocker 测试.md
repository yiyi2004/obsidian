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

两个核心：

1. 我们要测试什么
2. 怎么测试

## Content

### Video

- [ ] Video + Txt

```powershell
go run main.go --test video --kind txt
```

- [ ] Video + Jpg

```powershell
go run main.go --test video --kind jpg
```

- [ ] Video + Wav

```powershell
go run main.go --test video --kind wav
```

- [ ] Video + Mp4

```powershell
go run main.go --test video --kind mp4
```

### Audio

加密部分代码要进行切换，或者就直接分成两个不同的加密文件。

- [ ] Audio + Txt

```powershell
go run main.go --test audio --kind txt
```

- [ ] Audio + Jpg

```powershell
go run main.go --test audio --kind jpg
```

- [ ] Audio + Wav

```powershell
go run main.go --test audio --kind wav
```

- [ ] Audio + Mp4

```powershell
go run main.go --test audio --kind mp4
```

### 脚本

## Reference
