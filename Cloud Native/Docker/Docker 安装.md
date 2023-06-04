## Linux 安装 Docker

- [centos 安装 docker](https://blog.csdn.net/puzi0315/article/details/121140518?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166341448216782425161574%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166341448216782425161574&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-121140518-null-null.142^v47^pc_rank_34_default_23,201^v3^control_1&utm_term=centos%20%E5%AE%89%E8%A3%85%20docker&spm=1018.2226.3001.4187)
- [(127条消息) Centos安装Docker的详细安装步骤_你的可用余额的博客-CSDN博客_centos安装docker](https://blog.csdn.net/PyongSen/article/details/123053374?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166476581616782391879430%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166476581616782391879430&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-123053374-null-null.142^v51^control,201^v3^add_ask&utm_term=centos%E5%AE%89%E8%A3%85%20docker&spm=1018.2226.3001.4187)
- [(130条消息) Centos7安装Docker_玩物丧志的快乐的博客-CSDN博客](https://blog.csdn.net/qq_26400011/article/details/113856681?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166501678616782395373951%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166501678616782395373951&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-113856681-null-null.142^v51^control,201^v3^add_ask&utm_term=centos7%E5%AE%89%E8%A3%85docker&spm=1018.2226.3001.4187)

sudo tee /etc/docker/daemon.json <<-'EOF'  
{  
  "registry-mirrors": ["xxxx 替换自己的加速地址 "]  
}  
EOF

- 阿里云镜像地址

## Windows 安装

- 升级成 win 专业版
- wsl2


