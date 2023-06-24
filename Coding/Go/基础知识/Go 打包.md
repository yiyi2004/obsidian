```shell
# mac
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go

# windows
set CGO_ENABLED=0
set GOOS=linux
set GOARCH=amd64
go build

# centos7
chmod 773 main

./main

# 后台运行
nohup ./main 1>info.log 2>&1 &
```

- CGO_ENABLED 表示不使用 cgo
- GOOS 表示目标平台系统（Windows，linux，darwin「mac os」等等）
- GOARCH 表示目标系统架构（arm arm64 386 amd64 等等）

## Reference

- [Go打包二进制文件 - Go语言中文网 - Golang中文社区 (studygolang.com)](https://studygolang.com/articles/27112)
- [Compile and install the application - The Go Programming Language](https://go.dev/doc/tutorial/compile-install)
