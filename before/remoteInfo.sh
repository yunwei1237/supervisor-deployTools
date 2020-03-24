#!/bin/bash

echo "jconsole远程监控："
echo "------------------------------------------------------------"
## 本机远程ip地址或本地ip地址，用于远程调试
serverIp=$debugIp
## 本地远程调试端口
serverPort=`getUnusePort "5$port"`
echo "${name}模块的jconsole监控地址【${serverIp}:${serverPort}】"
echo "------------------------------------------------------------"
