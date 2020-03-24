#!/bin/bash

## kill全部jar程序

jps |grep -v Jps| awk  '{print $1}' |xargs kill -9
