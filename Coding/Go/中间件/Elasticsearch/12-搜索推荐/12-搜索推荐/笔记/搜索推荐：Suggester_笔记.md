## 搜索推荐：Suggest

#### 概述

搜索一般都会要求具有“搜索推荐”或者叫“搜索补全”的功能，即在用户输入搜索的过程中，进行自动补全或者纠错。以此来提高搜索文档的匹配精准度，进而提升用户的搜索体验，这就是Suggest。

#### 四种`Suggester`

- **term suggester**：term suggester正如其名，只基于tokenizer之后的单个term去匹配建议词，并不会考虑多个term之间的关系

  ```json
  POST <index>/_search
  { 
    "suggest": {
      "<suggest_name>": {
        "text": "<search_content>",
        "term": {
          "suggest_mode": "<suggest_mode>",
          "field": "<field_name>"
        }
      }
    }
  }
  ```

  #### Options：

  - **text**：用户搜索的文本
  - **field**：要从哪个字段选取推荐数据
  - **analyzer**：使用哪种分词器
  - **size**：每个建议返回的最大结果数
  - **sort**：如何按照提示词项排序，参数值只可以是以下两个枚举：
    - **score**：分数>词频>词项本身
    - **frequency**：词频>分数>词项本身
  - **suggest_mode**：搜索推荐的推荐模式，参数值亦是枚举：
    - missing：默认值，仅为不在索引中的词项生成建议词
    - popular：仅返回与搜索词文档词频或文档词频更高的建议词
    - always：根据 建议文本中的词项 推荐 任何匹配的建议词
  - **max_edits**：可以具有最大偏移距离候选建议以便被认为是建议。只能是1到2之间的值。任何其他值都将导致引发错误的请求错误。默认为2
  - **prefix_length**：前缀匹配的时候，必须满足的最少字符
  - **min_word_length**：最少包含的单词数量
  - **min_doc_freq**：最少的文档频率
  - **max_term_freq**：最大的词频

- **phrase suggester**：phrase suggester和term suggester相比，对建议的文本会参考上下文，也就是一个句子的其他token，不只是单纯的token距离匹配，它可以基于共生和频率选出更好的建议。
  
  Options：
  
  - real_word_error_likelihood： 此选项的默认值为 0.95。此选项告诉 Elasticsearch 索引中 5% 的术语拼写错误。这意味着随着这个参数的值越来越低，Elasticsearch 会将越来越多存在于索引中的术语视为拼写错误，即使它们是正确的
  - max_errors：为了形成更正，最多被认为是拼写错误的术语的最大百分比。默认值为 1
  - confidence：默认值为 1.0，最大值也是。该值充当与建议分数相关的阈值。只有得分超过此值的建议才会显示。例如，置信度为 1.0 只会返回得分高于输入短语的建议
  - collate：告诉 Elasticsearch 根据指定的查询检查每个建议，以修剪索引中不存在匹配文档的建议。在这种情况下，它是一个匹配查询。由于此查询是模板查询，因此搜索查询是当前建议，位于查询中的参数下。可以在查询下的“params”对象中添加更多字段。同样，当参数“prune”设置为true时，我们将在响应中增加一个字段“collate_match”，指示建议结果中是否存在所有更正关键字的匹配
  - direct_generator：phrase suggester使用候选生成器生成给定文本中每个项可能的项的列表。单个候选生成器类似于为文本中的每个单独的调用term suggester。生成器的输出随后与建议候选项中的候选项结合打分。目前只支持一种候选生成器，即direct_generator。建议API接受密钥直接生成器下的生成器列表；列表中的每个生成器都按原始文本中的每个项调用。
  
- **completion suggester**：自动补全，自动完成，支持三种查询【前缀查询（prefix）模糊查询（fuzzy）正则表达式查询（regex)】 ，主要针对的应用场景就是"Auto Completion"。 此场景下用户每输入一个字符的时候，就需要即时发送一次查询请求到后端查找匹配项，在用户输入速度较高的情况下对后端响应速度要求比较苛刻。因此实现上它和前面两个Suggester采用了不同的数据结构，索引并非通过倒排来完成，而是将analyze过的数据编码成FST和索引一起存放。对于一个open状态的索引，FST会被ES整个装载到内存里的，进行前缀查找速度极快。但是FST只能用于前缀查找，这也是Completion Suggester的局限所在。
  
  - completion：es的一种特有类型，专门为suggest提供，基于内存，性能很高。
  - prefix query：基于前缀查询的搜索提示，是最常用的一种搜索推荐查询。
    - prefix：客户端搜索词
    - field：建议词字段
    - size：需要返回的建议词数量（默认5）
    - skip_duplicates：是否过滤掉重复建议，默认false
  - fuzzy query
    -  fuzziness：允许的偏移量，默认auto
    - transpositions：如果设置为true，则换位计为一次更改而不是两次更改，默认为true。
    - min_length：返回模糊建议之前的最小输入长度，默认 3
    - prefix_length：输入的最小长度（不检查模糊替代项）默认为 1
    - unicode_aware：如果为true，则所有度量（如模糊编辑距离，换位和长度）均以Unicode代码点而不是以字节为单位。这比原始字节略慢，因此默认情况下将其设置为false。
  - regex query：可以用正则表示前缀，不建议使用
  
- **context suggester**：完成建议者会考虑索引中的所有文档，但是通常来说，我们在进行智能推荐的时候最好通过某些条件过滤，并且有可能会针对某些特性提升权重。

  - contexts：上下文对象，可以定义多个
    - name：`context`的名字，用于区分同一个索引中不同的`context`对象。需要在查询的时候指定当前name
    - type：`context`对象的类型，目前支持两种：category和geo，分别用于对suggest  item分类和指定地理位置。
    - boost：权重值，用于提升排名
  - path：如果没有path，相当于在PUT数据的时候需要指定context.name字段，如果在Mapping中指定了path，在PUT数据的时候就不需要了，因为           Mapping是一次性的，而PUT数据是频繁操作，这样就简化了代码。这段解释有木有很牛逼，网上搜到的都是官方文档的翻译，觉悟雷同。



