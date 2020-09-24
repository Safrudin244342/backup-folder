#!/bin/bash

# args
pathFrom=$1
pathTo=$2

files=()

function getAllFile {
  for file in "/usr"/*
  do
    files[${#files[@]}]=$file
  done
}

function start {
  if [ ${#pathFrom} != 0 ] && [ ${#pathTo} != 0 ] 
  then
    echo "run"
  else
    echo "error"
  fi
}

start