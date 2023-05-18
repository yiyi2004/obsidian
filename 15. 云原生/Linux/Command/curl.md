# 基本命令

- 查看网页源代码
```shell
curl www.sina.com
```
- 如果要把这个网页保存下来，可以使用`-o`参数，这就相当于使用wget命令了。

```
curl -o [文件名] www.sina.com
```

- `-i`参数可以显示http response的头信息，连同网页代码一起。

```
curl -i www.sina.com
```

- `-v`参数可以显示一次http通信的整个过程，包括端口连接和http request头信息。
```
curl -v www.sina.com
```

```
　* About to connect() to www.sina.com port 80 (#0)
　　* Trying 61.172.201.195... connected
　　* Connected to www.sina.com (61.172.201.195) port 80 (#0)
　　> GET / HTTP/1.1
　　> User-Agent: curl/7.21.3 (i686-pc-linux-gnu) libcurl/7.21.3 OpenSSL/0.9.8o zlib/1.2.3.4 libidn/1.18
　　> Host: www.sina.com
　　> Accept: */*
　　>
　　* HTTP 1.0, assume close after body
　　< HTTP/1.0 301 Moved Permanently
　　< Date: Sun, 04 Sep 2011 00:42:39 GMT
　　< Server: Apache/2.0.54 (Unix)
　　< Location: http://www.sina.com.cn/
　　< Cache-Control: max-age=3600
　　< Expires: Sun, 04 Sep 2011 01:42:39 GMT
　　< Vary: Accept-Encoding
　　< Content-Length: 231
　　< Content-Type: text/html; charset=iso-8859-1
　　< X-Cache: MISS from sh201-19.sina.com.cn
　　< Connection: close
　　<
　　<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
　　<html><head>
　　<title>301 Moved Permanently</title>
　　</head><body>
　　<h1>Moved Permanently</h1>
　　<p>The document has moved <a href="http://www.sina.com.cn/">here</a>.</p>
　　</body></html>
　　* Closing connection # boost库比较大（约120M），见百度网盘下载；或使用原链接下载 
```

- 如果你觉得上面的信息还不够，那么下面的命令可以查看更详细的通信过程。
```
curl --trace output.txt www.sina.com

curl --trace-ascii output.txt www.sina.com
```

- 发送表单信息有GET和POST两种方法。GET方法相对简单，只要把数据附在网址后面就行。
```
curl example.com/form.cgi?data=xxx
```

- POST方法必须把数据和网址分开，curl就要用到--data参数。
```
curl -X POST --data "data=xxx" example.com/form.cgi
```

- 发送 JSON POST 请求的example 通过 --data 实现，注意使用的是单引号(这是为何？)
```
curl -H "Content-Type:application/json" -H "Data_Type:msg" -X POST --data '{"dmac": "00:0C:29:EA:39:70", "alert_type": "alarm", "risk": 2, "trojan_name": "Trojan.qq3344", "smac": "00:0C:29:EA:39:66", "sub_alert_type": "trojan", "sport": 11, "id": "153189767146", "desc": "NoSecure 1.2 \u6728\u9a6c\u53d8\u79cd4\u8fde\u63a5\u64cd\u4f5c", "sip": "62.4.07.18", "dip": "139.82.31.91", "rule_id": 123451, "trojan_type": 4, "time": "2018-07-18 15:07:51", "dport": 61621, "detector_id": "170301020011", "os": "Windows", "trojan_id": 50030}' http://127.0.0.1:5000/service
```

- curl默认的HTTP动词是GET，使用`-X`参数可以支持其他动词。
```
curl -X POST www.example.com
curl -X DELETE www.example.com
```

- 文件上传
```
<form method="POST" enctype='multipart/form-data' action="upload.cgi">  
	<input type=file name=upload>  
	<input type=submit name=press value="OK">  
</form>
```
```
curl --form upload=@localfilename --form press=OK [URL]
```
- localfilename
- upload 和 press 使用的是标签的 name
	- **那如果不 OK 是什么呢？**

- **referer 目前似乎用不上，但是可以伪装来路，有时间看一看。**——给复习时候的自己
- 有时你需要在http request头信息中，提供一个referer字段，表示你是从哪里跳转过来的。
```shell
curl --referer http://www.example.com http://www.example.com
```

- **User Agent** 这个字段是用来表示客户端的设备信息。服务器有时会根据这个字段，针对不同设备，返回不同格式的网页，比如手机版和桌面版。
- iPhone4 的 User Agent 是
```
　　Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7
```

```
curl --user-agent "[User Agent]" [URL]
```
- 使用`--cookie`参数，可以让curl发送cookie。
```shell
curl --cookie "name=xxx" www.example.com
```
- 至于具体的cookie的值，可以从http response头信息的`Set-Cookie`字段中得到。
- `-c cookie-file`可以保存服务器返回的cookie到文件，`-b cookie-file`可以使用这个文件作为cookie信息，进行后续的请求。
- `-c` 保存，`-b` 保存
```
curl -c cookies http://example.com  
curl -b cookies http://example.com
```

- 有时需要在http request之中，自行增加一个头信息。`--header`参数就可以起到这个作用。
```
curl --header "Content-Type:application/json" http://example.com
```

- 有些网域需要HTTP认证，这时curl需要用到`--user`参数。
```
curl --user name:password example.com
```

# 参数说明
