#!/bin/bash

#by Rafael Karosuo (rafaelkarsuo@gmail.com)

#Performs a backup using rsync
	#Parameters are:
	#If the destiny is compressed
	#Source list of paths
	#Destiny list of paths

#It could be multiple directories as source and/or as destiny
#but at least must be one of each

#Options used from rsync:
	#-a: archive
	#-H: maintain hard links
	#-A: preserve ACL's (Access Control Lists)
	#-X: keeps xattrs
	#-v: verbose
	#-z: compress

#Files generated are:
	#actionLog: Show's all the output from rsync
	#errLog: Has any error from rsync
	#timeLog: Has the copy time of each file

if [ "$1" = "--compressed" ]; then
	source="$2"
	destiny="$3"
	params="-aHAXvz"
else
	source="$1"
	destiny="$2"
	params="-aHAXv"
fi

if [ -z "$source" -o -z "$destiny" ]; then
	echo -e "\nusage: $0 [--compressed] <source list file> <destiny list file>\n"
	echo -e "\tsource list file: File with a new line separated list of source paths"
	echo -e "\tdestiny list file: File with a new line separated list of destiny paths"
	echo -e "\n"
else

	while read destinyPath #Read destiny list
	do
		while read sourcePath #Read source list
		do
			actionTitle="---------Action: rsync $params $sourcePath $destinyPath"
			echo -e "\n\n$actionTitle" >> timeLog
			echo -e "\n\n$actionTitle" >> errLog
			(time rsync "$params" "$sourcePath" "$destinyPath" > actionLog 2> errLog) &>> timeLog
		done<"$source"

	done<"$destiny"

fi
