#!/bin/bash

if [ -z "$1" -o -z "$2" ]; then
 echo -e "\nusage: $0 <source list file> <destiny list file>\n"
 echo -e "\tsource list file: File with a new line separated list of source paths"
 echo -e "\tdestiny list file: File with a new line separated list of destiny paths"
 echo -e "\n"
else
 while read destiny #Read destiny list
 do

  while read source #Read source list
  do
   echo "---------Action: rsync -aHAXvz $source $destiny"
   #rsync $line $2 > ActionLog 2> errLog
  done<"$1"

 done<"$2"

fi
