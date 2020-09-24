#!/bin/bash

# args
pathFrom=$1
pathTo=$2

files=()

function fileMapping {
  for file in $1/*
  do
    if [ -d "$file" ]
    then
      fileMapping $file
    else
      files[${#files[@]}]=$file
      echo $file
    fi
  done
}

function start {
  if [ ${#pathFrom} != 0 ] && [ ${#pathTo} != 0 ] 
  then
    fileMapping $pathFrom
  else
    echo "error"
  fi
}

start