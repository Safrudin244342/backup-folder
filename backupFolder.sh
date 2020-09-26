#!/bin/bash

# panduan

# kompres singel folder autoBackup -s folder-tujuan fordel-kompress
# kompres multi folder autoBackup -m file-conf

# file-conf
# folder-tujuan>folder-kompres

# pastikan ada satu baris kosong paling bawah

IFS=' '
read -a args <<< $@

pathsFrom=()
pathsTo=()

startActions=()
mainActions=()
endAction=()

files=()

function arrayJoin {
  newCmd=""

  IFS=' '
  read -a arrayCmd <<< $cmd
  for ((i=1; i < ${#arrayCmd[@]}; i++))
  do
    newCmd="$newCmd ${arrayCmd[$i]}"
  done

  cmd=$newCmd
}

function fileMapping {
  baseDirectory=$1
  for file in $baseDirectory/*; do
    if [ -d "$file" ]; then
      fileMapping $file
    else
      files[${#files[@]}]=$file
    fi
  done
}

function removeFile {
  fileMapping
  
  for ((i=0; i < ${#files[@]}; i++)); do
    rm ${files[$i]}
  done
}

function readConfig {
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
  fi
}

function makeListAction {
  filename=$1

  while IFS= read -r line
  do
    IFS=' '
    read -a subAction <<< "$line"
    cmd=${line[@]}
    arrayJoin
    if [ "${subAction[0]}" = "start" ]
    then
      startActions[${#startActions[@]}]=$cmd
    elif [ "${subAction[0]}" = "end" ]
    then
      endActions[${#endActions[@]}]=$cmd
    fi
  done < $filename
}

function execAction {
  listAction=()

  # add start action
  if [ ${#startActions[@]} != 1 ]
  then 
    for ((i=0; i < ${#startActions[@]}; i++))
    do
      listAction[${#listAction[@]}]=${startActions[$i]}
    done
  else
    listAction[${#listAction[@]}]=${startActions[0]}
  fi

  # add main action
  if [ ${#mainActions[@]} != 1 ]
  then 
    for ((i=0; i < ${#mainActions[@]}; i++))
    do
      listAction[${#listAction[@]}]=${mainActions[$i]}
    done
  else
    listAction[${#listAction[@]}]=${mainActions[0]}
  fi

  # add end action
  if [ ${#endActions[@]} != 1 ]
  then 
    for ((i=0; i < ${#endActions[@]}; i++))
    do
      listAction[${#listAction[@]}]=${endActions[$i]}
    done
  else
    listAction[${#listAction[@]}]=${endActions[0]}
  fi

  # exec all action
  if [ ${#listAction[@]} != 1 ]
  then 
    for ((i=0; i < ${#listAction[@]}; i++))
    do
      eval ${listAction[$i]}
    done
  else
    eval ${listAction[0]}
  fi
}

function start {
  if [ "${args[0]}" = "-s" ]
  then
    cmd="compressFolder ${args[1]} ${args[2]}"
    mainActions[${#mainActions[@]}]=$cmd
    
    if [ "${args[3]}" = "-a" ] 
    then 
      makeListAction ${args[4]}
    fi

    execAction
  elif [ "${args[0]}" = "-m" ]
  then
    readConfig ${args[1]}
    
    for (( i=0; i < ${#pathsFrom[@]}; i++ ))
    do
      cmd="compressFolder ${pathsFrom[$i]} ${pathsTo[$i]}"
      mainActions[${#mainActions[@]}]=$cmd
    done
    
    if [ "${args[2]}" = "-a" ] 
    then 
      makeListAction ${args[3]}
    fi

    execAction
  fi
}

start