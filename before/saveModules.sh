#/bin/bash

## 将启动服务信息保存到文件中，以便查看启动过服务，并且也可以快速生成以前所有服务配置文件

echo "备份module参数"
echo "------------------------------------------------------------"

modulesPath="${basePath}/data"
modulesFile="${modulesPath}/modules.data"

## 如果保存数据的目录不存在就创建目录
if [ ! -d "$modulesPath" ];
then
   mkdir -p $modulesPath
fi

## 如果保存数据的文件不存在就创建文件
if [ ! -f "$modulesFile" ];
then
   echo "生成${modulesFile}文件"
   touch "$modulesFile"
fi
## 保存执行的项目信息
if [ -z "$profile" ];
then
   moduleRow="${appName} ${port} null"
else
   moduleRow="${appName} ${port} ${profile}"
fi

## 如果项目信息不存在就保存，如果项目信息已经存在就跳过
exists=`grep "$moduleRow" $modulesFile`

if [ -z "$exists" ];
then
   echo "将[${moduleRow}]保存到文件${modulesFile}"
   echo $moduleRow >> $modulesFile
fi

echo "------------------------------------------------------------"

