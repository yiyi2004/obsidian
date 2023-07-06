```json
#term suggest

DELETE news
POST _bulk
{ "index" : { "_index" : "news","_id":1 } }
{ "title": "baoqiang bought a new hat with the same color of this font, which is very beautiful baoqiangba baoqiangda baoqiangdada baoqian baoqia"}
{ "index" : { "_index" : "news","_id":2 } }
{ "title": "baoqiangge gave birth to two children, one is upstairs, one is downstairs baoqiangba baoqiangda baoqiangdada baoqian baoqia"}
{ "index" : { "_index" : "news","_id":3} }
{ "title": "baoqiangge 's money was rolled away baoqiangba baoqiangda baoqiangdada baoqian baoqia"}
{ "index" : { "_index" : "news","_id":4} }
{ "title": "baoqiangda baoqiangda baoqiangda baoqiangda baoqiangda baoqian baoqia"}

GET news/_mapping

POST _analyze
{
  "text": [
    "BaoQiang bought a new hat with the same color of this font, which is very beautiful",
    "BaoQiangGe gave birth to two children, one is upstairs, one is downstairs",
    "BaoQiangGe 's money was rolled away"
  ]
}

POST /news/_search
{
  "suggest": {
    "my-suggestion": {
      "text": "baoqing baoqiang",
      "term": {
        "suggest_mode":"always",
        "field": "title",
        "min_doc_freq": 3
      }
    }
  }
}


GET /news/_search
{ 
  "suggest": {
    "my-suggestion": {
      "text": "baoqing baoqiang",
      "term": {
        "suggest_mode": "popular",
        "field": "title"
      }
    }
  }
}

GET /news/_search
{ 
  "suggest": {
    "my-suggestion": {
      "text": "baoqing baoqiang",
      "term": {
        "suggest_mode": "popular",
        "field": "title",
        "max_edits":2,
        "max_term_freq":1
      }
    }
  }
}

GET /news/_search
{ 
  "suggest": {
    "my-suggestion": {
      "text": "baoqing baoqiang",
      "term": {
        "suggest_mode": "always",
        "field": "title",
        "max_edits":2
      }
    }
  }
}

DELETE news2
POST _bulk
{ "index" : { "_index" : "news2","_id":1 } }
{ "title": "baoqiang4"}
{ "index" : { "_index" : "news2","_id":2 } }
{ "title": "baoqiang4 baoqiang3"}
{ "index" : { "_index" : "news2","_id":3 } }
{ "title": "baoqiang4 baoqiang3 baoqiang2"}
{ "index" : { "_index" : "news2","_id":4 } }
{ "title": "baoqiang4 baoqiang3 baoqiang2  baoqiang"}
POST /news2/_search
{ 
  "suggest": {
    "second-suggestion": {
      "text": "baoqian baoqiang baoqiang2 baoqiang3",
      "term": {
        "suggest_mode": "popular",
        "field": "title"
      }
    }
  }
}



#phrase suggester
DELETE test
PUT test
{
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0,
      "analysis": {
        "analyzer": {
          "trigram": {
            "type": "custom",
            "tokenizer": "standard",
            "filter": [
              "lowercase",
              "shingle"
            ]
          }
        },
        "filter": {
          "shingle": {
            "type": "shingle",
            "min_shingle_size": 2,
            "max_shingle_size": 3
          }
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "fields": {
          "trigram": {
            "type": "text",
            "analyzer": "trigram"
          }
        }
      }
    }
  }
}

GET /_analyze
{
  "tokenizer": "standard",
  "filter": [
    {
      "type": "shingle",
      "min_shingle_size": 2,
      "max_shingle_size": 3
    }
  ],
  "text": "lucene and elasticsearch"
}


# "min_shingle_size": 2,
# "max_shingle_size": 3
GET test/_analyze
{
  "analyzer": "trigram", 
  "text" : "lucene and elasticsearch"
}
DELETE test
POST test/_bulk
{ "index" : { "_id":1} }
{"title": "lucene and elasticsearch"}
{ "index" : {"_id":2} }
{"title": "lucene and elasticsearhc"}
{ "index" : { "_id":3} }
{"title": "luceen and elasticsearch"}

POST test/_search
GET test/_mapping
POST test/_search
{
  "suggest": {
    "text": "Luceen and elasticsearhc",
    "simple_phrase": {
      "phrase": {
        "field": "title.trigram",
        "max_errors": 2,
        "gram_size": 1,
        "confidence":0,
        "direct_generator": [
          {
            "field": "title.trigram",
            "suggest_mode": "always"
          }
        ],
        "highlight": {
          "pre_tag": "<em>",
          "post_tag": "</em>"
        }
      }
    }
  }
}

#complate suggester
DELETE suggest_carinfo
PUT suggest_carinfo
{
  "mappings": {
    "properties": {
        "title": {
          "type": "text",
          "analyzer": "ik_max_word",
          "fields": {
            "suggest": {
              "type": "completion",
              "analyzer": "ik_max_word"
            }
          }
        },
        "content": {
          "type": "text",
          "analyzer": "ik_max_word"
        }
      }
  }
}



POST _bulk
{"index":{"_index":"suggest_carinfo","_id":1}}
{"title":"宝马X5 两万公里准新车","content":"这里是宝马X5图文描述"}
{"index":{"_index":"suggest_carinfo","_id":2}}
{"title":"宝马5系","content":"这里是奥迪A6图文描述"}
{"index":{"_index":"suggest_carinfo","_id":3}}
{"title":"宝马3系","content":"这里是奔驰图文描述"}
{"index":{"_index":"suggest_carinfo","_id":4}}
{"title":"奥迪Q5 两万公里准新车","content":"这里是宝马X5图文描述"}
{"index":{"_index":"suggest_carinfo","_id":5}}
{"title":"奥迪A6 无敌车况","content":"这里是奥迪A6图文描述"}
{"index":{"_index":"suggest_carinfo","_id":6}}
{"title":"奥迪双钻","content":"这里是奔驰图文描述"}
{"index":{"_index":"suggest_carinfo","_id":7}}
{"title":"奔驰AMG 两万公里准新车","content":"这里是宝马X5图文描述"}
{"index":{"_index":"suggest_carinfo","_id":8}}
{"title":"奔驰大G 无敌车况","content":"这里是奥迪A6图文描述"}
{"index":{"_index":"suggest_carinfo","_id":9}}
{"title":"奔驰C260","content":"这里是奔驰图文描述"}
{"index":{"_index":"suggest_carinfo","_id":10}}
{"title":"nir奔驰C260","content":"这里是奔驰图文描述"}


GET suggest_carinfo/_search?pretty
{
  "suggest": {
    "car_suggest": {
      "prefix": "奥迪",
      "completion": {
        "field": "title.suggest"
      }
    }
  }
}

#1：内存代价太大，原话是：性能高是通过大量的内存换来的
#2：只能前缀搜索,假如用户输入的不是前缀 召回率可能很低

POST suggest_carinfo/_search
{
  "suggest": {
    "car_suggest": {
      "prefix": "宝马5系",
      "completion": {
        "field": "title.suggest",
        "skip_duplicates":true,
        "fuzzy": {
          "fuzziness": 2
        }
      }
    }
  }
}
GET suggest_carinfo/_doc/10
GET _analyze
{
  "analyzer": "ik_max_word",
  "text": ["奔驰AMG 两万公里准新车"]
}

POST suggest_carinfo/_search
{
  "suggest": {
    "car_suggest": {
      "regex": "nir",
      "completion": {
        "field": "title.suggest",
        "size": 10
      }
    }
  }
}

# context suggester
# 定义一个名为 place_type 的类别上下文，其中类别必须与建议一起发送。
# 定义一个名为 location 的地理上下文，类别必须与建议一起发送
DELETE place
PUT place
{
  "mappings": {
    "properties": {
      "suggest": {
        "type": "completion",
        "contexts": [
          {
            "name": "place_type",
            "type": "category"
          },
          {
            "name": "location",
            "type": "geo",
            "precision": 4
          }
        ]
      }
    }
  }
}

PUT place/_doc/1
{
  "suggest": {
    "input": [ "timmy's", "starbucks", "dunkin donuts" ],
    "contexts": {
      "place_type": [ "cafe", "food" ]                    
    }
  }
}
PUT place/_doc/2
{
  "suggest": {
    "input": [ "monkey", "timmy's", "Lamborghini" ],
    "contexts": {
      "place_type": [ "money"]                    
    }
  }
}


GET place/_search
POST place/_search?pretty
{
  "suggest": {
    "place_suggestion": {
      "prefix": "sta",
      "completion": {
        "field": "suggest",
        "size": 10,
        "contexts": {
          "place_type": [ "cafe", "restaurants" ]
        }
      }
    }
  }
}
# 某些类别的建议可以比其他类别提升得更高。以下按类别过滤建议，并额外提升与某些类别相关的建议
GET place/_search
POST place/_search?pretty
{
  "suggest": {
    "place_suggestion": {
      "prefix": "tim",
      "completion": {
        "field": "suggest",
        "contexts": {
          "place_type": [                             
            { "context": "cafe" },
            { "context": "money", "boost": 2 }
          ]
        }
      }
    }
  }
}

# 地理位置筛选器
PUT place/_doc/3
{
  "suggest": {
    "input": "timmy's",
    "contexts": {
      "location": [
        {
          "lat": 43.6624803,
          "lon": -79.3863353
        },
        {
          "lat": 43.6624718,
          "lon": -79.3873227
        }
      ]
    }
  }
}
POST place/_search
{
  "suggest": {
    "place_suggestion": {
      "prefix": "tim",
      "completion": {
        "field": "suggest",
        "contexts": {
          "location": {
            "lat": 43.662,
            "lon": -79.380
          }
        }
      }
    }
  }
}



# 定义一个名为 place_type 的类别上下文，其中类别是从 cat 字段中读取的。
# 定义一个名为 location 的地理上下文，其中的类别是从 loc 字段中读取的
DELETE place_path_category
PUT place_path_category
{
  "mappings": {
    "properties": {
      "suggest": {
        "type": "completion",
        "contexts": [
          {
            "name": "place_type",
            "type": "category",
            "path": "cat"
          },
          {
            "name": "location",
            "type": "geo",
            "precision": 4,
            "path": "loc"
          }
        ]
      },
      "loc": {
        "type": "geo_point"
      }
    }
  }
}
# 如果映射有路径，那么以下索引请求就足以添加类别
# 这些建议将与咖啡馆和食品类别相关联
# 如果上下文映射引用另一个字段并且类别被明确索引，则建议将使用两组类别进行索引
PUT place_path_category/_doc/1
{
  "suggest": ["timmy's", "starbucks", "dunkin donuts"],
  "cat": ["cafe", "food"] 
}
POST place_path_category/_search?pretty
{
  "suggest": {
    "place_suggestion": {
      "prefix": "tim",
      "completion": {
        "field": "suggest",
        "contexts": {
          "place_type": [                             
            { "context": "cafe" }
          ]
        }
      }
    }
  }
}

```

