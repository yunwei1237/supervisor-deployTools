#!/bin/bash


nginxDir=$1

if [ -z "$nginxDir" ];
then
	echo "使用默认路径进行安装：/usr/loca/nginx"
	nginxDir='/usr/loca/nginx'
fi

loginName=$(env | grep LOGNAME | cut -d = -f 2)

if [ "$loginName" != 'root' ];
then
	echo "请使用root账号进行安装"
	exit 1
fi

if [ ! -f 'nginx-1.16.0.tar.gz' ];
then
	echo '下载文件'
	wget http://nginx.org/download/nginx-1.16.0.tar.gz
fi

if [ ! -d 'nginx-1.16.0' ];
then
	echo '解压文件'
	tar -zxvf nginx-1.16.0.tar.gz
fi

cd nginx-1.16.0

echo "安装依赖包pcre pcre-devel"
yum install -y pcre pcre-devel
echo "安装依赖包zlib zlib-devel"
yum install -y zlib zlib-devel
echo "安装依赖包openssl openssl-devel"
yum -y install openssl openssl-devel

echo "安装nginx包含模块如下："
echo "with-http_stub_status_module"
echo "with-http_ssl_module"
./configure --prefix=${nginxDir} --with-http_stub_status_module --with-http_ssl_module && make && make install
echo "安装nginx完成"
