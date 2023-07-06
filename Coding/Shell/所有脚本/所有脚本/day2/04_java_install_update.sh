#!/bin/bash
# 功能: 定制java环境部署
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制标准的普通变量
JAVA_SOFT="jdk-8u121-linux-x64.tar.gz"
JAVA_DIR="jdk1.8.0_121"
SOFT_DIR="/data/softs"
SERVER_DIR="/data/server"
JAVA_NAME="java"
JAVA_PROFILE="/etc/profile.d/java.sh"
TMP_FILE="/tmp/java.txt"

# 1 java软件安装
tar xf ${SOFT_DIR}/${JAVA_SOFT} -C ${SERVER_DIR}
ln -s ${SERVER_DIR}/${JAVA_DIR} ${SERVER_DIR}/${JAVA_NAME}

# 2 java环境变量配置文件
cat > ${JAVA_PROFILE} <<-eof
#!/bin/bash
# 设定java环境变量

# 设定基础变量
export JAVA_HOME=${SERVER_DIR}/${JAVA_NAME}
export PATH=\$PATH:\$JAVA_HOME/bin
eof

# 3 java测试
source ${JAVA_PROFILE}
java -version > ${TMP_FILE} 2>&1

# 4 信息格式化展示
java_version=$(grep version ${TMP_FILE} | cut -d '"' -f2)
java_runtime=$(grep Runtime ${TMP_FILE} | cut -d " " -f6 | cut -d ")" -f1)
jvm_type=$(grep mode ${TMP_FILE} | cut -d " " -f8)
rm -f ${TMP_FILE}

echo -e "\e[31m--------------${JAVA_NAME}环境部署状态----------------\e[0m"
printf "\e[31m%s: \e[32m%s\n\e[0m" "java软件版本" "${java_version}"
printf "\e[31m%s: \e[32m%s\n\e[0m" "java运行时环境" "${java_runtime}"
printf "\e[31m%s: \e[32m%s\n\e[0m" "jvm引擎模式" "${jvm_type}"
echo -e "\e[31m---------------------------------------------\e[0m"
