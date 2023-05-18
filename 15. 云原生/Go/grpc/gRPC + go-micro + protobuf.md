```shell
# Makefile
GOPATH:=$(shell go env GOPATH)

# proto1 相关指令
.PHONY: proto1
path1:
	protoc --go_out=. proto1/greeter/greeter.proto
path2:
	protoc -I. --go_out=. proto1/greeter/greeter.proto # 点号表示当前路径，注意-I参数没有等于号
path3:
	protoc --proto_path=. --go_out=. proto1/greeter/greeter.proto

```

- 需要注意版本的匹配，protobuf 的生成工具及其插件 protoc-go-gen, grpc-gen, micro-gen 最新的版本是 v4 的，注意生成的 pb 文件中的版本也要匹配（需要下载最新的代码并且编译）

# Reference
- [一文了解protoc的使用 - 掘金 (juejin.cn)](https://juejin.cn/post/6949927882126966820)
