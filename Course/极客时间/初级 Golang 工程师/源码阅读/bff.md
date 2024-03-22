## 配置信息

服务注册与发现

```yaml
http:
  addr: ":8080"
etcd:
  endpoints:
    - "localhost:12379"
grpc:
#  使用 etcd 来作为服务发现
#  配置客户端的时候一定要小心端口，要填对
#  当然对应的服务也要启动起来
  client:
    user:
      target: "etcd:///service/user"
    article:
      target: "etcd:///service/article"
    code:
      target: "etcd:///service/code"
    intr:
      target: "etcd:///service/interactive"
    reward:
      target: "etcd:///service/reward"
```

## Ioc

## Web

## Main
