#!/bin/bash

## 配置文件
coreCfgFile=/etc/supervisor/supervisord.conf
## 服务配置路径
servicePath=/etc/supervisor/conf.d

## 运行目录
runDir=/var/run/supervisor

echo '检测是否安装pip'
if [ ! -f "/usr/bin/pip" ];
then
	echo "开始安装pip工具"
	sudo yum install -y pip
fi

echo '检测是否已经安装supervistor'

if [ -f "/usr/bin/supervisord" ];
then
	echo "supervistor已经安装，不需要再次安装"
	exit 1
fi

echo '开始安装supervisor进程管理工具'
pip install supervisor

echo '创建supervistor配置文件目录'
mkdir -p ${servicePath}

echo '创建supervistor核心配置文件'
echo_supervisord_conf > ${coreCfgFile}

echo '开放http访问功能'
sed -i 's/;\[inet_http_server\]/\[inet_http_server\]/g' ${coreCfgFile}
sed -i 's/;port=127.0.0.1:9001/port=127.0.0.1:9001/g' ${coreCfgFile}

[ ! -d "$runDir" ] && mkdir -p $runDir

echo '切换运行时需要的文件在${runDir}目录，如sock文件，pid文件等等'
sed -i 's/tmp/var\/run\/supervisor/g' ${coreCfgFile}

echo '增加进程配置目录'
echo '' >> ${coreCfgFile}
echo ';supervisor管理的进程配置文件都在这个目录中' >> ${coreCfgFile}
echo '[include]' >> ${coreCfgFile}
echo 'files = conf.d/*.conf' >> ${coreCfgFile}

echo '开机启动'
echo '/usr/bin/supervisord -c ${coreCfgFile}' >> /etc/rc.local

echo '安装成功'
exit 0