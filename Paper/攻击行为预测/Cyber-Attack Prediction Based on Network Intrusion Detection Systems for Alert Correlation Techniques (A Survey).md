## Basic Information

- Title: Cyber-Attack Prediction Based on Network Intrusion Detection Systems for Alert Correlation Techniques: A Survey (基于网络入侵检测系统的警报关联技术的网络攻击预测：一项调查)
- Authors: Hashim Albasheer, Maheyzah Md Siraj, Azath Mubarakali, Omer Elsier Tayfour, Sayeed Salih, Mosab Hamdan, Suleman Khan, Anazida Zainal, Sameer Kamarudeen
- Affiliation: School of Computing, Faculty of Engineering, Universiti Teknologi Malaysia (UTM), Skudai Johor 81310, Malaysia (马来西亚理工大学计算机学院)
- Keywords: intrusion detection, alerts correlation, attacks prediction, machine learning
- URLs: [Paper](https://doi.org/10.3390/s22041494), [GitHub: None]

## 论文简要

- 本文调查了基于网络入侵检测系统（NIDS）的警报关联技术在网络攻击预测方面的最新研究进展，包括模型和限制。介绍了警报关联的分类方法和组件，并突出了警报关联数据集和未来研究方向。该研究为研究人员和行业提供了一个基准，以推动网络入侵检测系统的进一步发展。

## 背景信息

- 论文背景: 网络入侵检测系统（NIDS）是为了保护企业网络免受网络攻击而设计的。然而，NIDS 网络存在一些限制，例如产生大量低质量的警报。此外，99% 的 NIDS 产生的警报是误报。预测攻击者未来行动是其中最重要的目标之一。
- 过去方案: 为了克服这些限制，提出了警报关联（AC）作为 IDS 后处理的方法。警报关联通过接收原始警报，识别不同警报之间的关联，并将每个警报与其相关的上下文信息联系起来，预测即将发生的警报/攻击。它提供了网络安全状况的及时、简明和高级视图。
- 论文的 Motivation: 本文的动机是对基于 NIDS 入侵警报的网络攻击预测进行综述和调查。作者介绍了最新的预测方法和警报关联技术，并提出了分类和比较方法。此外，作者还关注了警报关联数据集和未来研究方向，以促进网络入侵检测系统的进一步发展。

## 方法

- a. 理论背景:
    - （NIDS）在生成大量低质量警报方面的局限性，其中 99% 的警报是误报。强调了预测未来攻击者行动的重要性，并引入了警报关联（AC）的概念作为解决这些限制的方法。
- b. 技术路线:
    - 本文提出了多种预测入侵警报的方法，包括关系时间序列、贝叶斯网络、深度学习、机器学习和数据挖掘、序列模式挖掘、网络攻击图和计划库。每种方法都有其优点和缺点，例如关系时间序列可以执行警报减少、聚类、聚合和模式匹配，贝叶斯网络可以高精度地检测已知攻击，序列模式挖掘可以检测已知和未知的攻击场景。此外，本文还提供了现有警报关联方法的分类，将其分为基于相似性、基于统计的和基于知识的警报关联，并提到了混合方法。

## 结果

- a. 详细的实验设置:
    - 本文讨论了评估警报关联研究数据集的挑战和考虑因素，包括数据隐私、获得数据所有者的批准、评估数据集的范围、不同的研究目标、数据标记和评估数据集的来源。**还提供了关于特定数据集的详细信息，如 Alert sharing platform (SABU) 数据集、DARPA 2000 数据集、KDD 99 数据集、Real Networks 数据集和 KYOTO2006+ 数据集**。此外，还提到了使用**模拟网络创建数据集**以及**研究中使用的不同类型的攻击和方法**的比较。本文还强调了预测攻击者下一步活动的重要性以及现有入侵警报预测系统的局限性。
- b. 详细的实验结果:
    - 本文提供了各种异常检测技术在高维大数据中的综合调查。还讨论了浅层和深度学习方法在网络入侵警报预测中的应用。此外，还探讨了数据挖掘和机器学习在入侵检测中的应用。本文还提到了**遗传算法**和**模糊签名的基于规则的入侵检测系统**。还调查了深度学习方法在网络入侵检测中的应用。最后，本文讨论了**警报关联技术**在入侵检测中的应用。

## Note

- 本总结源自于 LLM 的总结，请注意数据判别. Power by ChatPaper. End.
