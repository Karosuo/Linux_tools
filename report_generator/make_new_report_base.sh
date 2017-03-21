#!/bin/bash
#	Takes 3 parameters, new report's target directory, new report's name, images folder container path
#~ 		If the project's folder already exists it stops, except if last param is specified as "overwrite"
#	
#		Example:
#			make_new_report_base.sh target_dir new_project images_folder_container
#~ 				Where target_dir will be the new project's folder container
#~ 				the new_project name will be the directory project's name and the main *.tex files
#~ 				and the images_folder will be the path of the container of the image step lists 
#
#		By Rafael Karosuo, UABC March 2017

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then #No parameters
	echo -e "\n>>Error: Need at least 3 parameters, new report's target directory, new report's name, images folder container path, last param indicates if you want to overwrite an existing folder with the same name as the project\n\nUsage: $0 <target_directory_path> <new_report_name> <images_folder> [\"overwrite\"]\n\n"
else
	if [ -d "$1" ] && [ -d "$3" ]; then #Check if correct dirs, target and images
		
		echo "Checking if already exists a folder with same project name..."
		if [ -z "$4" ]; then
			if [ -d "\'$1\'/\'$2\'" ]; then #If project dir already exists
				echo -e "\nAlready exists a folder with this project name and not overwrite allowed... Stoping process\n"
				exit 1 #No overwrite allowed, terminate script							
			fi
		else
			if [ "$4" == "overwrite" ]; then #Confirm wan'ts overwrite if already exists a same name folder
				if [ -d "\'$1\'/\'$2\'" ]; then #If project dir already exists
					echo "Overwriting same project name folder..."
					eval "rm -r \'$1\'/\'$2\'"	
				fi
			else
				echo -e "\n>>Error: $4 is not a correct parameter, should be nothing or \"overwrite\", type command without params to see help\n\n"
				exit 1 #No a correct 4th param
			fi # if correct param overwrite written
		fi # if $4 param	
		
		echo "Renaming step images and folders..."
		eval "./filenames_char_replace.sh \'$3\' \" \" \"_\"" #Using change space by underscore, since it's the most usal
		
		echo "Generating TeX formats..."
		eval "./step_report_gen.py \'$3\' p1_content" #Using fixed output file name, to reduce params
		
		echo "Making a copy of the tex_report_base..."
		eval "cp -r tex_report_base $2"
		
		echo "Passing Tex formats to the Tex structure..."
		eval "cat p1_content > \'$2\'/desarrollo.tex"
		
		echo "Putting name to the TeX project..."
		eval "sed -ri 's/(\\documentclass\[12pt\]\{)(.*)(\})/\1$2\3/' main.tex"
		eval "mv \'$2\'/main.tex \'$2\'/\'$2.tex\'"
		eval "mv \'$2\'/main.cls \'$2\'/\'$2.cls\'"		
		
		echo "Moving project to the target directory..."
		eval "mv \'$2\' \'$1\'"		
		
		echo "Cleaning..."	
		rm p1_content
				
	else
		echo -e "\n>>Error: $1 or $3 are not a valid directory name or path\nShould be absolute or relative directory path\n\n"
	fi	
fi
