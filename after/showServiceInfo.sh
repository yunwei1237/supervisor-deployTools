#!/bin/bash

echo "服务启动信息如下："
echo "------------------------------------------------------------"
supervisorctl status ${appName}
echo "------------------------------------------------------------"
