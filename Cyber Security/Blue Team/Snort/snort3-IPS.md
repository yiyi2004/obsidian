介绍
本指南向您展示了如何在Ubuntu上使用Splunk将Snort 3设置为网络入侵检测系统(NIDS)和安全信息和事件管理(SIEM)系统。本指南的目的是向您介绍组成基于Snort和Splunk的NIDS和SIEM的组件和选项，以便您可以修改Snort和Splunk以满足您的特定需求。您可以通过复制和粘贴本指南中的各个步骤来安装Snort和Splunk，而不需要花时间了解自己在做什么，这样可以很好地工作。但是，如果您花时间理解为什么要执行每个步骤，那么您应该对Snort和Splunk的工作方式有更深入的理解。

关于Snort 3: Snort 3是基于规则的网络入侵检测和预防软件(NIDS/NIPS)。它具有高度的灵活性和可配置性，可适应多种不同的情况，并且具有新的插件体系结构，允许开发人员创建自己的插件，以便在Snort的处理管道中使用。本指南将重点介绍Snort最常见的用法:作为一个独立服务器，将网络流量与一组规则(称为规则集)进行比较，以检测可疑和可能的恶意流量，并对可疑流量生成警报。

关于Splunk: Splunk是一个收集安全信息和事件管理(SIEM)的系统。存储并允许您轻松地分析和可视化计算机生成的数据，包括由Snort创建的警报。本指南将使用Splunk以图形方式显示Snort警报，提供过滤和搜索功能，并帮助您基本了解Splunk是如何成为理解机器生成数据的强大工具的。

OpenApplD：OpenAppID允许Snort识别、控制和度量网络上使用的应用程序。OpenApplD由一组匹配特定类型网络数据的包(签名)组成，包括第7层应用程序，如Facebook, DNS, netflix, discus，谷歌，以及使用这些服务的应用程序(chrome, http, https等)。您可以基于这些OpenApplD签名创建规则，从而允许您阻止与某些应用程序相匹配的流量(例如，阻止所有Facebook流量)。

Snort 2 vs Snort 3: Snort 3是对Snort产品的完全重新设计，以解决Snort 2.9.x的一些限制。一些主要的要点是多线程、可扩展的插件架构、基于lua的配置文件、命令行shell和许多其他特性。更多信息可以在这里找到。

软件要求:本指南已经在64位版本的Ubuntu server 18和20上进行了测试。这个指南还没有在32位版本的Ubuntu服务器上测试过，因为Splunk服务器不能安装在32位平台上。要启动Splunk，在安装它的驱动器上至少需要5gb的可用空间(通常是/opt/ Splunk)。

我还没有在其他基于debian的系统(包括Raspberry Pi)上测试过本指南，尽管我收到报告说，在安装和编译先决条件时，只需做很少的修改就可以使其工作。

如果你必须安装Snort在32位系统上,你有几个选择:安装32位轻量级Splunk通用货代(超滤),服务器通过日志回到你Splunk服务器,Snort json日志复制到另一个服务器进行索引,或者使用NFS共享日志目录(安全地)Splunk服务器可以看到和索引方法。

对于尚未可用的全栈Snort 3.0 NIDS/NIPS，唯一需要的软件是PulledPork，它执行规则集管理(自动下载最新的规则集以及其他管理工作)。一旦PulledPork被更新为适用于Snort 3.0，我将更新这个指南。

对于旧版本的Ubuntu，Snort 3不能方便地安装在早期版本的Ubuntu上，因为默认存储库中没有所需的支持软件版本，所以当遇到错误时，您需要手动编译所需的库(比如GCC)。

警告:Snort 3是测试版软件。不应该在生产系统中使用它。由于Snort 3目前正在开发中:自编写本指南以来，您下载的Snort 3版本可能经历了修改，从而导致编译或配置方面的问题。

支持:请在Snort分发列表中寻求帮助:

Snort用户
Snort OpenAppID
Snort开发者
大多数请求都应该发送到Snort用户列表，除非与OpenApplD相关或与代码基有关的问题。请阅读如何问一个好问题和了解邮寄名单礼仪。

安装Snort
首先，确保您的系统是最新的，并有最新的包列表:

sudo apt-get update && sudo apt-get dist-upgrade -y
确保你的系统有正确的时间和时区。这在稍后我们开始使用Splunk处理警报时非常重要。下面的命令将允许您选择您的时区。在选择您的地区和时区后，它将显示当前时间。请确保这些都是正确的:

sudo dpkg-reconfigure tzdata
我们将下载大量的源文件压缩包和其他源文件，我们希望将它们存储在一个文件夹中：

mkdir ~/snort_src
cd ~/snort_src
安装Snort 3先决条件。这些包的详细信息可以在Snort3手册的需求部分找到:

sudo apt-get install -y build-essential autotools-dev libdumbnet-dev \
libluajit-5.1-dev libpcap-dev zlib1g-dev pkg-config libhwloc-dev \
cmake
接下来安装可选(但强烈推荐的软件):

sudo apt-get install -y liblzma-dev openssl libssl-dev cpputest \
libsqlite3-dev uuid-dev
如果希望从包含Snort++开发人员指南的源树构建最新的文档，请安装以下软件包(纯属可选)。这些包的大小接近800mb，可以跳过，除非你特别想要开发指南:

sudo apt-get install -y asciidoc dblatex source-highlight w3m
因为我们将从github库中安装Snort，所以我们需要一些工具(这一步在Ubuntu 20中是不必要的，因为这些库已经安装好了):

sudo apt-get install -y libtool git autoconf
需要安装Snort DAQ(数据获取库)的几个先决条件:

sudo apt-get install -y bison flex libcmocka-dev
如果您希望使用NFQ (IPS模式)以内联模式运行Snort，请安装所需的包；(如下所列的包是不需要的IDS模式或内联模式使用afpacket)。如果你不确定，你应该安装这些包:

sudo apt-get install -y libnetfilter-queue-dev libmnl-dev
下载和安装safec用于对某些遗留C-library调用的运行时边界检查(这是可选的，但推荐):

复制代码
cd ~/snort_src
#直接从github下载较慢，已转存至gitee
wget https://gitee.com/deng_wenyi/snort3-ubuntu-install-source-code/repository/archive/master.zip
apt install unzip
unzip master.zip
mv snort3-ubuntu-install-source-code/libsafec-08112019.0-gad76c7.tar.gz ./
tar -xzvf libsafec-08112019.0-gad76c7.tar.gz
cd libsafec-08112019.0-gad76c7/
./configure
make
sudo make install
复制代码
 安装PCRE:Perl兼容正则表达式。我们不使用Ubuntu库，因为Ubuntu库的版本更老。我们没有使用pcre2，因为hyperscan无法与那个版本兼容。

复制代码
cd ~/snort_src/
mv snort3-ubuntu-install-source-code/pcre-8.43.tar.gz ./
tar -xzvf pcre-8.43.tar.gz
cd pcre-8.43
./configure
make
sudo make install
复制代码
下载并安装gperftools 2.7，谷歌的线程缓存malloc(用于chrome)。Tcmalloc是一个内存分配器，它针对高并发情况进行了优化，将提供更好的速度来平衡较高的内存使用。我们不希望从Ubuntu存储库中获得tcmalloc版本(2.5版本)，因为它与Snort不兼容。Tcmalloc是可选的，但建议:

复制代码
sudo apt-get install -y libunwind-dev
cd ~/snort_src
mv snort3-ubuntu-install-source-code/gperftools-2.7.90.tar.gz ./
tar xzvf gperftools-2.7.90.tar.gz
cd gperftools-2.7.90
./configure
make
sudo make install
复制代码
Snort 3使用Hyperscan实现快速模式匹配。Hyperscan需要Ragel和Boost头:

复制代码
cd ~/snort_src
mv snort3-ubuntu-install-source-code/ragel-6.10.tar.gz ./
tar -xzvf ragel-6.10.tar.gz
cd ragel-6.10
./configure
make
sudo make install
复制代码
Hyperscan需要Boost c++库。请注意，我们没有使用boost头文件的Ubuntu存储库版本(libboost-all-dev)，因为Hyperscan需要1.58或更高版本的boost库，而且Ubuntu存储库版本太老了。下载Boost 1.72.0库，但不安装:

复制代码
cd ~/snort_src
#boost库比较大（约120M），见百度网盘下载；或使用原链接下载
#链接: https://pan.baidu.com/s/1GOM1KXJDjBMsElGw7q3fRg  密码: e4av
#--来自百度网盘超级会员V4的分享
wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar -xvzf boost_1_72_0.tar.gz
复制代码
从源文件安装hyperscan5.2.1，引用Boost头文件源目录的位置:

复制代码
cd ~/snort_src
mv snort3-ubuntu-install-source-code/hyperscan-5.2.1.tar.gz ./
tar -xvzf hyperscan-5.2.1.tar.gz
mkdir ~/snort_src/hyperscan-5.2.1-build
cd hyperscan-5.2.1-build/
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_72_0/ ../hyperscan-5.2.1
make
sudo make install
复制代码
如果你想测试Hyperscan工作，从构建目录，运行:

cd ~/snort_src/hyperscan-5.2.1-build/
./bin/unit-hyperscan
Snort对flatbuffers有一个可选的要求，这是一个内存高效的序列化库(您可以在cmake过程中忽略“不是git库”的错误):

复制代码
cd ~/snort_src
mv snort3-ubuntu-install-source-code/flatbuffers-v1.12.0.tar.gz ./
tar -xzvf flatbuffers-v1.12.0.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-1.12.0
make
sudo make install
复制代码
接下来，从Snort网站下载并安装数据采集库(DAQ)。注意，Snort 3使用的DAQ与Snort 2.9.x.x系列不同:

复制代码
cd ~/snort_src
git clone https://gitee.com/deng_wenyi/snort3-libdaq.git
cd snort3-libdaq
./bootstrap
./configure
make
sudo make install
复制代码
更新共享库:

sudo ldconfig
现在，我们准备从github存储库下载、编译和安装Snort 3。如果您对启用额外的编译时功能感兴趣，比如能够处理大的(超过2 GB) PCAP文件，或者新的命令行shell，那么您应该运行./configure cmake.sh --help列出所有可能的选项。如果您想安装到其他位置，请参阅附录B。下载和安装，默认设置:

复制代码
cd ~/snort_src
git clone https://gitee.com/deng_wenyi/snortadmin-snort3.git
cd snortadmin-snort3/
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
sudo make install
复制代码
安装的最后一步是验证Snort是否安装并可以运行。为此，我们向snort可执行文件传递-V这个标志:

/usr/local/bin/snort -V
您应该会看到类似如下的输出:

复制代码
root@UbuntuServer:~/snort_src/snortadmin-snort3/build# /usr/local/bin/snort -V

   ,,_     -*> Snort++ <*-
  o"  )~   Version 3.0.3 (Build 5)
   ''''    By Martin Roesch & The Snort Team
           http://snort.org/contact#team
           Copyright (C) 2014-2020 Cisco and/or its affiliates. All rights reserved.
           Copyright (C) 1998-2013 Sourcefire, Inc., et al.
           Using DAQ version 3.0.0
           Using LuaJIT version 2.0.4
           Using OpenSSL 1.0.2g  1 Mar 2016
           Using libpcap version 1.7.4
           Using PCRE version 8.43 2019-02-23
           Using ZLIB version 1.2.8
           Using FlatBuffers 1.12.0
           Using Hyperscan version 5.2.1 2020-12-13
           Using LZMA version 5.1.0alpha
复制代码
 如果您的输出与上面的类似，那么恭喜您!Snort已安装并正常工作。现在让我们使用默认配置文件测试Snort:

snort -c /usr/local/etc/snort/snort.lua
您应该会看到以以下内容结束的输出:

Snort successfully validated the configuration (with 0 warnings).
o")~   Snort exiting
配置网卡
现代网卡使用卸载(例如LRO)来处理硬件中的网络包重新组装，而不是在软件中重新组装。对于大多数情况，这是首选的，因为它减少了系统上的负载。对于NIDS，我们希望禁用LRO和GRO，因为这会截断较长的数据包(更多信息请参见Snort 2手册)。

我们需要创建一个systemD服务来更改这些设置。首先确定使用ifconfig查看让snort侦听的接口的名称。

注意:如果你使用的是Ubuntu 20: ifconfig已经被ip命令所取代(运行ip address show查看接口和ip地址)。

一旦知道了网络接口的名称，请检查这些接口的大接收(LRO)和通用接收(GRO)的卸载状态。在下面的示例中，我的接口名称是ens3(根据系统类型，您通常也会看到etho或ens160作为接口名称)。

我们使用ethtool来检查LRO/GRO的状态

sudo ethtool -k ens3 | grep receive-offload
输出：

generic-receive-offload: on
large-receive-offload: off [fixed]
从这个输出中，您可以看到启用了GRO，LRO被禁用(“固定”意味着它不能被改变)。我们需要确保两者都被设置为"off"(或off [fixed])。我们可以使用ethtool命令禁用LRO和GRO，但该设置不会在重新启动时持久存在。解决方案是创建一个systemD脚本，在每次引导时自动设置这个值。

创建systemD脚本:

sudo vi /lib/systemd/system/ethtool.service
输入以下信息，将ens3替换为您的接口名称:

复制代码
[Unit]
Description=Ethtool Configration for Network Interface

[Service]
Requires=network.target
Type=oneshot
ExecStart=/sbin/ethtool -K ens3 gro off
ExecStart=/sbin/ethtool -K ens3 lro off

[Install]
WantedBy=multi-user.target
复制代码
文件创建完成后，启用服务:

sudo systemctl enable ethtool
sudo service ethtool start
这些设置现在将在重新引导时持久存在。您可以使用ethtool验证设置，将显示(off或off[fixed]是您想要看到的设置):

sudo ethtool -k ens3 | grep receive-offload
输出：

generic-receive-offload: off
large-receive-offload: off [fixed]
安装OpenApplD
OpenApplD允许识别应用层(第7层)的流量。您可以创建操作应用程序层流量的规则(比如阻止facebook)，并记录检测到的每种类型的流量统计数据

在社区的帮助下，Snort团队创建了一个检测器包，称为应用程序检测器包，可以下载和安装。首先下载OpenAppID检测器包并解压缩文件

复制代码
cd ~/snort_src/
wget https://snort.org/downloads/openappid/15607
mv 15607 15607.tar.gz
tar -xzvf 15607.tar.gz
sudo cp -R odp /usr/local/lib/
复制代码
如果您得到的错误是该文件不存在，那么可能是Snort团队更新了规则集。浏览到https://snort.org/downloads#openappid，并下载snort-openappid.tar.gz。

按照上面的方法下载和提取规则后，我们需要编辑Snort配置文件以指向这个odp目录:

sudo vi /usr/local/etc/snort/snort.lua
在第89行(您的行号可能略有不同)，您将看到"appid ="条目。您将需要在这里添加app_detector_dir选项，它指向我们上面解压缩的odp文件夹的父文件夹。它应该是这样的:

复制代码
appid =
{

    −− appid requires this to use appids in rules
    app_detector_dir = '/usr/local/lib',
 }
复制代码
注意，缩进行必须有四个空格(而不是制表符)。现在我们想测试配置文件正确加载:

snort -c /usr/local/etc/snort/snort.lua --warn-all
此命令将验证Snort是否可以正确读取snort.lua文件，它不包含任何错误。运行此命令后，您应该看到以以下内容结束的输出:

注：（Snort的异常等级，警告、错误、致命错误）（我产生了5个警告，但这无伤大雅）

复制代码
...
Finished /usr/local/etc/snort/snort.lua:
WARNING: appid: no lua detectors found in directory '/usr/local/lib/custom/lua/*'
--------------------------------------------------
pcap DAQ configured to passive.

Snort successfully validated the configuration (with 1 warnings).
o")~ Snort exiting
复制代码
您可能会看到一个警告(非致命):WARNING: appid:在目录"/usr/local/lib/custom/lua/"中找不到lua检测器。

只要输出以“Snort成功验证了配置”结束，就可以忽略此警告。这个警告只是意味着您没有任何本地开发的openAppld获取脚本。

接下来，我们将创建一个简单的规则来测试OpenAppID是否正常工作

sudo mkdir /usr/local/etc/rules
sudo touch /usr/local/etc/rules/local.rules
sudo vi /usr/local/etc/rules/local.rules
我们将在local.rules文件中生成两个规则。第一个规则使用OpenApplID来检查Facebook流量，第二个规则将检测ICMP流量，这对于测试警报是否正确生成非常有用。这两条规则很适合测试您的设置。将以下两行粘贴到上面创建的local.rules文件中:

alert tcp any any -> any any ( msg:"Facebook Detected"; appids:"Facebook";sid:10000001; )
alert icmp any any -> any any (msg:"ICMP Traffic Detected";sid:10000002;)
现在运行Snort并加载local.rules文件，以确保正确加载这些规则(验证规则的格式正确):

snort -c /usr/local/etc/snort/snort.lua \
-R /usr/local/etc/rules/local.rules
输出应该以“Snort成功验证了匹配”结束。你不应该有任何警告或错误.

如果您向上滚动输出，您应该会看到这两个文本规则已成功加载(在rule counts部分)。现在，让我们在一个接口(更改下面的etho以匹配您的接口名称)上以检测模式运行snort，并将所有警报打印到控制台:

sudo snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules \
-i eth0 -A alert_fast -s 65535 -k none
"-k none"标志告诉Snort忽略错误的校验和，而"-s 65535"标志则防止Snort处理过大的包。Stream和Frag解码器会丢弃校验和错误的数据包，而OpenApplD检测器也不会处理这些数据包。通过包含这些标志，我们可以确保具有错误校验和的数据包仍然被处理为警报。snort将加载配置，然后显示:

Commencing packet processing
++ [0] eth0
这意味着snort目前正在监听该接口上的所有流量，并将其与它加载的两个规则进行比较。当流量与规则匹配时，snort将向控制台写入警告。现在，从该计算机上的另一个窗口(打开一个新的终端窗口或第二个ssh会话)，使用wget连接到facebook。这将触发第一个规则:

wget facebook.com
在第一个控制台窗口中，您将看到类似于以下的警报输出:

复制代码
05/30−21:26:48.482231 [**] [1:10000001:0] "Facebook Detected" [**] [Priority: 0] [AppID: Facebook] {TCP} 10.10.10.170:59632 −>
    185.60.216.35:80
05/30−21:26:48.506197 [**] [1:10000001:0] "Facebook Detected" [**] [Priority: 0] [AppID: Facebook] {TCP} 185.60.216.35:80 −>
    10.10.10.170:59632
...
复制代码
使用ctrl-c停止Snort。您还可以在snort侦听时(触发local.rules文件中的第二条规则)与这台机器进行ping或从该机器发出ping以生成警报。这是测试Snort的好规则，但在实际生产使用过程中可能会产生一些干扰。

如果没有看到生成的警报，请确保在此测试中，您正在运行snort的计算机上运行wget facebook.com，并且请求将从snort侦听的接口发出。您可以从另一台计算机ping到snort(到让snort侦听的接口的ip地址)。

注：（如果无法使用ctrl-c停止Snort，可以尝试ctrl-z）

如果希望收集OpenAppID统计信息(每个检测器检测到多少流量)，则需要在snort.lua文件中启用它，并使用"-l"标志，在标志后接"日志目录"运行Snort。

首先创建一个日志目录

sudo mkdir /var/log/snort
现在修改/usr/local/etc/snort/snort.lua使appid检测器能够记录统计信息(第89行):

复制代码
appid =
{

    app_detector_dir = '/usr/local/lib',
    log_stats = true,
}
复制代码
现在运行snort，监听接口，将数据记录到/var/log/snort文件夹

(与之前的命令相同，我们只是添加了日志文件夹路径"-l"标志)

sudo snort -c /usr/local/etc/snort/snort.lua -R /usr/local/etc/rules/local.rules \
-i eth0 -A alert_fast -s 65535 -k none -l /var/log/snort
在收集一些数据并停止Snort(像以前一样使用ping和wget facebook.com生成数据，然后使用Ctrl-C停止)之后，您将在/var/log/snort看到appid_stats.log该文件为root用户所有，因此让所有人都可读(我们将在后面一节中更改Snort自动编写的文件的权限):

sudo chmod a+r /var/log/snort/appid_stats.log
现在可以查看snort收集的协议统计信息:

复制代码
noah@snort3:~/snort_src$ cat /var/log/snort/appid_stats.log
1549218716,DNS,1576,1778
1549218716,Facebook,8727,630912
1549218716,OpenSSH,19523,2344
1549218716,SSH,19523,23445
1549218716,HTTPS,8727,630912
1549218716,SSL client,8727,630912
1549218716,ICMP,392,392
1549218716,__unknown,11028,139100
复制代码
这是一个逗号分隔的文件，按照这个顺序显示时间(unixtime)、检测器、发送字节(tx)和接收字节(rx)。如果不希望收集此数据，可以在snort.lua配置文件appid模块中禁用log开启选项。请注意，此数据与local.rules文件中由规则生成的警报不同。有关检测器的更多信息，请参见OpenApplD检测器指南。

安装Snort规则集
与Snort 2规则相比，Snort 3规则有更多的选项，尽管手动下载的v2规则或使用PulledPork(一个自动下载更新规则集的脚本)可以在Snort 3中使用，但应该使用专门为Snort 3创建的规则。

目前PulledPork还不能与Snort 3一起工作，因此无法自动更新规则集。我期望在不久的将来改变，一旦有了，我将发布一个更新的指南。

有三组不同的Snort规则可供选择(称为规则集)。社区规则集是免费的，不需要登录；注册的规则集包含社区规则集和其他规则，需要在snort.org上拥有一个免费帐户。订阅者规则集是付费服务。订阅方规则集的规则将在30天后添加到注册的规则集。更多的信息在这里

本指南将假设您正在使用注册的规则集。您需要在Snort.org上创建一个帐户，还可以选择在其中注册各种snort邮件列表(电子邮件数量适中，通常有一些有趣的问题)。注册并签到之后，导航到规则下载页面，下载最新的3.0规则(称为snortrales-snapshot3xxx.tar.gz或类似的内容，取决于是否发布了新的版本)。将规则集保存到snort-src文件夹中。

我们需要创建一些文件夹来存储规则集中的规则。这里我们在usr/local/etc/snort中创建了四个文件夹(如果您在上面为local.rules文件创建了第一个文件夹，那么它可能已经存在);

文件夹名称	目的
rules 	注册规则集中的所有基本规则文件
builtin_rules	包含内置规则的引用和信息的规则文件
so_rules 	这些是编译后的规则。Snort 3还没有这些功能，但很快就会实现
lists	白名单和黑名单。我们在本指南中没有设置这些
创建这些文件夹:

复制代码
sudo mkdir /usr/local/etc/rules
sudo mkdir /usr/local/etc/builtin_rules

sudo mkdir /usr/local/etc/so_rules
sudo mkdir /usr/local/etc/lists
复制代码
Snort的规则集包含三个文件夹:一个规则文件夹包含所有单独的规则文件，一个内建文件夹包含关于构建到snort的规则的信息，以及一个etc文件夹，其中包含规则集生成的更新后的snort配置文件。从Snort的规则集中提取文件，将所有规则文件复制到snort规则文件夹中，将内置规则复制到内置文件夹中，并将snort配置文件复制到snort的程序文件夹中:

注：（此时应该去snort官网下载注册规则集，并储存在~/snort_src/目录；因为下一步即将用到）

复制代码
cd ~/snort_src/

#在此提供了注册规则集的下载地址，但仍希望您去官方下载，因为它有可能会失效
wget https://www.snort.org/rules/snortrules-snapshot-3034.tar.gz?oinkcode=0e0795beeba6b8bd7c1d5b2727e48ad7a9202eb6 -O snortrules-snapshot-3034.tar.gz 

mkdir snortrules-3034
tar -xvzf snortrules-snapshot-3034.tar.gz -C ./snortrules-3034
cd snortrules-3034

#复制单个规则文件
sudo cp ./rules/*.rules /usr/local/etc/rules/

#复制内建规则文件
sudo cp ./builtins/builtins.rules /usr/local/etc/builtin_rules/

#复制新的配置文件(我们将覆盖当前的配置)。
sudo cp ./etc/* /usr/local/etc/snort/
复制代码
我们从etc文件夹复制了三个文件。file_magic.lua它告诉snort如何识别文件类型；snort_defaults.lua表示(配置snort的全局设置(系统范围)；snort.lua它是snort特定实例的配置文件。

每次运行Snort时，您将向Snort传递一个snort.lua文件，该文件描述您希望snort如何运行。这个文件会加载默认文件，它描述的系统配置,适用于每个different不同方式运行snort。你

可以有多个different版本的snort.lua,但通常只有一个默认的配置。

我们现在将编辑这些文件。我们不需要对/usr/local/etc/snort/snort_defaults.lua进行任何更改。但是如果您查看从第23行开始的部分，您会注意到我们在上面创建的文件夹。这就是snort如何在这些文件夹中查找规则文件的方法。

注：（这两段话及其绕口，劳资也没听懂，但是没关系）

接下来，编辑snort.lua文件。这个文件是我们在启动时传递给snort的配置文件，它还加载snort_defaults.lua文件。

sudo vi /usr/local/etc/snort/snort.lua
首先，让我们配置我们的HOME_NET变量。这指的是我们正在保护的本地子网(规则使用此信息来确定警报是否匹配)。在这里设置您的本地子网信息以匹配您的子网。我的子网配置是10.0.0.0网络与24位子网掩码:

HOME_NET = '10.0.0.0/24'
设置EXTERNAL_NET为“any”(一些指南希望你设置这个为除了所有子网的主网。但这会让你错过许多重要的警告)。

在第91行，您将看到appid插件没有任何选项(意味着检测器已加载，但未配置)。如果愿意，可以像上一节那样配置它。

注：（官方修改了配置文件，以前可能是在91行，但现在它在116行；像之前一样配置appid的路径并启用日志文件即可）

在第169行，您将看到ips检测器。如果你查看IPS设置，你会看到我们复制的所有规则文件，从第180行开始:

注：（ips检测器在195行，“我们复制的所有规则文件”是从206行开始）

复制代码
rules = [[

        include $RULE_PATH/snort3-app-detect.rules
        include $RULE_PATH/snort3-browser-chrome.rules
        include $RULE_PATH/snort3-browser-firefox.rules
        include $RULE_PATH/snort3-browser-ie.rules
        ...
复制代码
$RULE_PATH路径在snort_defaults.lua中定义，引用/usr/local/etc/rules.您可以在第172行看到内置ips选项;稍后我们将启用这些规则。现在，让我们测试一下snort是否可以成功加载这些规则。让我们通过运行snort来测试配置文件，并将路径传递给这个修改后的snort.lua文件，就像我们之前做的:

snort -c /usr/local/etc/snort/snort.lua
 如果你出现了类似以下报错：

Finished /usr/local/etc/snort/snort.lua:
Loading ips.rules:
FATAL: ips.rules:3 undefined variable name: RULE_PATH.
Fatal Error, Quitting..
请移步我的另一篇文章：https://www.cnblogs.com/Deng-Xian-Sheng/p/14170498.html


如果你没有任何错误，如果你向上滚动输出，你可以看到规则被加载:

复制代码
...

--------------------------------------------------
rule counts
total rules loaded: 12581
text rules: 12581
option chains: 12581
chain headers: 458
--------------------------------------------------

(lines ommited from output)...

Snort successfully validated the configuration (with 0 warnings).
o")~ Snort exiting
复制代码
注意:规则集中的许多规则都被注释掉了。本文对此进行了解释，但主要原因是有些规则可能会产生误报，所以Snort团队已经注释掉了这些规则，因为如果您在NIPS模式下运行Snort，它们可能会淹没您的日志，或导致过多的流量中断。

您可能希望使用以下标志来运行Snort，以便在测试和设置期间检测问题:warn-all和pedantic标志。从Snort 3手册:

除非指定了–warn-*，否则不会发出警告。-warn-all 启用所有警告，而 –
pedantic会使这些警告致命
在运行Snort时，您不会希望使用–pedantic标志，因为简单的flowbit警告(设置了flowbits，但没有在规则中使用，这是一个常见问题)将生成警告并导致Snort出错。不过，对于测试配置来说，这是一个很好的标志。

启用内置规则
要启用“启用解码器”和“检查器”警报(这些警报检测无法通过常规规则轻松检测到的恶意流量)，我们需要在snort配置文件中启用这个选项:snort.lua，位于/usr/local/etc/snort/目录中。另外，我们需要加载builtins.rules规则，这些规则包含每个警告的详细信息，并将这些信息写入控制台，编辑snort.lua:

sudo vi /usr/local/etc/snort/snort.lua
在第172行，通过删除行首的两个连字符，将enable_builtin_rules设置为true。以两个连字符开头的行是注释(禁用的命令通常注释，并且在加载时不会被snort解析)。删除enable_builtin_rules前的两个连字符来启用这个选项。

在第181行，我们希望包含内置规则文件，因此我们将其作为一个include添加到规则数组中。我们需要在内置文件夹中引用这个文件如下:

include $BUILTIN_RULE_PATH/builtins.rules
请记住snort中的每个缩进snort.lua必须是四个空格(不是制表符)，否则配置将无法加载。snort中的ips模块snort.lua应该是这样的:

复制代码
ips =
{
-- use this to enable decoder and inspector alerts
enable_builtin_rules = true,

-- use include for rules files; be sure to set your path
-- note that rules files can include other rules files
--include = 'snort3-community.rules',

-- The following include syntax is only valid for ...
-- RULE_PATH is typically set in snort_defaults.lua
rules = [[
include $BUILTIN_RULE_PATH/builtins.rules

include $RULE_PATH/snort3-app-detect.rules
include $RULE_PATH/snort3-browser-chrome.rules

}
复制代码
现在测试您对snort所做的更改snort.lua配置文件没有错误:

snort -c /usr/local/etc/snort/snort.lua
向上滚动前面命令的输出，您应该看到除了加载其他规则外，还加载了内置规则。也可以向上滚动，查看IPS 模块已加载的所有规则文件。这里你可以看到一些已加载的规则文件，以及525条未加载的bultin规则:

复制代码
Loading ips.rules:
Loading ../builtin_rules/builtins.rules:
Finished ../builtin_rules/builtins.rules:
Loading ../rules/snort3-app-detect.rules:
...

--------------------------------------------------
rule counts
total rules loaded: 13106
duplicate rules: 448
text rules: 12581
builtin rules: 525
option chains: 13106
chain headers: 458
--------------------------------------------------
复制代码
现在，让我们加载前面用facebook和icmp规则创建的local.rules文件。我们将使用-R标志从命令行加载这个规则文件，而不是在配置文件中加载。加载规则文件并测试配置:

snort -c /usr/local/etc/snort/snort.lua \
-R /usr/local/etc/rules/local.rules
滚动回输出，你会看到加载了local.rules文件，并在计数中添加了另外两条规则:

复制代码
Finished ips.rules:
Loading rule args:
Loading /usr/local/etc/rules/local.rules:
Finished /usr/local/etc/rules/local.rules:
Finished rule args:
--------------------------------------------------
rule counts
total rules loaded: 13108
复制代码
请记住，由于复制了snort规则集的配置文件, facebook规则将不起作用。规则集中的snort.lua文件，默认情况下没有启用OpenApplD。我们可以通过编辑/usr/local/etc/snort/snort.lua简单地重新启用该文件，从第92行开始:

复制代码
appid =
{
    app_detector_dir = '/usr/local/lib',
    log_stats = true,
}
复制代码
像以前一样进行测试，您可能会看到更多的警报记录到您的控制台

sudo snort -c /usr/local/etc/snort/snort.lua \
-R /usr/local/etc/rules/local.rules \
-i eth0 -A alert_fast -s 65535 -k none -l /var/log/snort
注意:当前有一个bug，当注册的规则集加载，Facebook规则将不会触发。Snort开发团队意识到了这一点，并正在努力解决它。

将PCAP文件传递到Snort，并将警报输出到.csv
本节对您的设置不是必需的，但是它将介绍我们稍后需要的许多标志，它将提供一些pcap文件，可以为测试生成警报，并帮助您更好地理解Snort 3。

如果您正在寻找PCAP文件，可以用于从您的内置规则和社区规则生成警报测试的目的，我发现macdc 2012数据集是好的。开始下载两个pcap文件:

 

复制代码
cd ~
mkdir pcaps
cd pcaps

wget https://download.netresec.com/pcap/maccdc-2012/maccdc2012_00000.pcap.gz
gunzip maccdc2012_00000.pcap.gz

wget https://download.netresec.com/pcap/maccdc-2012/maccdc2012_00001.pcap.gz
gunzip maccdc2012_00001.pcap.gz
复制代码
 

现在我们运行snort，告诉它加载我们下载的第一个pcap文件，加载所有规则(从snort.lua中)，并将警告打印到控制台(如果向下滚动，我将分解这里使用的所有标志)。我不会加载我们的local.rules文件，因为它实际上只对测试snort是否正确工作有用。请注意，这可能需要一些时间来运行，大量的提醒将在屏幕上滚动。如果你没有耐心，你可以使用ctrl-c来停止它(这在我的系统上运行大约3.5分钟，产生42,392个警报):

snort -c /usr/local/etc/snort/snort.lua \
-r ~/pcaps/maccdc2012_00000.pcap -A alert_fast -s 65535 -k none
这些标志的作用如下:

标志	解释
sudo snort 	这是我们正在调用的snort二进制文件。
-c /usr/local/etc/snort/snort.lua	这是snort.lua配置文件。
r ~/pcaps/maccdc2012_00000.pcap	pcap文件的路径。
-A alert_fast	使用alert_fast插件输出到控制台。
-s 65535	设置snaplen，使Snort不会截断或丢弃过大的包。
-k none	
忽略错误的校验和，否则snort将丢弃带有错误校验和的包，它们不会被计算。

如果要同时处理多个pcap文件，修改最后一条命令，扫描同一目录下的所有pcap文件，如下所示:

snort -c /usr/local/etc/snort/snort.lua --pcap-filter \*.pcap \
--pcap-dir ~/pcaps -A alert_fast -s 65535 -k none
我们在这里做了很多，让我们分解这个命令:

标志	解释
sudo snort 	这是snort二进制程序
-c /usr/local/etc/snort/snort.lua	这是snort.lua配置文件
–pcap-filter *.pcap 	这告诉snort如何识别位于pcap-dir中的pcap文件。
–pcap-dir ~/pcaps	这将告诉Snort pcap文件所在的目录。
-A alert_fast	使用alert_fast输出插件输出到控制台。
-s 65535	设置snaplen，使Snort不会截断或丢弃过大的包。
-k none 	忽略错误的校验和，否则snort将丢弃带有错误校验和的包，它们将不会被计算。
当我运行这个命令时，snort生成了137538个警报(请在末尾的输出中查看模块Statistics: Detection: total alerts)在2分30秒内(在输出中查看摘要统计:时间:秒)。

复制代码
1 --------------------------------------------------
2 Module Statistics
3 --------------------------------------------------
4 detection
5 analyzed: 8635943
6 hard_evals: 554185
7 raw_searches: 177185
8 cooked_searches: 306618
9 pkt_searches: 483803
10 alt_searches: 39
11 key_searches: 77449
12 header_searches: 221406
13 body_searches: 768
14 file_searches: 71801
15 total_alerts: 42392
16 logged: 42392
17 --------------------------------------------------
18
19 ...
20
21 --------------------------------------------------
22 Summary Statistics
23 --------------------------------------------------
24 timing
25 runtime: 00:03:41
26 seconds: 221.654928
27 pkts/sec: 39076
28 Mbits/sec: 32
复制代码
您可以修改最后一个命令，以使用任何输出插件(我们一直在使用alert_fast插件将事件打印到控制台)，可以在命令行中指定它，就像上面使用-A标志所做的那样，也可以在snort中启用该插件snort.lua文件(第320行)。例如，要使用alert csv插件将警报数据保存到csv文件中，你需要修改snort.lua看起来像这样(行232).

alert_csv =
{
file = true,
}
然后运行snort，如下所示:

sudo snort -c /usr/local/etc/snort/snort.lua -r ~/pcaps/maccdc2012_00000.pcap \
-s 65535 -k none -l /var/log/snort -q -m 0x1b
首先，您将注意到，在Snort处理PCAP文件时，屏幕上没有输出任何内容。当您运行上述命令时，您不会看到任何输出打印到控制台，因为我们正在向csv文件写入警报，并使用q标志抑制所有其他输出。您可能会注意到一些与lua检测器odp服务相关的错误，这些可以忽略。

您将注意到，我们没有像以前那样在命令行中指定输出插件，这是因为我们在snort.lua中启用了alert_csv插件。并在命令行中指定一个，将优先于在snort.lua中配置的任何输出插件。我们正在使用的新标志如下所示:

新标志	解释
-l /var/log/snort	应该保存输出文件(本例中为csv文件)的文件夹。
-q	安静模式，不显示横幅和状态报告
-m 0x1b	这将写入文件的umask设置为033。
umask:默认情况下，Snort使用的umask值为077，这将阻止所有者的任何人读取。日志文件。当试图使用其他工具摄取日志时，除非它们正在运行，否则会导致问题。在同一个用户帐户下(这是一个安全风险)。为了解决这个问题，我们使用-m标志传递一个新的umask 033(二进制为000 011 011，十六进制为oxb)，这意味着您的日志文件将具有权限:rwxr-r-，允许每个人都能够读取这些文件。如果您有特定的安全需求，请将此设置更改为更具限制性。在Snort时，这些文件将由根用户拥有

如上面所述运行(在本指南的后面部分，我们将使用非根用户来运行Snort)。

当返回到命令提示符时，这意味着Snort已经完成了对pcap文件的处理。您应该在/var/log/snort/目录中看到警报csv.txt。

使用wc-1(单词计数)命令，我们可以看到从这些pcap文件中生成了多少警报。在这里，您可以看到文件中有42299行，因为每一行都是一个单独的警报。您知道Snort生成了这么多事件:

noah@snort3:~$ wc -l /var/log/snort/alert_csv.txt
42299 /var/log/snort/alert_csv.txt
这个插件(和其他插件)有更多的选项。所有这些信息和更多信息都可以在Snort 3手册中获得。

JSON警报输出插件
为了方便地将Snort 3警报日志文件导入所选的SIEM(如Splunk)，需要使用alert json输出插件将所有警报写入json格式的文本文件。启用json输出插件很简单，只需修改snort.lua文件即可(约262行):

sudo vi /usr/local/etc/snort/snort.lua
首先，通过在插件中的每行前面放置两个破折号来禁用alert _csv插件，并启用alert json插件，如下所示。您可以同时启用这两个插件，这样就可以同时获得表示相同警告的csv和json文件，但您可能不希望这样。还要记住缩进使用4个空格代替制表符:

复制代码
--alert_csv =
--{
--file = true,
--}

alert_json =
{
file = true,
limit = 10,
fields = 'seconds action class b64_data dir dst_addr \
dst_ap dst_port eth_dst eth_len eth_src eth_type gid icmp_code \
icmp_id icmp_seq icmp_type iface ip_id ip_len msg mpls pkt_gen \
pkt_len pkt_num priority proto rev rule service sid src_addr \
src_ap src_port target tcp_ack tcp_flags tcp_len tcp_seq \
tcp_win tos ttl udp_len vlan timestamp',
}
复制代码
在alert json插件中，我们指定了三个选项:

1. 首先，我们使用file选项来允许将警报输出到json格式的文件(而不是输出到控制台)。

2. 接下来，我们指定limit选项来告诉Snort何时转到新文件。当输出文件达到10 MB时，将使用文件名中的当前unixtime创建一个新文件。为了进行测试，我们将这个值设置为10 MB，但是在生产系统上，您可能希望将这个值增加到100 MB或更大。

3.最后，我们指定fields选项，该选项标识警报的哪些特定字段应该包含在json输出中。在本例中，我们选择了每个可能的输出字段。

注意:经过测试后，可以选择删除其中的一些字段(vlan和mpls字段通常是不需要的，b64_data包含整个包的有效载荷，为了节省空间，可以删除这些字段)。不要删除seconds字段，并确保它始终是列出的第一个字段。这将允许Splunk正确地处理事件。

如果你像之前一样运行Snort扫描pcap文件并输出到csv文件(但现在启用了alert json输出插件，你会再次看到没有输出到控制台:

sudo snort -c /usr/local/etc/snort/snort.lua --pcap-filter \*.pcap \
--pcap-dir ~/pcaps -l /var/log/snort -s 65535 -k none -m 0x1b
一旦Snort完成了pcap文件的处理，就可以查看日志文件夹(上面用-l /var/log/snort指定)，您将看到包含所有警报的json文件:

您将注意到有许多警报alert_json.txt.nnnnnnnnnn文件。这些数字表示创建文件的unixtime，每个文件都是我们在snort.lua中指定的10 MB

复制代码
noah@snort3:~$ ls -lh /var/log/snort
total 59M
-rw-r--r-- 1 root root 4.4M Apr 26 17:26 alert_csv.txt
-rw-r--r-- 1 root root 4.1M Apr 26 17:38 alert_json.txt
-rw-r--r-- 1 root root 10M Apr 26 17:33 alert_json.txt.1587915232
-rw-r--r-- 1 root root 10M Apr 26 17:34 alert_json.txt.1587915252
-rw-r--r-- 1 root root 10M Apr 26 17:35 alert_json.txt.1587915314
-rw-r--r-- 1 root root 10M Apr 26 17:36 alert_json.txt.1587915397
-rw-r--r-- 1 root root 10M Apr 26 17:37 alert_json.txt.1587915473
-rw-r--r-- 1 root root 37K Apr 26 17:38 appid_stats.log
复制代码
Snort启动脚本
我们创建一个systemD脚本，以便在启动时自动运行snort。出于安全原因，我们还将在启动后以普通(非root)用户的身份运行snort。首先创建snort用户和组

sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
删除旧的日志文件(如果你想保留它们，可以移动它们):

sudo rm /var/log/snort/*
我们需要将‘snort’用户权限授予日志目录:

sudo chmod -R 5775 /var/log/snort
sudo chown -R snort:snort /var/log/snort
创建systemD服务文件:

 sudo vi /lib/systemd/system/snort3.service
与以下内容(更改以太网适配器etho以匹配您的适配器):

复制代码
[Unit]
Description=Snort3 NIDS Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/snort -c /usr/local/etc/snort/snort.lua -s 65535 \
-k none -l /var/log/snort -D -u snort -g snort -i eth0 -m 0x1b

[Install]
WantedBy=multi-user.target
复制代码
您应该熟悉我们传递给Snort的所有标志，因为它们与我们在前面的示例中使用的标志相同。我们添加了-D标志，它允许Snort作为守护进程运行。如果您想运行不同的选项，可以在这里添加它们。下面是我们使用的所有标志的分类:

标志	解释
/usr/local/bin/snort	这是到snort二进制文件的路径。这里我们不使用sudo，因为脚本将以提升(root)权限启动。
-c /usr/local/etc/snort/snort.lua	这是snort.lua的配置文件。
-s 65535	设置snaplen，使Snort不会截断和删除超大的包。
-k none	忽略错误的校验和，否则snort将丢弃带有错误校验和的包，它们不会被计算。
-l /var/log/snort	文件夹的路径，Snort将存储它输出的所有日志文件。
-D	作为守护进程运行
-u snort	在启动之后(以及在执行任何需要提升特权的操作之后)，切换到以“snort”用户的身份运行。
-g snort	启动之后，作为“snort”组运行。
-i eth0	要监听的接口。
-m 0x1b	文件权限的Umask为033。
 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

启用并启动Snort systemD服务:

sudo systemctl enable snort3
sudo service snort3 start
检查服务状态:

service snort3 status
你的输出应该类似于下面，显示'active (running)':

noah@snort3:~/pcaps$ service snort3 status
* snort3.service - Snort3 NIDS Daemon
Loaded: loaded (/lib/systemd/system/snort3.service; enabled; vendor preset: enabled)
Active: active (running) since Tue 2018-12-11 16:48:44 EST; 2min 57s ago
如果有任何问题，可以使用以下命令查看服务的完整输出:

sudo journalctl -u snort3.service
Splunk
Splunk与我们的软件,我们将使用SIEM(安全信息和事件管理)解决方案,将显示图形(通过web接口)的所有警报Snort已经生成,并会给我们一些强大的工具来搜索和理解这些警报,以及画出更深层次的信息。Splunk是我们使用它的方式的免费(在成本上)软件(尽管你可以购买与管理大型Splunk安装相关的额外功能的许可证)。替代软件是Elasticstack的ELK栈(这里我不使用它，因为配置更复杂)。

安装Splunk:
你需要在Splunk的网站上创建一个免费帐户来下载软件和附加组件。导航到Splunk的主页，点击右上角的绿色Free Splunk按钮，创建一个新帐户(如果你已经有帐户，也可以登录)。在“Splunk Free”下，你将点击“Download”链接。

在下载页面上，单击Linux选项卡，然后单击.deb旁边的立即下载按钮(因为我们运行的是Ubuntu，一个基于debian的系统)。同意许可，然后点击“立即开始下载”按钮。下载页面会自动打开一个窗口，以保存下载到您的本地系统。如果你想用wget下载安装程序，你可以取消这个下载，然后单击download via Command Line (wget)复制下载的wget字符串。下载大约是375mb。

一旦你的系统上安装了Splunk安装程序，你就需要安装它。从你保存安装程序的目录:

 sudo dpkg -i splunk-8.*.deb
这将安装Splunk到/opt/Splunk。注意，安装Splunk卷时必须有5 GB的空闲空间，否则Splunk将无法启动。Splunk存储所有收集的日志数据的索引位于安装位置的子文件夹中，因此请确保该卷上有足够的空间用于收集所有数据

现在我们想要第一次启动Splunk(接受许可并接受所有默认选项)。系统将提示您为Splunk创建一个新的admin用户和密码。保存这些凭证，因为我们稍后会使用它们登录到web界面:

sudo /opt/splunk/bin/splunk start --answer-yes --accept-license
然后，我们希望将Splunk配置为在引导时自动启动。我们也将为Splunk启用systemD并启动服务(不是Splunk systemD中的大写S)。

sudo /opt/splunk/bin/splunk stop
sudo /opt/splunk/bin/splunk enable boot-start -systemd-managed 1
sudo service Splunkd start
Splunk服务器现在监听这个服务器的端口8000(如果您从本地机器连接，或者从另一台计算机通过这个系统的IP地址连接，则是http://localhost:8000)。用户名和密码是在安装Splunk时设置的

Splunk目前使用的是免费企业试用许可证，提供所有企业特性60天，并允许您每天索引5gb的日志数据。一旦试用许可证过期，我们将失去的唯一影响此安装的功能是删除经过身份验证的登录。一旦您转换为免费许可证，您将不会被提示登录到Splunk web界面，

Splunk Enterprise提供了许多功能，包括自动更新Splunk实例和自动运行的Splunk应用程序的部署服务器，具有可配置权限的多个用户帐户，负载均衡，以及其他功能。

配置Splunk:
现在使用安装过程中创建的用户名和密码登录到Splunk实例。Splunk服务器正在侦听端口8000 (http://localhost:8000)。

我们需要安装一个Splunk插件(称为附加组件)，它允许我们轻松地获取(收集)Snort 3创建的日志，并对它们进行规范化(确保字段命名与NIDS数据一致，以便Splunk应用程序可以轻松地显示我们的数据)。

要安装这个应用程序，请在Splunk实例的主页上点击“+Find More Apps”链接。



 

 这将带你到Splunkbase，一个在线仓库的Splunk插件，扩展和增强你的Splunk安装的功能。在Splunkbase中搜索Snort3，您将看到一个结果:Snort3 JSON Alerts。点击这个插件旁边的绿色安装按钮:

 

当你注册下载Splunk时，输入你用Splunk创建的用户名和密码(而不是你为本地Splunk服务器实例创建的用户名和密码)。接受条款和条件，并点击登录和安装，一旦安装完成，点击完成。

这个附加组件现在已经安装在Splunk服务器上了。接下来，我们需要配置这个附加组件，以告诉Splunk Snort 3生成的日志文件存储在何处，以便Splunk能够接收它们。我们通过配置文件的命令行来实现这一点:

sudo mkdir /opt/splunk/etc/apps/TA_Snort3_json/local
sudo touch /opt/splunk/etc/apps/TA_Snort3_json/local/inputs.conf
sudo vi /opt/splunk/etc/apps/TA_Snort3_json/local/inputs.conf
在input .conf文件中输入以下文本:

[monitor:///var/log/snort/*alert_json.txt*]
sourcetype = snort3:alert:json
重启Splunk:

sudo service Splunkd restart
现在，当Splunk启动时，它将扫描/var/log/snort目录中的json文件，为它们分配snort3:alert:json的sourcetype，并获取它们，以便我们可以搜索它们

从vour Splunk实例，登录(因为您重新启动了服务器)，并单击左侧的Search & Reporting APP链接。在搜索栏中输入以下文本:

sourcetype="snort3:alert:json"
然后点击绿色放大镜图标开始搜索。



 

 这将显示服务器正在收集的所有事件。您可能不会看到很多事件，特别是如果您删除了我们从pcap文件中创建的旧ison文件。如果你没有看到任何提醒，你可以使用ping和wget facebook.com创建一些新的提醒(记住我们之前创建过这些规则)。在Splunk中生成的事件和显示的事件之间有轻微的延迟。如果您继续没有看到任何提醒，将时间范围(搜索图标旁边的下拉菜单设置为过去24小时)更改为"所有时间"并重新运行搜索。如果仍然没有看到任何事件，请检查/var/log/snort文件夹中是否有json文件!!

使用Splunk
本指南并没有深入介绍Splunk的使用。我下面提到的Splunk有很多很棒的免费资源

下面是一些简单的搜索，你可能会发现对你的起步有帮助。要在包含时间、源、目标和消息的表中显示所有事件，请执行以下搜索:

sourcetype="snort3:alert:json"
| table _time src_ap dst_ap msg
按目的地显示所有事件的统计:

sourcetype="snort3:alert:json"
| stats count by dest
在地图上显示所有事件来源:

sourcetype="snort3:alert:json"
| iplocation src_addr
| stats count by Country
| geom geo_countries featureIdField="Country"
你可能需要点击“可视化”选项卡，然后点击“折线图”，并将其更改为"地区分布图")

一些优秀的免费资源使用Splunk:

电子书:探索Splunk:搜索处理语言(SPL)入门和食谱

免费的在线培训:

免费Splunk Fundamentals1
Splunk的基础设施概况
清理您的安装
Splunk目前在免费企业试用模式下运行，有效期只有60天。我们想将该许可证转换为自由模式，它类似于企业模式，只是删除了一些特性。您将注意到缺少的特性是使用用户名和密码登录服务器的能力(允许任何人登录)。您还失去了一些与集群相关的特性，以及将Splunk应用程序部署到其他服务器的能力(当您有多个服务器或系统可以收集日志时，这很有用)。

要更改许可证:单击右上角的设置，然后单击"授权":

单击“更改许可证组”。选择“Free许可证”，单击“保存”。单击“立即重新启动”，然后单击“确定”。如果您是从远程计算机上登录的，您应该注意到没有提示您登录这是故意的，但这可能会带来安全风险(因为现在任何人都可以登录到您的服务器上)。如果您在转换许可证时已登录到本地机器，则只允许本地登录

结论
有关运行Snort 3和编译选项的更多信息，请参阅Snort 3手册。Snort 3与Snort 2.9.9x系列有很大不同。强烈推荐阅读本手册。配置文件和规则文件都是不同的，两个版本之间不兼容。可以使用包含的snort2.lua命令将旧的Snort配置和规则文件转换为Snort 3格式。反馈:请将您遇到的问题的反馈和修改指南的建议发送给我:mailto:NoahasublimeRobots.com，反馈可以帮助我更新这些指南。帮助我识别人们在执行这些说明时遇到的常见问题和问题。

注意：已省略附录ABCD。原手册在Snort官网。