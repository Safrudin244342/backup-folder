#!/bin/bash

# tar -zcf 123.tar.gz -C /usr/log/backend . -C /usr/log/nginx .
# args
IFS=' '
read -a args <<< $@

pathsFrom=()
pathsTo=()

function readFile {
  filename=$1
  while IFS= read -r line
  do
    IFS='>'
    read -a paths <<< "$line"
    pathsFrom[${#pathsFrom[@]}]=${paths[0]}
    pathsTo[${#pathsTo[@]}]=${paths[1]}
  done < "$filename"
}

function compressFolder {
  pathFrom=$1
  pathTo=$2

  if [ ${#pathFrom} != 0 ] && [ ${#pathTo} != 0 ] 
  then
    tar -zcf "$pathTo/$(date +%m-%d-%y).tar.gz" -C "$pathFrom" .
  else
    echo "error"
  fi
}

function start {
  if [ "${args[0]}" = "-s" ]
  then
    compressFolder ${args[1]} "${args[2]}"
  elif [ "${args[0]}" = "-m" ]
  then
    readFile ${args[1]}
    for (( i=0; i < ${#pathsFrom[@]}; i++ ))
    do
      compressFolder "${pathsFrom[$i]}" "${pathsTo[$i]}"
      echo "task $i from ${#pathsFrom[@]} done"
    done
  else
    echo "error"
  fi
}

start