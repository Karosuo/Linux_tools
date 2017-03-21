#!/bin/bash
#	Takes 3 parameters, new report's target directory, new report's name, images folder container path
#~ 		If the project's folder already exists it deletes it
#	
#		Example:
#			make_new_report_base.sh target_dir new_project images_folder_container
#~ 				Where target_dir will be the new project's folder container
#~ 				the new_project name will be the directory project's name and the main *.tex files
#~ 				and the images_folder will be the path of the container of the image step lists 
#
#		By Rafael Karosuo, UABC March 2017

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then #No parameters
	echo -e "\n>>Error: Need 3 parameters, new report's target directory, new report's name, images folder container path\n\nUsage: $0 <target_directory_path> <new_report_name> <images_folder>\n\n"
else
	if [ -d "$1" ] && [ -d "$3" ]; then #Check if correct dirs
		tmp="$2" #temp var, since string cut can't be done with params
		old_char="${tmp:0:1}" #Get first char of old and new chars
		tmp="$3"
		new_char="${tmp:0:1}"								
		script_path=$(eval 'pwd') #Get current script's dir
		
		echo "Renaming first level (dirs and files)"
		eval "find '$1' -maxdepth 1 -iname \"*$old_char*\" | rename 's/$old_char/$new_char/g'"
		
		all_dirs=$(eval "find '$1' -type d") #get all dirs, including $1 itself
		#~ Solution by jordanm in http://stackoverflow.com/questions/11746071/how-to-split-a-multi-line-string-containing-the-characters-n-into-an-array-of		
		arr=()
		while read -r line; do
			arr+=("$line")
		done <<< "$all_dirs"
		
		echo "Renaming sublevels"		
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
