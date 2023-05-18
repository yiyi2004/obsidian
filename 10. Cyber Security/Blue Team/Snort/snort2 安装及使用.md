```shell
 ./snort -dev -l ./log -h 192.168.116.0/24 -c snort.conf
```

- shell 脚本
```shell
apt-get install -y build-essential
apt-get install -y bison flex
apt-get install -y libpcap-dev libpcre3-dev libdumbnet-dev

mkdir /root/snort2_src
cd /root/snort2_src

wget http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz
tar xzvf libpcap-1.8.1.tar.gz
cd libpcap-1.8.1
./configure && make && make install
cd ..

wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar xzvf daq-2.0.7.tar.gz 
cd daq-2.0.7
./configure && make && make install
cd ..

aptitude install zlib1g-dev
apt install zlib1g-dev

# 这是为何，为什么安装不了。
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar zxvf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5/
make && make install

wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar xzvf snort-2.9.20.tar.gz
cd snort-2.9.20
./configure --enable-sourcefire --disable-open-appid && make && make install
```

- 需要进行基本的配置
- 文件目录结构
- apt install tree

```shell
user@snortserver:~$ tree /etc/snort
/etc/snort
├── attribute_table.dtd
├── classification.config
├── file_magic.conf
├── gen-msg.map
├── preproc_rules
├── reference.config
├── rules
│.. ├── local.rules
│.. ├── iplists
│    .. ├── black_list.rules
│    .. ├── white_list.rules
├── sid-msg.map
├── snort.conf
├── so_rules
├── threshold.conf
└── unicode.map
```

```shell
sudo /usr/local/bin/snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i ens33
```

# Database

| Tables_in_snort  |
| ---------------- |
| data             |
| detail           |
| encoding         |
| event            |
| icmphdr          |
| iphdr            |
| opt              |
| reference        |
| reference_system |
| schema           |
| sensor           |
| sig_class        |
| sig_reference    |
| signature        |
| tcphdr           |
| udphdr           |

- data

| Field        | Type             | Null | Key | Default | Extra |
| ------------ | ---------------- | ---- | --- | ------- | ----- |
| sid          | int(10) unsigned | NO   | PRI | NULL    |       |
| cid          | int(10) unsigned | NO   | PRI | NULL    |       |
| data_payload | text             | YES  |     | NULL    |       |

- detail

| Field       | Type                | Null | Key | Default | Extra |
| ----------- | ------------------- | ---- | --- | ------- | ----- |
| detail_type | tinyint(3) unsigned | NO   | PRI | NULL    |       |
| detail_text | text                | NO   |     | NULL    |       |

- encoding

| Field         | Type                | Null | Key | Default | Extra |
| ------------- | ------------------- | ---- | --- | ------- | ----- |
| encoding_type | tinyint(3) unsigned | NO   | PRI | NULL    |       |
| encoding_text | text                | NO   |     | NULL    |       |

- event

| Field     | Type             | Null | Key | Default | Extra |
| --------- | ---------------- | ---- | --- | ------- | ----- |
| sid       | int(10) unsigned | NO   | PRI | NULL    |       |
| cid       | int(10) unsigned | NO   | PRI | NULL    |       |
| signature | int(10) unsigned | NO   | MUL | NULL    |       |
| timestamp | datetime         | NO   | MUL | NULL    |       |

- icmphdr

| Field     | Type                 | Null | Key | Default | Extra |
| --------- | -------------------- | ---- | --- | ------- | ----- |
| sid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| cid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| icmp_type | tinyint(3) unsigned  | NO   | MUL | NULL    |       |
| icmp_code | tinyint(3) unsigned  | NO   |     | NULL    |       |
| icmp_csum | smallint(5) unsigned | YES  |     | NULL    |       |
| icmp_id   | smallint(5) unsigned | YES  |     | NULL    |       |
| icmp_seq  | smallint(5) unsigned | YES  |     | NULL    |       |

- iphdr

| Field    | Type                 | Null | Key | Default | Extra |
| -------- | -------------------- | ---- | --- | ------- | ----- |
| sid      | int(10) unsigned     | NO   | PRI | NULL    |       |
| cid      | int(10) unsigned     | NO   | PRI | NULL    |       |
| ip_src   | int(10) unsigned     | NO   | MUL | NULL    |       |
| ip_dst   | int(10) unsigned     | NO   | MUL | NULL    |       |
| ip_ver   | tinyint(3) unsigned  | YES  |     | NULL    |       |
| ip_hlen  | tinyint(3) unsigned  | YES  |     | NULL    |       |
| ip_tos   | tinyint(3) unsigned  | YES  |     | NULL    |       |
| ip_len   | smallint(5) unsigned | YES  |     | NULL    |       |
| ip_id    | smallint(5) unsigned | YES  |     | NULL    |       |
| ip_flags | tinyint(3) unsigned  | YES  |     | NULL    |       |
| ip_off   | smallint(5) unsigned | YES  |     | NULL    |       |
| ip_ttl   | tinyint(3) unsigned  | YES  |     | NULL    |       |
| ip_proto | tinyint(3) unsigned  | NO   |     | NULL    |       |
| ip_csum  | smallint(5) unsigned | YES  |     | NULL    |       |

- opt

| Field     | Type                | Null | Key | Default | Extra |
| --------- | ------------------- | ---- | --- | ------- | ----- |
| sid       | int(10) unsigned    | NO   | PRI | NULL    |       |
| cid       | int(10) unsigned    | NO   | PRI | NULL    |       |
| optid     | int(10) unsigned    | NO   | PRI | NULL    |       |
| opt_proto | tinyint(3) unsigned | NO   |     | NULL    |       |
| opt_code  | tinyint(3) unsigned | NO   |     | NULL    |       |
| opt_len   | smallint(6)         | YES  |     | NULL    |       |
| opt_data  | text                | YES  |     | NULL    |       |

- reference

| Field         | Type             | Null | Key | Default | Extra          |
| ------------- | ---------------- | ---- | --- | ------- | -------------- |
| ref_id        | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| ref_system_id | int(10) unsigned | NO   |     | NULL    |                |
| ref_tag       | text             | NO   |     | NULL    |                |

- reference_system

| Field           | Type             | Null | Key | Default | Extra          |
| --------------- | ---------------- | ---- | --- | ------- | -------------- |
| ref_system_id   | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| ref_system_name | varchar(20)      | YES  |     | NULL    |                |

- schema：创建数据表的命令

- sensor

| Field     | Type             | Null | Key | Default | Extra          |
| --------- | ---------------- | ---- | --- | ------- | -------------- |
| sid       | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| hostname  | text             | YES  |     | NULL    |                |
| interface | text             | YES  |     | NULL    |                |
| filter    | text             | YES  |     | NULL    |                |
| detail    | tinyint(4)       | YES  |     | NULL    |                |
| encoding  | tinyint(4)       | YES  |     | NULL    |                |
| last_cid  | int(10) unsigned | NO   |     | NULL    |                |

- sig_class

| Field          | Type             | Null | Key | Default | Extra          |
| -------------- | ---------------- | ---- | --- | ------- | -------------- |
| sig_class_id   | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| sig_class_name | varchar(60)      | NO   | MUL | NULL    |                |

- sig_reference

| Field   | Type             | Null | Key | Default | Extra |
| ------- | ---------------- | ---- | --- | ------- | ----- |
| sig_id  | int(10) unsigned | NO   | PRI | NULL    |       |
| ref_seq | int(10) unsigned | NO   | PRI | NULL    |       |
| ref_id  | int(10) unsigned | NO   |     | NULL    |       |

- signature

| Field        | Type             | Null | Key | Default | Extra          |
| ------------ | ---------------- | ---- | --- | ------- | -------------- |
| sig_id       | int(10) unsigned | NO   | PRI | NULL    | auto_increment |
| sig_name     | varchar(255)     | NO   | MUL | NULL    |                |
| sig_class_id | int(10) unsigned | NO   | MUL | NULL    |                |
| sig_priority | int(10) unsigned | YES  |     | NULL    |                |
| sig_rev      | int(10) unsigned | YES  |     | NULL    |                |
| sig_sid      | int(10) unsigned | YES  |     | NULL    |                |
| sig_gid      | int(10) unsigned | YES  |     | NULL    |                |

- tcphdr

| Field     | Type                 | Null | Key | Default | Extra |
| --------- | -------------------- | ---- | --- | ------- | ----- |
| sid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| cid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| tcp_sport | smallint(5) unsigned | NO   | MUL | NULL    |       |
| tcp_dport | smallint(5) unsigned | NO   | MUL | NULL    |       |
| tcp_seq   | int(10) unsigned     | YES  |     | NULL    |       |
| tcp_ack   | int(10) unsigned     | YES  |     | NULL    |       |
| tcp_off   | tinyint(3) unsigned  | YES  |     | NULL    |       |
| tcp_res   | tinyint(3) unsigned  | YES  |     | NULL    |       |
| tcp_flags | tinyint(3) unsigned  | NO   | MUL | NULL    |       |
| tcp_win   | smallint(5) unsigned | YES  |     | NULL    |       |
| tcp_csum  | smallint(5) unsigned | YES  |     | NULL    |       |
| tcp_urp   | smallint(5) unsigned | YES  |     | NULL    |       |

- udphdr

| Field     | Type                 | Null | Key | Default | Extra |
| --------- | -------------------- | ---- | --- | ------- | ----- |
| sid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| cid       | int(10) unsigned     | NO   | PRI | NULL    |       |
| udp_sport | smallint(5) unsigned | NO   | MUL | NULL    |       |
| udp_dport | smallint(5) unsigned | NO   | MUL | NULL    |       |
| udp_len   | smallint(5) unsigned | YES  |     | NULL    |       |
| udp_csum  | smallint(5) unsigned | YES  |     | NULL    |       |


# Reference
- [(130条消息) Centos7下安装SNORT_xiaopan233的博客-CSDN博客_centos安装snort](https://blog.csdn.net/xiaopan233/article/details/83478356?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166495105516800184133573%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166495105516800184133573&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-2-83478356-null-null.142^v51^control,201^v3^add_ask&utm_term=centos%20%E5%AE%89%E8%A3%85%20snort&spm=1018.2226.3001.4187)
- [(130条消息) 「干货」Snort使用手册「详细版」_橙留香Park的博客-CSDN博客_snort教程](https://blog.csdn.net/Ananas_Orangey/article/details/122619481?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166495244116800180652466%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166495244116800180652466&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-122619481-null-null.142^v51^control,201^v3^add_ask&utm_term=snort%20%E6%95%99%E7%A8%8B&spm=1018.2226.3001.4187)
- [(144条消息) Ubuntu18.04 安装 Snort_半砖的博客-CSDN博客_ubuntu snort 编译安装](https://blog.csdn.net/hexf9632/article/details/109285282?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)
- [Snort 2.9.9.x on Ubuntu – Part 1: Installing Snort – Sublime Robots](http://sublimerobots.com/2017/01/snort-2-9-9-x-ubuntu-installing-snort/)
- [Ubuntu 16.04安装snort含问题解决 - 褐鹤 - 博客园 (cnblogs.com)](https://www.cnblogs.com/browncrane/p/11692086.html)
