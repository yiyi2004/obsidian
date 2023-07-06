#!/bin/bash
# 功能: 定制java环境部署
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 1 java软件安装
tar xf /data/softs/jdk-8u121-linux-x64.tar.gz -C /data/server/
ln -s /data/server/jdk1.8.0_121 /data/server/java

# 2 java环境变量配置文件
cat > /etc/profile.d/java.sh <<-eof
#!/bin/bash
# 设定java环境变量

# 设定基础变量
export JAVA_HOME=/data/server/java
export PATH=\$PATH:\$JAVA_HOME/bin
eof

# 3 java测试
source /etc/profile.d/java.sh
java -version > /tmp/java.txt 2>&1

# 4 信息格式化展示
java_version=$(grep version /tmp/java.txt | cut -d '"' -f2)
java_runtime=$(grep Runtime /tmp/java.txt | cut -d " " -f6 | cut -d ")" -f1)
jvm_type=$(grep mode /tmp/java.txt | cut -d " " -f8)

echo -e "\e[31m--------------java环境部署状态----------------\e[0m"
printf "\e[31m%s: \e[32m%s\n\e[0m" "java软件版本" "${java_version}"
printf "\e[31m%s: \e[32m%s\n\e[0m" "java运行时环境" "${java_runtime}"
printf "\e[31m%s: \e[32m%s\n\e[0m" "jvm引擎模式" "${jvm_type}"
echo -e "\e[31m---------------------------------------------\e[0m"
