- Time：2023-06-26 13:48
- Label： #ssh #windows

## Abstract

记录 windows 安装 ssh 的过程

## Content

```shell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

you should read the source code.

为什么要使用命令行呢？因为可以更方便的通过编程语言去批量处理。

## Reference

- [Windows安装SSH_酒色伤我的博客-CSDN博客](https://blog.csdn.net/qq_42739776/article/details/124032652?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522168775830816800197045186%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=168775830816800197045186&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-2-124032652-null-null.142^v88^control_2,239^v2^insert_chatgpt&utm_term=windows11%20%E5%A6%82%E4%BD%95%E5%AE%89%E8%A3%85%20ssh&spm=1018.2226.3001.4187)
- [Get started with OpenSSH for Windows | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell)
