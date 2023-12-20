## Basic Information

- Title: DeepAG: Attack Graph Construction and Threats Prediction With Bi-Directional Deep Learning (DeepAG: 使用双向深度学习构建攻击图和威胁预测)
- Authors: Teng Li, Ya Jiang, Chi Lin, Mohammad S. Obaidat, Yulong Shen, Jianfeng Ma
- Affiliation: Teng Li and Jianfeng Ma are with the School of Cyber Engineering, Xidian University, Xi’an, Shaanxi 710071, China. Ya Jiang and Yulong Shen are with the School of Computer Science and Technology, Xidian University, Xi’an, Shaanxi 710071, China. Chi Lin is with the School of Software Technology, Dalian University of Technology, Dalian, Liaoning 116024, China. Mohammad S. Obaidat is with the College of Computing and Informatics, University of Sharjah, Sharjah 27272, UAE, and with the University of Jordan, Amman 11942, Jordan, and also with the University of Science and Technology Beijing, Beijing 100083, China.
- Keywords: Attack prediction, deep learning, transformer, LSTM, attack graph
- URLs: [Paper](https://ieeexplore.ieee.org/document/9607407), [GitHub: None]

## 论文简要

- 本研究提出了 DeepAG，一种利用**系统日志检测威胁和预测攻击路径**的框架。**DeepAG** 利用**变压器模型**来新颖地检测 APT 攻击序列，通过建模系统日志的语义信息。另外，DeepAG 利用**长短期记忆（LSTM）网络**提出了**双向预测攻击路径**，其性能优于传统的双向 LSTM。此外，通过先前检测到的攻击序列和预测的路径，DeepAG 构建了**攻击图**，攻击者可能遵循这些路径来破坏网络。实验结果表明，DeepAG 可以准确检测超过 15000 个序列中的 99% 以上，并在预测方面相对于基线提高了 11.166% 的准确性。

## 背景信息

- 论文背景: 复杂的多步攻击，如高级持续性威胁（APTs），由于其多样性和复杂性，给网络安全带来了相当大的威胁。因此，研究对手的策略并进行预测仍然是攻击预防的重要挑战。
- 过去方案: 传统的威胁预防系统，如入侵检测系统（IDS）、入侵检测和防御系统（IDPS）、高级安全设备（ASA），由于无法利用网络威胁策略或产生高误报率，已经不再有效。因此，迫切需要一种能够及时、具体和可靠地检测和预测攻击的方法。
- 论文的 Motivation: 鉴于上述挑战，本研究提出了 DeepAG，一种在线方法，能够同时检测 APT 序列、定位序列中的攻击阶段，并根据日志索引构建攻击图。通过提取日志的词汇和语义信息，并将其向量化，DeepAG 能够准确检测攻击序列。为了预测攻击路径，DeepAG 利用双向模型学习日志索引序列之间的关系。此外，DeepAG 引入了 OOV 词处理器和在线更新机制，分别用于克服检测和预测模型的不足学习。最后，DeepAG 构建了攻击图，模拟非线性依赖关系，并直观地展示攻击阶段，帮助用户掌握攻击者的策略。通过在四个不同系统日志的开源数据集上进行实验评估，DeepAG 能够高效实时地检测攻击，相比基线方法，时间成本降低了 3 倍以上。

## 方法

- a. 理论背景:
    - DeepAG 利用系统日志来检测威胁并预测攻击路径。它利用变压器模型来检测 APT 攻击序列，通过对系统日志的语义信息进行建模。此外，DeepAG 还使用双向长短期记忆（LSTM）网络来预测攻击路径，其性能优于传统的 BiLSTM。此外，DeepAG 还包括一个词汇外处理器和在线更新机制，以适应新的攻击模式。该框架基于先前检测到的攻击序列和预测路径构建攻击图。
- b. 技术路线:
    - DeepAG 的系统模型分为**文本表示**、**训练阶段**、**检测阶段**、**预测阶段**和**图构建**五个部分。系统日志被表示为日志模板，并转换为索引和向量。变压器模型用于 APT 序列检测，双向模型用于检测和预测攻击阶段。DeepAG 基于条件概率构建攻击图。

## 结果

- a. 详细的实验设置:
    - 实验涉及使用双向 LSTM 模型构建攻击图。设置了预测输出的概率阈值以限制考虑的日志键数量。分析了不同概率阈值的影响。
- b. 详细的实验结果:
    - 实验结果表明，DeepAG 在预测日志键序列和构建攻击图方面具有较高的性能。在不同数据集上，DeepAG 的 F1 分数最高，分别为 99.661% 和 99.85%。DeepAG 在训练一个数据集并在另一个数据集上进行测试时，也表现出色，分别达到 76.976% 和 79.463% 的 F1 分数。DeepAG 的测试时间显著低于其他模型，分别为 1.02 秒和 0.93 秒。

## Note

- 本总结源自于 LLM 的总结，请注意数据判别. Power by ChatPaper. End.
