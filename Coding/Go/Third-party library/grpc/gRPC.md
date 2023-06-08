## 微服务架构

![[../../Snipaste/Pasted image 20220923154932.png]]  
![[../../Snipaste/Pasted image 20220923154950.png]]

- 网关，不能让用户记录太多的 端口，要有入口的一致性。统一的功能放在网关上。
- 公共的功能抽取出来，服务拆分。

![[../../Snipaste/Pasted image 20220923155234.png]]

- 网络调用：RPC
- 引入服务治理

![[../../Snipaste/Pasted image 20220923155433.png]]

- 服务发现
- 注册中心

![[../../Snipaste/Pasted image 20220923155524.png]]

- 服务容错
- 链路追踪

- [ ] 我觉得你很适合上午读书，下午上课，晚上上课 + 总结 + 娱乐 。其实一系列东西都是有的。

## gRPC

![[../../Snipaste/Pasted image 20220923155817.png]]

- 在网络上传输要先进行序列化

## Protobuf

![[../../Snipaste/Pasted image 20220923155932.png]]

![[../../Snipaste/Pasted image 20220923160203.png]]

- 此处说的应该不对，我测试过程中，最后 service 生成的位置是在 go_out 指向的路径基础上再去找到 go_package 的路径，相当于是 2 个拼在一起

![[../../Snipaste/Pasted image 20220923160727.png]]

![[../../Snipaste/Pasted image 20220923160748.png]]

![[../../Snipaste/Pasted image 20220923160900.png]]

## gRPC 实例

![[../../Snipaste/Pasted image 20220923161037.png]]

![[../../Snipaste/Pasted image 20220923161106.png]]  
![[../../Snipaste/Pasted image 20220923162128.png]]  
![[../../Snipaste/Pasted image 20220923162239.png]]  
![[../../Snipaste/Pasted image 20220923162305.png]]

- gRPC 用到的协议竟然是 HTTP2

![[../../Snipaste/Pasted image 20220923162512.png]]  
![[../../Snipaste/Pasted image 20220923162541.png]]  
![[../../Snipaste/Pasted image 20220923162600.png]]  
![[../../Snipaste/Pasted image 20220923162710.png]]

- HTTP2 需要学习一下哦。
- HTTP 不够高效，但是足够通用，可以应用在很多场景下。

![[../../Snipaste/Pasted image 20220923162907.png]]  
![[../../Snipaste/Pasted image 20220923163057.png]]  
![[../../Snipaste/Pasted image 20220923163226.png]]

- Istio
- RPC 与 gRPC

## 认证

![[../../Snipaste/Pasted image 20220925171153.png]]

## 官方文档

- 虽然但是，文档里面的命令已经和教程不太一样了，但仅仅是更改了一个写法而已。

### 命令行参数

```shell
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative .\routeguide\*.proto
```

- 注意是 go-grpc_opt 哦！

![[../../Snipaste/Pasted image 20220925164250.png]]

- you should new a grpc server and tell it what the server is with service.ProductService
- the you can listen on you ip:port
- tips: .var
- Service

```go
import "google.golang.org/grpc"

  

func main()  {

  server := grpc.NewServer()

  service.RegisterProdServiceServer(server,service.ProductService)

  

  listener, err := net.Listen("tcp", ":8002")

  if err != nil {

    log.Fatal("服务监听端口失败", err)

  }

  _ = server.Serve(listener)

}
```

- Client

```go
func main()  {

  // 1. 新建连接，端口是服务端开放的8002端口

  // 没有证书会报错

  conn, err := grpc.Dial(":8002", grpc.WithTransportCredentials(insecure.NewCredentials()))
  if err != nil {
    log.Fatal(err)
  }

  // 退出时关闭链接
  defer conn.Close()

  // 2. 调用Product.pb.go中的NewProdServiceClient方法
  productServiceClient := service.NewProdServiceClient(conn)

  // 3. 直接像调用本地方法一样调用GetProductStock方法
  resp, err := productServiceClient.GetProductStock(context.Background(), &service.ProductRequest{ProdId: 233})

  if err != nil {
    log.Fatal("调用gRPC方法错误: ", err)
  }
  fmt.Println("调用gRPC方法成功，ProdStock = ", resp.ProdStock)

}
```

1. 构建连接
2. new 客户端
3. 通过客户端去调用服务端的服务

### 文件结构说明

- `oute_guide.pb.go`, which contains all the protocol buffer code to populate, serialize, and retrieve request and response message types.
- `route_guide_grpc.pb.go`, which contains the following:
    - An interface type (or _stub_) for clients to call with the methods defined in the `RouteGuide` service.
    - An interface type for servers to implement, also with the methods defined in the `RouteGuide` service.

There are two parts to making our `RouteGuide` service do its job:

1. **Implementing the service interface** generated from our service definition: doing the actual “work” of our service.
2. **Running a gRPC server** to listen for requests from clients and dispatch them to the right service implementation.

## Reference

- [【码神之路】gRPC系列完整教程，go语言集成，十年大厂程序员讲解，通俗易懂_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV16Z4y117yz/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- 笔记放在 Go 文件夹 gRPC 中了哦
