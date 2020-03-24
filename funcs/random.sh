#!/bin/bash

## 生成随机数
function randomRange() {
    ## 起始值(包含)
    local beg=$1
    ## 结束值
    local end=$2
    echo $[$[$RANDOM%$[$end-$beg]]+$beg]
}

function randomSign(){
  str=$1
  size=$2
  if [ -z "${size}" ];
  then
    size="1"
  fi
  local result=""
  
  for((i=1;i<=${size};i++))
  do
   charIndex=`randomRange 0 ${#str}`
   randChar=${str:${charIndex}:1} 
   result="${result}${randChar}"
  done
  echo $result
}

function randomUpperChar(){
  size=$1
  if [ -z "${size}" ];
  then
    size="1"
  fi
  echo `randomSign ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz $size`
}


function randomUpperChar(){
  size=$1
  if [ -z "${size}" ];
  then
    size="1"
  fi
  echo `randomSign ABCDEFGHIJKLMNOPQRSTUVWXYZ $size`
}


function randomLowerChar(){
  size=$1
  if [ -z "${size}" ];
  then
    size="1"
  fi
  echo `randomSign abcdefghijklmnopqrstuvwxyz $size`
}

function randomPassword(){
  size=$1
  if [ -z "${size}" ];
  then
    size="1"
  fi
  str="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~@#$%^&*()[{]}-_=+|;:',<.>/?"  
  echo `randomSign $str $size`
}

