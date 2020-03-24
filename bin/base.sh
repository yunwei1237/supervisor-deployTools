#!/bin/bash

## 查找一个没有被使用的端口号
## 可以指定一个参数，为从哪个端口号（包含当前端口号）开始查询

function getUnusePort(){  
   beginPort=$1
   if [ -z "$beginPort" ];
   then
      beginPort=1025
   fi
   exists=`netstat -anp |grep -w ${beginPort}|wc -l`
   while [ `netstat -anp |grep -w ${beginPort}|wc -l` -ge 1 ]
   do
      beginPort=`expr $beginPort + 1` 
   done 
   echo $beginPort
}

## 备份jar文件
function backupJar(){
   bakPath=$1
   jarFile=$2
   
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

   cp $jarFile $bakPath
}

## 获得当前执行脚本所在目录
function getScriptWd(){
   basepath=$(cd `dirname $0`; pwd)
   echo $basepath
}

function isEmpty(){
   count=`ls $*|wc -w`
   if [ "$count" > "0" ];
   then
    echo "file size $count"
   else
    echo "empty!"
   fi
}


## 执行指定目录下的全部shell脚本
function execShells(){
   shellPath=$1
   if [ ! -d "$shellPath" ];
   then
      echo "要执行的目录不存在：$shellPath"
      return 1
   fi

   shells=(`find $shellPath -name "*.sh"`)
   for shell in ${shells[@]}
   do
      echo "执行脚本：$shell" 
      source $shell
   done
}
