#!/bin/bash

# tar -zcf 123.tar.gz -C /usr/log/backend . -C /usr/log/nginx .
# args
pathFrom=$1
pathTo=$2

files=()

function start {
  if [ ${#pathFrom} != 0 ] && [ ${#pathTo} != 0 ] 
  then
    # tar -zcf $pathTo -C $pathFrom ./
    text=$(backupList.txt)
    echo $text
  else
    echo "error"
  fi
}

start