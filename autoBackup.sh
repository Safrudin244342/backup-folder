#!/bin/bash

# tar -zcf 123.tar.gz -C /usr/log/backend . -C /usr/log/nginx .
# args
IFS=' '
read -a args <<< $@

files=()

function readFile {
  filename=$1
  while IFS= read -r line
  do
    IFS='>'
    read -a paths <<< "$line"
    for path in "${paths[@]}"
    do
      echo $path
    done
  done < "$filename"
}

function compressFolder {
  pathFrom=$1
  pathTo=$2

  if [ ${#pathFrom} != 0 ] && [ ${#pathTo} != 0 ] 
  then
    tar -zcf "$pathTo" -C "$pathFrom" .
  else
    echo "error"
  fi
}

function start {
  if [ "${args[0]}" = "-s" ]
  then
    compressFolder ${args[1]} ${args[2]}
  elif [ "${args[0]}" = "-m" ]
  then
    echo "multi operation"
  else
    echo "error"
  fi
}

start