- Time：2023-06-25 10:32
- Label： #go #IM

## Abstract

Go 及时通讯的实现。真让人头秃。

## Content

文件会比较多（磁盘的 IO）。 阿里云 OOS (Object Storage Service) 海量，安全，低成本，高速，可靠云存储。

- OOS API：http://doc.oss.aliyuncs.com/#_Toc336676738
- 登录阿里云 https://oss.console.aliyun.com/bucket
- 参考代码: https://help.aliyun.com/document_detail/88601.htm?spm=a2c4g.11186623.0.0.1d8f2cb7wXZMVL#section-4yj-fxf-vaj
- Key socket ：https://ram.console.aliyun.com/manage/ak?spm=a2c8b.12215442.top-nav.dak.18fb336aZdJlJ4  

```shell
go get github.com/aliyun/aliyun-oss-go-sdk/oss
```

## Reference

- [gin-swagger](https://github.com/swaggo/gin-swagger)
- [viper](https://github.com/spf13/viper)
- [go-websocker](https://github.com/gorilla/websocket)
- [Redis Client for Go](https://github.com/redis/go-redis)
