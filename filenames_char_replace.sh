#!/bin/bash
#	Takes 3 parameters, directory where the files will be affected, old character and last is new character
#		All the files within that dir will replace the $2 character by the $3 character
#	
#		Example:
#			filenames_char_replace my_test_dir ' ' '_' #Replace all spaces by underscores
#			content 1.1.png -> content_1.1.png
#
#		By Rafael Karosuo, UABC March 2017

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then #No parameters
	echo -e "\n>>Error: Need 3 parameters, directory path where all filenames will be affected, old character to replace, new character that will replace the old one. (change spaces by underscores)\n\nUsage: $0 <directory_path> <old_char> <new_char>\n\n"
else
	if [ -d "$1" ]; then #Check if it's directory
		tmp="$2" #temp var, since string cut can't be done with params
		old_char="${tmp:0:1}" #Get first char of old and new chars
		tmp="$3"
		new_char="${tmp:0:1}"								
		script_path=$(eval 'pwd') #Get current script's dir
		
		echo "Renaming first level (dirs and files) changing \"$2\" by \"$3\""
		eval "find '$1' -maxdepth 1 -iname \"*$old_char*\" | rename 's/$old_char/$new_char/g'"
		
		all_dirs=$(eval "find '$1' -type d") #get all dirs, including $1 itself
		#~ Solution by jordanm in http://stackoverflow.com/questions/11746071/how-to-split-a-multi-line-string-containing-the-characters-n-into-an-array-of		
		arr=()
		while read -r line; do
			arr+=("$line")
		done <<< "$all_dirs"
		
		echo "Renaming sublevels, changing \"$2\" by \"$3\""		
		for c_dir in "${arr[@]}"
		do			
			eval "find '$c_dir' -maxdepth 1 -iname \"*$old_char*\" | rename 's/$old_char/$new_char/g'"
			echo -e "\t$c_dir"
		done
		
		#~ eval "find '$1' -maxdepth 1 -iname \"*$old_char*\" | rename 's/$old_char/$new_char/g'"
		
	else
		echo -e "\n>>Error: $1 is not a valid directory name or path\nShould be absolute or relative directory path\n\n"
	fi	
fi
