-   Packetbeat：网络数据（收集网络流量数据）
-   Metricbeat：指标（收集系统、进程和文件系统级别的CPU和内存使用情况等数据）
-   Filebeat：日志文件（收集文件数据）
-   Winlogbeat：windows事件日志（收集Windows事件日志数据）
-   Auditbeat：审计数据（收集审计日志）
-   Heartbeat：运行时间监控（收集系统运行时的数据）

> Filebeat是用于转发和集中日志数据的轻量级传送工具。Filebeat监视您指定的日志文件或位置，收集日志事件，并将它们转发到Elasticsearch或 Logstash进行索引。

# Filebeat overview

![[Snipaste/Pasted image 20221108161837.png]]

# Quick start



# Run Filebeat on Docker
## Pull the image
```shell
docker pull docker.elastic.co/beats/filebeat:8.5.0
```
## Run the Filebeat up
```shell
docker run \
docker.elastic.co/beats/filebeat:8.5.0 \
setup -E setup.kibana.host=kibana:5601 \
-E output.elasticsearch.hosts=["elasticsearch:9200"]  
```
1. Substitute your Kibana and Elasticsearch hosts and ports.
2. If you are using the hosted Elasticsearch Service in Elastic Cloud, replace the -E output.elasticsearch.hosts line with the Cloud ID and elastic password using this syntax:

```shell
-E cloud.id=<Cloud ID from Elasticsearch Service> \
-E cloud.auth=elastic:<elastic password>
```

- Examlpe configuration file
```shell
curl -L -O https://raw.githubusercontent.com/elastic/beats/8.5/deploy/docker/filebeat.docker.yml
```
- Volume-mounted configuration
```shell
docker run -d \
  --name=filebeat \
  --user=root \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  docker.elastic.co/beats/filebeat:8.5.0 filebeat -e --strict.perms=false \
  -E output.elasticsearch.hosts=["elasticsearch:9200"]
```
1. Substitute your Elasticsearch hosts and ports.
2. If you are using the hosted Elasticsearch Service in Elastic Cloud, replace the `-E output.elasticsearch.hosts` line with the Cloud ID and elastic password using the syntax shown earlier.

## Customize with configuration
```shell
docker run \
  --label co.elastic.logs/module=apache2 \
  --label co.elastic.logs/fileset.stdout=access \
  --label co.elastic.logs/fileset.stderr=error \
  --label co.elastic.metrics/module=apache \
  --label co.elastic.metrics/metricsets=status \
  --label co.elastic.metrics/hosts='${data.host}:${data.port}' \
  --detach=true \
  --name my-apache-app \
  -p 8080:80 \
  httpd:2.4
```


## Custom image configuration
```shell
FROM docker.elastic.co/beats/filebeat:8.5.0
COPY --chown=root:filebeat filebeat.yml /usr/share/filebeat/filebeat.yml
```
# Configuration
-  /etc/filebeat/filebeat.yml

## 基本配置
```yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
```

- 如果你发送输出目录到[Elasticsearch](https://so.csdn.net/so/search?q=Elasticsearch&spm=1001.2101.3001.7020)（并且不用Logstash），那么设置IP地址和端口以便能够找到Elasticsearch：

```yml
output.elasticsearch:
    hosts: ["10.211.55.7:9200"]
```
- 如果你打算用Kibana仪表盘，可以这样配置Kibana端点：
```yml
setup.kibana:
      host: "localhost:5601"
```
- 如果你的Elasticsearch和Kibana配置了安全策略，那么在你启动Filebeat之前需要在配置文件中指定访问凭据(那么如何配置和使用这种安全策略呢？)。例如：
```yml
 output.elasticsearch:
      hosts: ["myEShost:9200"]
      username: "filebeat_internal"
      password: "{pwd}" 
setup.kibana:
      host: "mykibanahost:5601"
      username: "my_kibana_user"  
      password: "{pwd}"
```
## 配置索引
- 这里面索引配置是重要的。

### filebeat自定义索引名,filebeat索引模板
-  这个是用来放到 es 中指定索引名字的

#### filebeat默认生成到 es 索引
- 如果我们不配置则默认会生成 ，如下类格式的索引，且如果检测到有的话，会默认一直使用这个日期
```shell
filebeat-7.14.1-2021.09.24-000001
```
#### 自定义索引
- fields
- tags

#### 配置filebeat 引用模板后模板数据使用自定义索引名（mysql为例）

#### Reference
- [filebeat自定义索引名,filebeat索引模板 - 郭大侠1 - 博客园 (cnblogs.com)](https://www.cnblogs.com/gered/p/15386300.html#!comments)
- [Filebeat配置之加载Elasticsearch索引模板 - 小尾巴想看雪 - 博客园 (cnblogs.com)](https://www.cnblogs.com/qinwengang/p/10980871.html)
- [(85条消息) Filebeat相关配置_竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。的博客-CSDN博客_filebeat 配置](https://blog.csdn.net/qq_21127151/article/details/113112198?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)

# Reference
- [一篇文章搞懂filebeat（ELK） - 一寸HUI - 博客园 (cnblogs.com)](https://www.cnblogs.com/zsql/p/13137833.html)
- [elastic/beats: Beats - Lightweight shippers for Elasticsearch & Logstash (github.com)](https://github.com/elastic/beats)
- [Run Filebeat on Docker | Filebeat Reference [8.5] | Elastic](https://www.elastic.co/guide/en/beats/filebeat/current/running-on-docker.html)
- [(85条消息) Filebeat相关配置_竹杖芒鞋轻胜马，谁怕？一蓑烟雨任平生。的博客-CSDN博客_filebeat 配置](https://blog.csdn.net/qq_21127151/article/details/113112198?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)

