- 有的官方文档写的这么烂, 真的是折磨开发者.
- 我们需要的是可以解决问题的人, 而不仅仅是可以按照要求去写接口的程序员.


# OSSEC主要功能及原理+详细配置+日志文件分析
- 基于主机的入侵检系统
- 基于应用的入侵检测系统

## OSSEC主要功能及原理

![[Pasted image 20221025151059.png]]
![[Pasted image 20221025151524.png]]

# Install



# Task
- [x] 配置数据库

# Development

## 数据库表结构

| Tables_in_ossec            |
| -------------------------- |
| agent                      |
| alert                      |
| category                   |
| location                   |
| server                     |
| signature                  |
| signature_category_mapping |


- agent

| Field        | Type                 | Null | Key | Default | Extra          |
| ------------ | -------------------- | ---- | --- | ------- | -------------- |
| id           | smallint(5) unsigned | NO   | PRI | NULL    | auto_increment |
| server_id    | smallint(5) unsigned | NO   | PRI | NULL    |                |
| last_contact | int(10) unsigned     | NO   |     | NULL    |                |
| ip_address   | varchar(46)          | NO   |     | NULL    |                |
| version      | varchar(32)          | NO   |     | NULL    |                |
| name         | varchar(64)          | NO   |     | NULL    |                |
| information  | varchar(128)         | NO   |     | NULL    |                |

- alert

| Field       | Type                  | Null | Key | Default | Extra          |
| ----------- | --------------------- | ---- | --- | ------- | -------------- |
| id          | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| server_id   | smallint(5) unsigned  | NO   | PRI | NULL    |                |
| rule_id     | mediumint(8) unsigned | NO   | MUL | NULL    |                |
| level       | tinyint(3) unsigned   | YES  | MUL | NULL    |                |
| timestamp   | int(10) unsigned      | NO   | MUL | NULL    |                |
| location_id | smallint(5) unsigned  | NO   |     | NULL    |                |
| src_ip      | varchar(46)           | YES  | MUL | NULL    |                |
| dst_ip      | varchar(46)           | YES  |     | NULL    |                |
| src_port    | smallint(5) unsigned  | YES  |     | NULL    |                |
| dst_port    | smallint(5) unsigned  | YES  |     | NULL    |                |
| alertid     | varchar(30)           | YES  | MUL | NULL    |                |
| user        | text                  | NO   |     | NULL    |                |
| full_log    | text                  | NO   |     | NULL    |                |
| is_hidden   | tinyint(4)            | NO   |     | 0       |                |
| tld         | varchar(5)            | NO   | MUL |         |                |
|             |                       |      |     |         |                |

- category

| Field    | Type             | Null | Key | Default | Extra          |
| -------- | ---------------- | ---- | --- | ------- | -------------- |
| cat_id   | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| cat_name | varchar(32)      | NO   | UNI | NULL    |                |

- location

| Field     | Type                 | Null | Key | Default | Extra          |
| --------- | -------------------- | ---- | --- | ------- | -------------- |
| id        | smallint(5) unsigned | NO   | PRI | NULL    | auto_increment |
| server_id | smallint(5) unsigned | NO   | PRI | NULL    |                |
| name      | varchar(128)         | NO   |     | NULL    |                |

- server

| Field        | Type                 | Null | Key | Default | Extra          |
| ------------ | -------------------- | ---- | --- | ------- | -------------- |
| id           | smallint(5) unsigned | NO   | PRI | NULL    | auto_increment |
| last_contact | int(10) unsigned     | NO   |     | NULL    |                |
| version      | varchar(32)          | NO   |     | NULL    |                |
| hostname     | varchar(64)          | NO   | UNI | NULL    |                |
| information  | text                 | NO   |     | NULL    |                |

- signature

| Field       | Type                  | Null | Key | Default | Extra          |
| ----------- | --------------------- | ---- | --- | ------- | -------------- |
| id          | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| rule_id     | mediumint(8) unsigned | NO   | UNI | NULL    |                |
| level       | tinyint(3) unsigned   | YES  | MUL | NULL    |                |
| description | varchar(255)          | NO   |     | NULL    |                |

- signature_category_mapping

| Field   | Type                  | Null | Key | Default | Extra          |
| ------- | --------------------- | ---- | --- | ------- | -------------- |
| id      | int(10) unsigned      | NO   | PRI | NULL    | auto_increment |
| rule_id | mediumint(8) unsigned | NO   | PRI | NULL    |                |
| cat_id  | smallint(5) unsigned  | NO   | PRI | NULL    |                |


#  Reference
- [(142条消息) OSSEC搭建部署(ossec-server(CentOS7.X)和ossec-agent(CentOS7.X))_小胡yhu的博客-CSDN博客_ossec](https://blog.csdn.net/weixin_44304678/article/details/123611442?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166660557316782390555102%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166660557316782390555102&biz_id=0&spm=1018.2226.3001.4187)
- [(143条消息) OSSEC主要功能及原理+详细配置+日志文件分析_AlexTan_的博客-CSDN博客_ossec](https://blog.csdn.net/AlexTan_/article/details/52080171?spm=1001.2101.3001.6661.1&depth_1-utm_relevant_index=1)
- [Output and Alert options — OSSEC](https://www.ossec.net/docs/docs/manual/output/index.html)
- [(143条消息) MariaDB 在 Ubuntu16.04 LTS上的安装_林微的博客-CSDN博客](https://blog.csdn.net/Canhui_WANG/article/details/79725250)
- [(143条消息) MySQL修改root密码的4种方法_刘广顺的博客-CSDN博客_mysql修改密码](https://blog.csdn.net/qq_33285112/article/details/78982766)
- [Sending output to a Database — OSSEC](https://www.ossec.net/docs/docs/manual/output/database-output.html)

