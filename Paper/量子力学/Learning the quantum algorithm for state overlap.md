- Time：2023-06-06 20:18
- Label： #量子计算 #期末论文

## Abstract

最后的总结用 [[../../AI/LLM/Project&Analysis/ChatPaper|ChatPaper]] 总结一下，应该花费不了多少时间，但是要准备论文写作的平时作业和期末作业。

直接把这个量子计算导论的论文作为论文写作期末论文就好了。一稿两交。

你需要优先在你的知识库里面搜索，如果没有就查缺补漏叭。

## Content

Basic Information:  
Title: Learning the quantum algorithm for state overlap (学习量子状态重叠算法)  
Authors: Lukasz Cincio, Yiğit Subaşı, Andrew T. Sornborger, and Patrick J. Coles  
Affiliation: Theoretical Division, Los Alamos National Laboratory, Los Alamos, NM 87545, USA. (理论部门，洛斯阿拉莫斯国家实验室，美国新墨西哥州洛斯阿拉莫斯)  
Keywords: quantum algorithm, state overlap, machine learning  
URLs: arXiv, GitHub  
Note: The GitHub code provides the implementation of the algorithms proposed in the paper using Qiskit and PennyLane.

Summary:  
a. Research background of this article:  
本文提出一种使用机器学习的方法，发现用于降低近期量子计算机上的计算误差的短深度量子算法，其中减少纠缠和门保真度仍然是一个重要问题；  
b. Past methods, their problems, and motivation:  
以往的标准算法, Swap Test, 用于计算 Tr(ρσ), 问题大小增加，则所需深度增加，且常常出现计算误差；  
c. Research methodology proposed in this paper:  
由作者提出一机器学习的方法找出了两种可代替 Swap Test 的量子算法，使之短深度且降低了计算误差；  
d. Task and performance achieved by the methods in this paper:  
基于 IBM 和 Rigetti 量子计算机的近期量子计算技术，该方法可获得比 Swap Test 更好的计算性能。  
Background:  
a. Subject and characteristics:  
本文涉及近期量子计算机中短深度量子算法的研究，以用于降低计算误差；  
b. Historical development:  
以往的标准算法，Swap Test, 计算量随问题大小增加，深度也需要增加，计算误差很大；  
c. Past methods:  
Swap Test 算法；  
d. Past research shortcomings:  
以往的标准算法会随着问题大小的增加计算时间和错误率增加；  
e. Current issues to address:  
如何在短深度的量子电路上完成更复杂的量子计算任务。  
Methods:  
a. Theoretical basis of the study:  
使用机器学习来优化量子算法，其目的是通过最小化算法输出与期望输出之间的总体差异来针对性地优化算法；  
b. Technical route of the article (step by step):  
作者尝试使用机器学习算法对两个量子态ρ和σ之间的重叠 Tr(ρσ) 的计算进行了优化，发现出现了 ABA 和 BBA 两个能代替 Swap Test's 的短深度量子算法。两个算法的深度不随问题大小改变。ABA 相较于 Swap Test 的迭代次数少，BBA 总深度为常数且在无法执行 Transversal 门的计算中更为优秀；  
将所得算法应用于早期版本量子计算机，相较于 Swap Test 算法，该方法可以大幅降低计算误差；  
针对所提出的问题，作者提出了一种机器学习的方法，可用于发现优化近期量子计算任务的其他算法，例如基于量子机器学习、量子化学、量子仿真等领域。  
Conclusion:  
a. Significance of the work:  
该研究证明了机器学习方法在寻找优化量子算法中的潜力和可行性。这种方法通过最小化所得算法的差异与期望结果之间的总体差异来调整算法，因此比现有的单纯编译方法更加灵活和有效。Finding 短深度量子算法有望促进量子计算的交叉学科的发展；  
b. Innovation, performance, and workload:  
本文提出了一种通过机器学习寻找量子算法的新方法。使用这种方法，可以促进短深度量子算法的发现，从而提高量子计算效率，缩短计算时间。两种算法 ABA 和 BBA 在计算方面优于传统算法 Swap Test，具有重要的理论和实际应用价值；  
c. Research conclusions (list points):  
作者使用机器学习在早期版本量子计算机上找到了有效的量子算法，如 ABA 和 BBA；  
该方法可以优化量子计算任务并实现随着问题大小线性增长和一定深度的迭代计算；  
两种算法在特定的任务和机器上表现优于传统的 Swap Test 算法，且误差更小。

## Reference

- [[1803.04114] Learning the quantum algorithm for state overlap (arxiv.org)](https://arxiv.org/abs/1803.04114)
- [论文《Learning the quantum algorithm for state overlap 》阅读笔记_aba swap test_keep_humble的博客-CSDN博客](https://blog.csdn.net/qq_43270444/article/details/116449172?ops_request_misc=&request_id=&biz_id=102&utm_term=Learing%20the%20quantum%20algorithm%20&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-116449172.142^v88^control_2,239^v2^insert_chatgpt&spm=1018.2226.3001.4187)
