1、首先在所在系统中安装 Anaconda。可以打开命令行输入 conda -V 检验是否安装以及当前 conda 的版本。  
2、conda 常用的命令。  
    1）conda list 查看安装了哪些包。  
    2）  
conda env list  
conda info -e  
conda info --envs  
查看当前存在哪些虚拟环境  
    3）conda update conda 检查更新当前 conda  
    4) conda activate EnvName  激活虚拟环境  
3、创建 python 虚拟环境。  
     使用 conda create -n your_env_name python=X.X（2.7、3.6 等) 命令创建 python 版本为 X.X、名字为 your_env_name 的虚拟环境。your_env_name 文件可以在 Anaconda 安装目录 envs 文件下找到。  
4、使用激活 (或切换不同 python 版本) 的虚拟环境。  
    打开命令行输入 python --version 可以检查当前 python 的版本。  
    使用如下命令即可 激活你的虚拟环境 (即将 python 的版本改变)。  
    Linux:  source activate your_env_name(虚拟环境名称)  
    Windows: activate your_env_name(虚拟环境名称)  
   这是再使用 python --version 可以检查当前 python 版本是否为想要的。  
5、对虚拟环境中安装额外的包。  
    使用命令 conda install -n your_env_name [package] 即可安装 package 到 your_env_name 中  
6、关闭虚拟环境 (即从当前环境退出返回使用 PATH 环境中的默认 python 版本)。  
   使用如下命令即可。  
   Linux: source deactivate  
   Windows: deactivate  
7、删除虚拟环境。  
   使用命令 conda remove -n your_env_name(虚拟环境名称) --all， 即可删除。  
8、删除环境中的某个包。  
   使用命令 conda remove --name your_env_name  package_name 即可。
