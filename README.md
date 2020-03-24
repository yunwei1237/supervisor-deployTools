# 部署工具使用手册

## 1.简介

本系统主要用于在supervisor的基础之上进行服务配置文件生成和服务部署功能。

## 2.功能

- 便捷部署
- 服务多开
- 简单配置
- 自动备份
- 批量启动

## 3.使用步骤

### 1.下载脚本

```shell
git clone git@git.ivymei.com:tancf/supervisor-deployTools.git
```

### 2.安装supervistor

执行安装脚本就可以完成安装

```shell
sh bin/installSupervistor.sh
```

### 3.修改配置文件

配置文件有默认值，如果于当前系统不符，必须进行修改

```shell
vim deploy.conf
```

#### 1.远程调试IP地址

```shell
debugIp="192.168.1.112"
```

#### 2.jar文件所在路径

```shell
jarPath=/data/www/jar
```

#### 3.日志路径

```shell
logsPath=/logs
```

#### 4.jar文件备份路径

```shell
jarBakPath=/data/www/jar/bak
```

#### 5.java环境变量所在文件

```shell
javaEnvPath=/etc/profile
```

#### 6.supervistor配置文件

如果使用本工具的安装脚本，就可以不用修改

```shell
serviceConfPath=/etc/supervisor/conf.d
```

#### 7.jvm参数

可以根据需要调整

```shell
jvmParams="-Xms512m -Xmx512m"
```

### 4.启动服务

脚本功能：

- 在/etc/supervistor/conf.d目录中生成配置文件
- 启动该服务

```shell
##
## deploy.sh 部署的主要脚本
## filesystem-center 应用名称
## 7869 服务端口号
## local 服务的环境

## 执行以下命令会在/etc/supervistor/conf.d目录中生成filesystem-center.conf配置文件，并启动该服务
sh deploy.sh filesystem-center 7869 local
```

### 5.查看启动服务

#### 1.通过supervistor

```shell
supervisotrctl status filesystem-center
```

#### 2.通过java工具

```shell
jps | grep filesystem-center
```

## 4.高级功能

### 1.批量启动服务

主要用于快速生成程序配置文件和启动所有服务

##### 1.修改配置

modules.data文件会自动保存通过deploy.sh脚本运行过的所有服务参数（已经去重）

```shell
vim data/modules.data
```

#### 2.添加配置

文件就保存的就是deploy.sh脚本的参数，每一行代表一个应用服务

```shell
filesystem-center 7869 local
member-center 7001 local
```

#### 3.批量启动

```shell
sh bin/deployAll.sh
```

### 2.服务多开

单开命令：

```shell
sh deploy.sh filesystem-center 7869 local
```

多开命令：

- 应用名称后添加编号：filesystem-center1
- 修改端口号：7870

```shell
## 在7870端口开一个编号为1的filesystem-center服务
sh deploy.sh filesystem-center1 7870 local
## 在7017端口开一个编号为18的member-center服务
sh deploy.sh member-center18 7017 local
```

### 3.服务增强

- 在before文件夹中的脚本会在服务启动前进行自动执行，如果需要在服务执行前作操作，请在这里新建脚本文件，如，jar文件自动备份，脚本参数自动保存，远程调试信息生成。

- 在after文件夹中的脚本会在服务启动后进行自动执行，如果需要在服务执行后作操作，请在这里新建脚本文件，如，服务启动信息显示。

### 4.系统脚本

在funs文件夹中保存的是一些功能函数，该文件夹下的脚本也会被自动加载。

## 注意事项

- 如果需要在另一个环境上使用本工具，请尽量修改deploy.conf来适应新的环境。
-  如果需要在服务运行之前作一些工作，请在before文件夹中添加脚本文件，服务启动前该文件夹下的所有脚本都会执行。
- 如果需要在服务运行之后作一些工作，请在after文件夹中添加脚本文件，服务启动后该文件夹下的所有脚本都会执行。
- 4.本工具中所有脚本中的变量都是通用的，所以创建变量时请注意全局唯一！！！
- 5.在bin目录中有一些辅助工具，base.sh是系统必要的基础函数库，请尽量不要修改，如果需要添加新的函数模块，请在funcs目录中添加新的脚本，部署启动后会第一时间加载到系统中。


  有问题请联系：archer
