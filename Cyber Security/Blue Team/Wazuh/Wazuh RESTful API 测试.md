- token expired after a period of time(default 900s)

- [ ] 找出重要的 API 先筛选一波

# RESTful API
- test for wazuh server API service

# Command
```shell
Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
  indexer_username: 'admin'
  indexer_password: 'W9C+Y08yS*2WNskK6fA26O?bPp*9xiYM'

12/11/2022 09:50:50 INFO: You can access the web interface https://<wazuh-dashboard-ip>
    User: admin
    Password: BehGh6Oz?.8NU*3.iVyYOwtK6qdwMSt9
12/11/2022 09:50:50 INFO: Installation finished.


curl -u wazuh:'3D?ab85SDBhFlKem?sgTd4R3NYF1o29S' -k -X GET "https://localhost:55000/security/user/authenticate?raw=true"

curl -u wazuh:'zsnXilqESc1bAYDRD23dqB+*dM?oaIOZ' -k -X GET "https://192.168.184.128:55000/security/user/authenticate?raw=true"

systemctl restart  wazuh-indexer.service wazuh-manager.service wazuh-dashboard.service  wazuh-indexer-performance-analyzer.service 
```


# Username & Password
```txt
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
- 主机攻击的样本。

# Reference
- [List agents | Wazuh | Postman API Network](https://www.postman.com/api-evangelist/workspace/wazuh/request/35240-17649212-af64-46d3-b796-216e9d0b0da4)
- [Integrating Suricata With Wazuh For Log Processing - YouTube](https://www.youtube.com/watch?v=NB_u9m-MMcY)
- [或许你应该学学 postman - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/33481273)
