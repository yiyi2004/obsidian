# 摘要
对抗实例暴露了自然语言处理(NLP)模型的脆弱性，可用于评估和提高其鲁棒性。现有的生成此类示例的技术通常是由局部启发式规则驱动的，这些规则与上下文无关，常常导致不自然和不语法的输出。本文提出了CLARE，一个上下文化对抗范例生成模型，通过掩码再填充的过程生成流畅的语法输出。CLARE建立在预先训练的屏蔽语言模型之上，并以上下文感知的方式修改输入。我们提出了三种上下文化的扰动，替换，插入和合并，允许生成不同长度的输出。CLARE拥有更丰富的可用策略范围，能够以更少的编辑更有效地攻击受害模型。大量的实验和人类评估表明，CLARE在攻击成功率、文本相似性、流畅性和语法性方面优于基线。

# 2 CLARE
CLARE 对输入应用一系列上下文化的扰动操作。 每一个都可以看作是一个局部掩码然后填充的过程：它首先在给定位置周围对输入应用掩码，然后使用预先训练的掩码语言模型填充它。为了产生输出，CLARE 对动作进行打分和降序排序，然后将这些动作迭代应用于输入(§2.2)。

## Background
对抗性样本生成以受害者模型 $f$ 为中心，假设该模型是文本分类器，我们关注黑盒测试，即允许访问 $f$ 的输出，但不允许访问其配置，如参数等。给定输入序列$\mathrm{x}=x_1x_2 ... x_n$ 及其标签 $y$（assume $f(x)=y$ )，假设一个对抗性示例 $\mathrm{x'}$ 是对 $\mathrm{x}$ 的修改并使受害者模型判断错误: $f(x') \ne f(x)$。 同时，文本上的修改应该是最小的，这样$\mathrm{x'}$接近于$\mathrm{x}$，并且人类对 $\mathrm{x'}$ 的预测保持不变。

这是通过要求$\mathrm{x'}$和$\mathrm{x}$之间的相似性大于阈值实现的，即 $sim(\mathrm{x'},\mathrm{x})>\ell$ 来实现的。 $sim(·,·)$ 的一个常见做法是使用神经网络对句子进行编码，并在嵌入空间中计算它们的余弦相似度（Jin et al.，2020)。 

## 2.1 Masking and Contetualized Infilling
在输入序列的给定位置，CLARE 可以执行三个扰动操作: Replace、Insert 和 Merge，我们将在本节中介绍这些操作。它们用不同的策略在给定的位置应用掩码，然后根据未掩码的上下文填充缺失的文本。 

### Replace
![[Pasted image 20221212140311.png]]

Replace 操作首先用掩码替换 $x_i$，然后从候选集 $\mathcal{Z}$ 中选择 token $z$ 来填充

为了产生对抗样本：
- $z$ 应该适合于原文的上下文；
- $\mathrm{\tilde{x}}_z$ 应该与 $\mathrm{x}$ 相似； 
- $\mathrm{\tilde{x}}_z$ 应该在 $f$ 中触发一个错误。 

上诉条件可以通过以下操作来满足：
- $z$ 从掩码语言模型中接收高概率: $\mathcal{p} _{\mathrm{MLM}}(z|\tilde{x})>k$
- $\mathrm{\tilde{x}}_z$ 与 x 相似:$sim(\mathrm{x},\mathrm{\tilde{x}}_z)>\ell$； 
- $f$ 预测给定 $\mathrm{\tilde{x}}_z$ 的原始标签为低概率，即 $p_f({y| \mathrm{\tilde{x}}_z})$很小。

$p_{\mathrm{MLM}}$ 表示预先训练的掩码语言模型（例如，Roberta；Liu et al.，2019)。 使用更高的$k$ 阈值会让产生的输出语句更为流利，更接近原始语句。然而，这会降低攻击的成功率。 

关于 $k$ 和 $\ell$ 的选择：

![[Pasted image 20221212143816.png]]

候选集 $\mathcal{Z}$ 的表达式：
![[Pasted image 20221212143901.png]]

$\mathcal{V}$ 是掩码语言模型的词汇表。我们需要满足满足第三个条件(如下)，我们将从$\mathcal{Z}$中选择一个可以给 $f$ 造成最大“混乱”的 token：
![[Pasted image 20221212144237.png]]

### Insert
Insert 旨在为输入添加额外的信息(e.g., changing “I recommend ...” to “I highly
recommend ...”)。 它在 $x_i$ 后插入一个 mask，然后填充它。稍微改变了一点原意。

![[Pasted image 20221212140331.png]]

这将使序列长度增加1 

### Merge

![[Pasted image 20221212140350.png]]

Merge 操作同理

### 小结
在输入序列的每个位置$i$处，CLARE 首先：(i)用 mask 替换$x_i$； (ii)或在$x_i$后插入 mask； (iii)或将 $x_ix_{i+1}$ 合并为 mask。然后利用语言模型和文本相似度函数构造候选集；选择使原始标签的概率最小的 token 作为替代 token。 这三种操作的组合可以在任意两个序列之间进行转换。

CLARE 首先并行地为所有位置构造本地操作，即位置 $i$ 的操作不影响其他位置的操作。 然后，为了生成对抗性样本，CLARE 收集本地操作并选择执行它们的命令。 

## 2.2 Sequentially Applying the Perturbations

![[Pasted image 20221212145900.png]]

给定一个输入对$(\mathrm{x}，y)$，设 $n$ 表示x的长度。 CLARE 从$3n$ 个操作中选择产生输出：每个位置有3个操作，假设候选集不是空的。我们的目标是生成一个对抗性样本，对输入进行最小的修改。为了实现这一点，我们迭代地应用这些动作(三种操作)，并首先选择那些最小化从 $f$ 输出金标签(即原始标签)$y$的概率的动作。 

每个动作都与一个分数相关联，衡量它“混淆” $f$ 的可能性：用 $a(x)$ 表示将动作 $a$ 应用于$\mathrm{x}$的输出。 然后，分数是从 $f$ 预测黄金标签的负概率，使用 $a(x)$ 作为输入： 

![[Pasted image 20221212134314.png]]

每个位置只能应用三个动作中的一个，我们选择得分最高的一个。这一限制旨在避免围绕同一位置进行多次修改，例如将“New York”合并为“Seattle”，然后替换为“Boston”。 

动作被迭代地应用于输入，直到找到一个对抗样本或达到一个动作的极限 $T$。 每一步从剩余的操作中选择得分最高的操作。 Algorithm 1总结了上述过程。 

# Reference
- [Contextualized Perturbation for Textual Adversarial Attack - AMiner](https://www.aminer.cn/pub/5f632df091e011242e3f2b42/contextualized-perturbation-for-textual-adversarial-attack?conf=acl2021?f=zh#rEbrahimi_et+al_2018_a)
