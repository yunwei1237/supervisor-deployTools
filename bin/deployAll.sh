#!/bin/bash
############################################################
##
##  根据data/modules.data文件重新全部部署
##
###########################################################


basePath=$(cd `dirname $0`; pwd)
dataFile="${basePath}/../data/modules.data"
deployFile="${basePath}/../deploy.sh"
cat ${dataFile} | xargs -n 3 sh ${deployFile}
