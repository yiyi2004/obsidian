# -*- coding: utf-8 -*-
# python 3

import requests
url = "http://www.baidu.com"
resp = requests.get(url = url, params = {}, headers = {})
print(resp.text)
