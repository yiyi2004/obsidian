# CSDN
Anomaly-based detectors for APTs
- 主机日志（审计日志）
- 系统调用
- 网络流量 | 警报信息
- 恶意行为
Provenance graph-based detectors for APTs
- 溯源图
- +引入外部知识
- +融合ATT&CK框架
- 因果关系图+NLP

伊利诺伊大学芝加哥分校团队
首先，USENIX’17提出的 SLEUTH，将溯源图应用于APT攻击检测领域。然后，该团队紧接着在2019年CCS会议上提出 Poirot，在S&P’19上提出 Holmes，该方法融合了Kill Chain和ATT&CK框架。此外，在2021年EurS&P提出 Extrator，并引入外部知识。

伊利诺伊大学香槟分校团队
另一个研究溯源图的团队来自伊利诺伊大学香槟分校，他们分别在NDSS’20提出了 UNICORN 和 ProvDetector，同时在2020年的S&P上提出 RapSheet，它融合了ATT&CK框架。

普渡大学团队
第三个团队是来自普渡大学，当然各团队之间有很多合作团队。他们的核心成果包括NDSS’13提出的 BEEP，NDSS’16提出的 ProTracer 和USENIX’21提出的 ATLAS。

- DARPA TC是经典的APT攻击检测数据集
接着介绍它的警报（Alarms）计算策略，以下四个会引发警报，包括：
- 不受信任的代码执行：高等级标签去执行低等级时触发
- 被低等级标签修改：修改文件权限时产生
- 秘密文件泄露：不可信对象执行写的操作
- 执行不可信的数据：比如执行command等指令操作

![[Pasted image 20220923091511.png]]
![[Pasted image 20220923091619.png]]
- 整个实验采用 DARPA TC 数据集实验，它有8个攻击场景重构及攻击阶段映射，该论文对每个场景进行了图还原，涉及阶段如下图所示：

![[Pasted image 20220923091636.png]]
![[Pasted image 20220923091710.png]]

## 小结
Sleuth方法
- Sleuth实时检测、运行效率更高
- Sleuth基于标签的检测方法更精确（规则+策略+警报）
传统方法，如Bactracker [SOSP’03]
- 无法实时且效率低
- Bactracker依赖外部工具生成警报，无法剪枝和溯源

# Paper Note
![[Pasted image 20220923105131.png]]
- 尽量简洁快速的方式

## 主存依赖图
- 这种设计使我们使用 6 bytes 就可以存储双向的带时间戳的边，subject-event记录占4 bytes，object-event 记录占2字节。在实验中使用更大的数据集时，平均每个事件占用内存也在10 bytes以内。可变长编码还使得我们可以表示重要但出镜率比较少的事件，比如rename 、chmod 、execve 等 rename、chmod、execve等rename、chmod、execve 等。

## 4. 标签与攻击检测
- 我们使用标签来描述objects和subjects的可信度和敏感度。对可信度和敏感度的评估基于以下三个因素：
	- 起源（Provenance）：依赖图中，subject或object直接祖先的标记
	- 系统先验知识：我们对一些重要应用行为的了解，比如远程接入服务器、软件安装程序和重要的文件（/etc/passwd 和 /dev/audio）
	- 行为：观察subject的行为，并将其与预期行为进行比较
- 标签在SLEUTH中扮演了核心角色。它为攻击检测提供了重要的上下文信息，每个事件都在这些标记组成的上下文中进行解释，以确定其导致攻击的可能性。此外，标签对我们的前向和回溯分析的速度也很有用。最后，标签为消除大量与攻击无关的审计数据也起到了关键作用。

- 可信度标签
- 机密性标签

>已经存在的objects和subjects使用标签初始化策略分配初始标签。在系统执行过程中还会产生新的objects和subjects，它们由标签传播策略分配标签。最后，基于行为的检测策略来检测攻击。

- unicorn
- 
# Paper

# Doc


# Reference
- [APT 攻击场景重构方法综述](http://xxgcxb.cnjournals.com/ch/reader/create_pdf.aspx?file_no=20200904001&year_id=2021&quarter_id=1&falg=1)
- [[论文阅读](10)基于溯源图的APT攻击检测安全顶会总结](https://blog.csdn.net/Eastmount/article/details/120555733?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166389397116782428661004%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166389397116782428661004&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-120555733-null-null.142^v50^control,201^v3^add_ask&utm_term=%E5%9F%BA%E4%BA%8E%E6%BA%AF%E6%BA%90%E5%9B%BE%E7%9A%84%20APT%20%E6%A3%80%E6%B5%8B&spm=1018.2226.3001.4187)
- [(122条消息) Paper Note - SLEUTH：基于COTS审计数据的实时攻击场景重构_Alst0n的博客-CSDN博客](https://blog.csdn.net/Sc0fie1d/article/details/104273798?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166390069816800180672231%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166390069816800180672231&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-104273798-null-null.142^v50^control,201^v3^add_ask&utm_term=SLEUTH%3A%20Real-time%20Attack%20Scenario%20Reconstruction%20from%20COTS%20Audit%20Data%E2%88%97&spm=1018.2226.3001.4187)
- 

- 
- 