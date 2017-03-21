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
				
		target_dir=$(echo "$1" | sed -r 's/(\\)* /\\ /g')
			
		project_name_escaped=$(echo "$2" | sed -r 's/(\\)* /\\ /g') #Work out the spaces in the dir		
		project_name="$2"
		
		images_dir=$(echo "$3" | sed -r 's/(\\)* /\\ /g')
		
		PROJECT_TARGET_PATH="$target_dir/$project_name_escaped"
		
		#No spaces allowed for the project name since it will be on one of the tags
		if [ "$project_name_escaped" != "$2" ]; then
			echo -e "\n>>Error: No spaces allowed for the project name, it'll be in one TeX tag and can't use it, please use other character as underscore.\n\n"
			exit 1
		fi
		
		if [ -z "$4" ]; then			
			if [ -d "$PROJECT_TARGET_PATH" ]; then #If project dir already exists
				echo -e "\nAlready exists a folder with this project name and not overwrite allowed... Stoping process\n"
				exit 1 #No overwrite allowed, terminate script							
			fi
		else
		echo "------------rm -r $PROJECT_TARGET_PATH--------------"
			if [ "$4" == "overwrite" ]; then #Confirm wan'ts overwrite if already exists a same name folder
				if [ -d "$PROJECT_TARGET_PATH" ]; then #If project dir already exists
					echo "Overwriting same project name folder..."					
					eval "rm -r $PROJECT_TARGET_PATH"	
				fi
			else
				echo -e "\n>>Error: $4 is not a correct parameter, should be nothing or \"overwrite\", type command without params to see help\n\n"
				exit 1 #No a correct 4th param
			fi # if correct param overwrite written
		fi # if $4 param	
		
		echo "Renaming step images and folders..."
		eval "./filenames_char_replace.sh \"$images_dir\" \" \" \"_\"" #Using change space by underscore, since it's the most usal
		
		echo "Generating TeX formats..."
		eval "./step_report_gen.py \"$images_dir\" p1_content" #Using fixed output file name, to reduce params
		
		echo "Making a copy of the tex_report_base..."
		eval "cp -r tex_report_base \"$project_name_escaped\""
		
		echo "Passing Tex formats to the Tex structure..."
		eval "cat p1_content > \"$project_name_escaped\"/desarrollo.tex"
				
		echo "Putting name to the TeX project..."
		eval "cd \"$project_name_escaped\"/"
		eval "sed -ri 's/(\\documentclass\[12pt\]\{)(.*)(\})/\1$project_name\3/' main.tex"
		cd ..
		eval "mv \"$project_name_escaped\"/main.tex \"$project_name_escaped\"/\"$project_name.tex\""
		eval "mv \"$project_name_escaped\"/main.cls \"$project_name_escaped\"/\"$project_name.cls\""		
		
		echo "Copying the images to the project folder..."
		eval "cp -r \"$images_dir\" \"$project_name_escaped\""
		
		echo "Moving project to the target directory..."
		eval "mv \"$project_name_escaped/\" \"$target_dir\""		
		
		echo "Cleaning..."	
		rm p1_content
				
	else
		echo -e "\n>>Error: $target_dir or $images_dir are not a valid directory name or path\nShould be absolute or relative directory path\n\n"
	fi	
fi
