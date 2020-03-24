#!/bin/bash

echo "备份jar文件："
echo "------------------------------------------------------------"

curTime=`date "+%Y%m%d%H%M%S"`

bakPath="${jarBakPath}/${name}"
jarFile="${jarPath}/${name}.jar"
bakJarFile="${bakPath}/${name}_${curTime}.jar"
if [ ! -d "$bakPath" ];
then
   echo "备份目录不存在：$bakPath"
   mkdir -p $bakPath
   echo "新建备份目录：$bakPath"
fi

if [ ! -f "$jarFile" ];
then
   echo "备份的jar文件不存在：$jarFile"
   return 1
fi

cp $jarFile $bakJarFile

echo "成功将${jarFile}文件备份到${bakJarFile}"
echo "------------------------------------------------------------"
