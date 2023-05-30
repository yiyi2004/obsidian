建议尝试重置一下 Edge：  
浏览器右上角 3 个点 ---- 设置 ---- 重置设置 ---- 还原其默认值。  

然后重置一下网络：  
右击开始菜单 ---- “Windows PowerShell (管理员)”，输入：  
netsh winsock reset  
回车  
netsh int ip reset  
回车  
ipconfig /release  
回车  
ipconfig /renew  
回车  
ipconfig /flushdns  
回车  
ipconfig /registerdns  
回车  
执行完毕后直接重启设备  

修改 DNS：  

1. 右键网络连接图标，选择 “打开网络和共享中心”。  
2. 点击现在连接的网络名称，打开网络状态窗口，点击 “属性”，在网络属性窗口中双击 “Internet 协议版本 4 (TCP / IPv4)”。  
3. 将 DNS 服务器手动设置为“8.8.8.8” 和 “8.8.4.4”，确定。  
4. 任务栏搜索框输入 Internet 打开 Internet 选项 --- 高级 --- 使用 TLS1.0 使用 TLS1.1 使用 TLS1.2 使用 TLS1.3（实验） 这 4 个打上勾。  

执行完毕上述方案后，请您重启设备  

🤡are you kidding me? I don't wanna close my label page.
