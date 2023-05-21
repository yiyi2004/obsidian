- localhost
```text

Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'admin'
  indexer_password: 'W9C+Y08yS*2WNskK6fA26O?bPp*9xiYM'

# Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'admin'
  indexer_password: 'BehGh6Oz?.8NU*3.iVyYOwtK6qdwMSt9'

# Wazuh dashboard user for establishing the connection with Wazuh indexer
  indexer_username: 'kibanaserver'
  indexer_password: '*W?22twW?CgP3fB9.vS?iD93GIghDNGE'

# Regular Dashboard user, only has read permissions to all indices and all permissions on the .kibana index
  indexer_username: 'kibanaro'
  indexer_password: 'jkB5i8qTrwDRL+Py?WgwXJpnVqjec1fO'

# Filebeat user for CRUD operations on Wazuh indices
  indexer_username: 'logstash'
  indexer_password: 'mjuUa0L3glDSI2E0lBTyoKTR+2zNU.gi'

# User with READ access to all indices
  indexer_username: 'readall'
  indexer_password: '22.y5v7WighQS9dhcrbpkuyYwCH2Fm+R'

# User with permissions to perform snapshot and restore operations
  indexer_username: 'snapshotrestore'
  indexer_password: '+Trh?2dt8Z7i+uESvK3yqTKkbZOSOKNp'

# Password for wazuh API user
  api_username: 'wazuh'
  api_password: 'zsnXilqESc1bAYDRD23dqB+*dM?oaIOZ'

# Password for wazuh-wui API user
  api_username: 'wazuh-wui'
  api_password: '4Z7mfuH*O8sDM1hf1aQMUabhEyC0yScx'

```
- Cloud
```shell
# Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'admin'
  indexer_password: 'wXSnfqGNdT5TuC+*pgUu9GZ8x5jyqzi.'

# Wazuh dashboard user for establishing the connection with Wazuh indexer
  indexer_username: 'kibanaserver'
  indexer_password: 'hfG4kKZm27TIQ2fPVnlZ33hvHhKl.LKx'

# Regular Dashboard user, only has read permissions to all indices and all permissions on the .kibana index
  indexer_username: 'kibanaro'
  indexer_password: 'WYWfNVKrx+0Ay18FhpzGyCLiYsv5OGp9'

# Filebeat user for CRUD operations on Wazuh indices
  indexer_username: 'logstash'
  indexer_password: '848alFDTsQmy4wHPrElFluc4wb**OHE.'

# User with READ access to all indices
  indexer_username: 'readall'
  indexer_password: 'fzaprhT*3VOhpPmnQrAWxTjr2o*dAgBl'

# User with permissions to perform snapshot and restore operations
  indexer_username: 'snapshotrestore'
  indexer_password: 'lfV4?xWHTXUA2Q7Ts2*0C6zt9y2nl?oT'

# Password for wazuh API user
  api_username: 'wazuh'
  api_password: 'fS1CdeEB3A.OkJO2f*ZMFTOu3s++xh6o'

# Password for wazuh-wui API user
  api_username: 'wazuh-wui'
  api_password: 'oTrKmDUfRx3uKYR2R+*iUB+RdJzAQfB*'
```

![[../../ATT&CK/Snipaste/Pasted image 20221030170510.png]]
![[../../ATT&CK/Snipaste/Pasted image 20221030230256.png]]
```shell
curl -u wazuh:'3D?ab85SDBhFlKem?sgTd4R3NYF1o29S' -k -X GET "https://localhost:55000/security/user/authenticate?raw=true"

curl -u wazuh:'zsnXilqESc1bAYDRD23dqB+*dM?oaIOZ' -k -X GET "https://192.168.184.128:55000/security/user/authenticate?raw=true"

curl -XPOST "https://192.168.116.159:443/_plugins/_sql" -k -u admin:W9C+Y08yS*2WNskK6fA26O?bPp*9xiYM  -H 'Content-Type: application/json' -d '{"query": "SELECT * FROM wazuh-alerts-4.x-2022.06.28 LIMIT 50"}'
```

```json
{
    "query":{
        "bool":{
            "must":{
                "exists":{
                    "field":"rule.mitre.id"
                }
            }
        }
    }
}
```

# sample
```shell

GET _search
{
  "query": {
    "match_all": {}
  }
}

GET /wazuh-alerts-4.x-2022.11.12/_search
{
  "query": {
    "match": {
      "rule.mitre.tactic":"Impact"
    }
  }
}

GET /wazuh-alerts-4.x-*/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "exists": {
            "field": "rule.mitre.id"
          }
        },
        {
          "range" : {
            "timestamp" : {
              "gt" : "2022-11-14T10:05:36.956+0000",
              "lt" : "2022-11-17T10:05:36.956+0000"
            }
          }
        },
        {
          "bool": {
            "must": [
                {
                  "match":{
                    "rule.mitre.technique": "Endpoint Denial of Service"
                  }
                }
              ]
          }
        }
       
      ]
    }
  }
}

GET /wazuh-alerts-4.x-2022.11.12/_search
{
  "query": {
    "match": {
      "rule.mitre.technique": "Endpoint Denial of Service"
    }
  }
}

GET /wazuh-alerts-4.x-2022.11.*/_search
{
  "query": {
    "match": {
      "rule.mitre.technique": "Endpoint Denial of Service"
    }
  }
}

```

# 搞不清楚的字段


# Reference
- [Search - OpenSearch documentation](https://opensearch.org/docs/1.2/opensearch/rest-api/search/#response-body)
- [(91条消息) es的复杂多条件查询（一）——match、term、bool_祁仙森的博客-CSDN博客](https://blog.csdn.net/xibei19921101/article/details/114392047)

---
```shell
curl -so wazuh-agent-4.3.10.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.10-1_amd64.deb WAZUH_MANAGER='39.105.102.210' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent-4.3.10.deb
```