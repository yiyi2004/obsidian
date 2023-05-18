最后画图是为了总结，理清楚代码的思路。你是一个造物主，这种开源代码相当于模板，可以帮助你更快的成长

# 架构



# Agent
- os/exec 执行系统命令
- [regexp](https://gobyexample.com/regular-expressions)：就是普通的正则表达式

## Monitor
	行为监控（文件操作、网络连接、执行命令）
- 监控四个部分

### config.go
- 进程、端口、文件一些配置，配置白名单
![[Pasted image 20221023103749.png]]

### connection_linux.go
进行网络网络行为的检测，使用了 cgo 的技术，但是我不理解为什么会有 cgo 的技术存在，明明 go 就可以实现所有功能的说。
- connection_windows.go

- [ ] 为什么这里会用 CGO 呢？有些 C 能实现的功能 Go 没办法实现，比如获取网络信息，进程信息 ，这样说是合理的 ，因为 Go 会防止用户进行一些危险的行为，导致内存泄漏，防止被黑客攻击。

- file.go: 文件行为的监控
- lib.go: 监测动态链接库

## Common
- ClientConfig: agent configure
- ComputerInfo

你的效率太低了，不要把时间花在花里胡哨的东西上面。

## Collect
	信息收集（开机启动项、计划任务、监听端口、服务、登录日志、用户列表）

- computerinfo_linux.go
- computerinfo_windows.go
	- crontab.go
- crontab_linux.go 获取计划任务
```go
// 系统计划任务
dat, err := ioutil.ReadFile("/etc/crontab")

// 用户计划任务
dir, err := ioutil.ReadDir("/var/spool/cron/")
```
- crontab_windows.go
```go
// 获取系统计划任务
var taskPath string
if runtime.GOARCH == "386" {
	taskPath = `C:\Windows\SysNative\Tasks\`
} else {
	taskPath = `C:\Windows\System32\Tasks\`
}
```
- listen_linux.go 获取tcp端口监听端口
```go
    listeningStr := common.Cmdexec("ss -nltp")
    listeningList := strings.Split(listeningStr, "\n")
```
![[Pasted image 20221023151424.png]]
- 执行 ss -nltp

- loginlog_linux.go
	- getLast:     wtmpFile, err := os.Open("/var/log/wtmp")
	- GetLoginLog ---> 获取登陆日志(但是我不了解是怎么获取的，这是一个 binary file)

- process_linux.go:     dirs, err = dirsUnder("/proc")
	- 文件夹下面包含了各个进程的信息

- service_linux.go
- startup_linux.go
- 上面两个 linux 系统下未实现，windows 下实现了，可能是 windows 独有的。

- user_linux.go 获取系统用户列表    
	- dat, err := ioutil.ReadFile("/etc/passwd")

- webpath_linux.go 待支持其他webserver
	- httpd apache nginx
	- 可是 httpd 不就是 apache

## Client
	RPC client 传输模块
- config.go RPC 一些配置信息
- agent.go
	- time.NewTricker
	- configRefresh 隔一段时间更新初始化设置(避免系统遭受攻击，没有办法及时处理)
	- monitor 开启各个监控流程 文件监控，网络监控，进程监控
	- getInfo 每隔一段时间获取系统信息，监听端口，服务信息，用户信息，开机启动项，计划任务，登录信息，进程列表等

----

# Daemon



# Server
```GO
    safecheck.ScanChan <- *datainfo
```
- 对 agent 传输过来得数据进行检查

- init
```go
    // 启动心跳线程
    go models.Heartbeat()

    // 启动推送任务线程
    go action.TaskThread()

    // 启动安全检测线程
    go safecheck.ScanMonitorThread()

    // 启动客户端健康检测线程
    go safecheck.HealthCheckThread()

    // ES异步写入线程
    go models.InsertThread()
```


## Action

## Models
- models ---> action
- models ---> safecheck
- models 是其他模块的基础。
- [Go official ES](https://github.com/elastic/go-elasticsearch)

common.go
- 连接 mongodb 的数据库
- server config
- RuleDB 存放在 MongoDB 中的规则库

```go
// DataInfo 从agent接收数据的结构
type DataInfo struct {
	IP     string
	Type   string
	System string
	Data   []map[string]string
	Uptime time.Time
}
```

- 不知道你现在怎么样了呢。你对我真的还有感情嘛，我那时不懂事，总是回避。


## SafeCheck



# Web
- gopkg.in/mgo.v2/bson
- mongodb

# Elasticsearch

# System hook
- 系统钩子

# 胡说八道
- 其实 C++ 是值得学的，而且 C++ 可以和 Go 进行联动进行操作，但是 Go 的官方包封装的已经很不错了。

# 待解决的问题
- [ ] mongodb document database
- [ ] ELK stack

# Reference
- [ysrc/yulong-hids-archived: [archived] 一款实验性质的主机入侵检测系统 (github.com)](https://github.com/ysrc/yulong-hids-archived)
