#!/bin/bash
##############################################################
##
##
## 部署supervisor服务
## 主要功能：
## 1.创建supervisor服务配置文件
## 2.备份jar文件
## 3.备份运行过的服务参数，用于重新生成配置文件和部署
## 4.更新supervisor服务配置和重新服务
##
##############################################################


appName=$1
port=$2
profile=$3

## 提供多开功能
## 如果appName后边有数数字，代表要多开，如：goods-center1，goods-center是模块名，1是编号
name=$(echo "${appName}" | tr -d '[0-9]')
moduleNo=$(echo "${appName}" | tr -d '[a-zA-Z_\-]')

echo "应用名称：${appName}"
echo "模块名称：${name}"
echo "模块编号：${moduleNo}"
echo "服务端口：${port}"
echo "当前环境：${profile}"

## 当前脚本所在目录
basePath=$(cd `dirname $0`; pwd)
echo "当前脚本所在目录：${basePath}"

source "${basePath}/deploy.conf"
echo "载入工具配置文件：${basePath}/deploy.conf"
source $javaEnvPath
echo "载入包含JAVA_HOME环境变量的配置文件：${javaEnvPath}"
source $baseFuncFile
echo "载入基本函数文件:${baseFuncFile}"

echo "载入全部函数文件"
execShells $funcsPath

echo "即将生成服务配置文件"
echo "处理参数信息"

if [ -z "${name}" ];
then
   echo "错误：服务的名称不能为空"
   exit -1
fi

if [ -z "${port}" ];
then
   echo "错误：服务的端口号不能为空"
   exit -1
fi

echo "处理内部变量"
## 系统变量
cfgFile="${serviceConfPath}/${appName}.conf"
jarFile="${jarPath}/${name}.jar"
logPath="${logsPath}/${appName}"
javaHome="$JAVA_HOME/bin"

## 服务参数

appArgs="--server.port=${port}"
if [ -n "${profile}" -a "${profile}" != "null"  ];
then
   appArgs="$appArgs --spring.profiles.active=${profile}"
fi

## 检测日志目录是否存在，不存在就生成
if [ ! -d "$logPath" ];
then
   mkdir -p $logPath
fi

if [ ! -f "${logPath}/err.log" ];
then
   echo "生成错误日志文件：${logPath}/err.log"
   touch "${logPath}/err.log"
fi


if [ ! -f "${logPath}/std.log" ];
then
   echo "生成标准日志文件：${logPath}/std.log"
   touch "${logPath}/std.log"
fi

## 检测jar文件是否存在
if [ ! -f "$jarFile" ];
then
   echo "错误：${jarFile}文件不存在"
   exit -1
fi

## 检测java是否安装
if [ ! -f "${javaHome}/java" ];
then
   echo "错误：没有配置JAVA_HOME环境变量或者没有安装java：${javaHome}/java"
   exit -1
fi

## 检测配置文件是否存在，不存在就生成，存在就删除后重新生成
if [ -f "$cfgFile" ];
then
   echo "文件已经存在，删除配置文件：$cfgFile！！！"
   rm -fr $cfgFile
fi
echo "生成配置文件：$cfgFile"
touch $cfgFile

## 生成配置文件之前执行相应的额外功能

if [ ! -d "$beforePath" ];
then 
   mkdir -p $beforePath
fi

echo "执行服务启动前的脚本："
execShells $beforePath

## jvm参数
jvmArgs=$jvmParams
jvmArgs="$jvmArgs -Dorg.xml.sax.parser=com.sun.org.apache.xerces.internal.parsers.SAXParser -Djavax.xml.parsers.SAXParserFactory=com.sun.org.apache.xerces.internal.jaxp.SAXParserFactoryImpl -Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl"
jvmArgs="$jvmArgs -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=$serverIp -Dcom.sun.management.jmxremote.port=$serverPort -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

echo "开始生成配置文件"
## 生成文件
echo "[program:${appName}] ;程序名称，终端控制时需要的标识" >> $cfgFile
echo "command=java ${jvmArgs} -jar ${jarFile} ${appArgs}  ; 运行程序的命令" >> $cfgFile
echo "directory=${javaHome} ; 命令执行的目录" >> $cfgFile
echo "autostart = true    ;在supervisord 启动的时候也自动启动" >> $cfgFile
echo "startsecs = 5           ;启动 1 秒后没有异常退出，就当作已经正常启动了" >> $cfgFile
echo "startretries = 3        ;启动失败自动重试次数，默认是 3" >> $cfgFile
echo "autorestart=true ; 程序意外退出是否自动重启" >> $cfgFile
echo "stderr_logfile=${logPath}/err.log ; suppervisor服务启动错误日志文件" >> $cfgFile
echo "stdout_logfile=${logPath}/std.log ; suppervisor服务启动输出日志文件" >> $cfgFile
#echo "environment=ASPNETCORE_ENVIRONMENT=Production ; 进程环境变量" >> $cfgFile
echo "user=root ; 进程执行的用户身份" >> $cfgFile
echo "stopsignal=INT ;停止信号" >> $cfgFile

echo "配置文件${cfgFile}已经生成完成"

echo "配置信息如下："
echo "------------------------------------------------------------"
cat $cfgFile
echo "------------------------------------------------------------"

echo "${name}:更新配置"
supervisorctl update

#echo "${name}:重启服务"
#supervisorctl restart ${name}

if [ ! -d "$afterPath" ];
then
   mkdir -p $afterPath
fi

echo "执行服务启动后的脚本："
execShells $afterPath
echo "done"
## 返回执行结束状态码
exit 0