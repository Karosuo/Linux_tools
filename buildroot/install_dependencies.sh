#!/bin/bash
#
#	Ensures that all the needed dependencies for buildroot to work properly are in the system
#	As the apt-get is idempotence, I will try to install everything, if it's already there, will just go ahead

#	By Rafael Karosuo, Jul 2017

function check_internet_conn()
{
	wget --spider -q http://www.google.com #Check if there's connection
	if [ $? -eq 0 ]; then
		return 1; #C int boolean convention
	else
		return 0;
	fi
}

if [ -z "$1" ]; then #Check if first parameter is there
	echo -e "\n>>Error: Need one parameter, the filepath with filename with the list of dependencies to be checked\n\nUsage: $0 <file_name>\n\nIf file isn't in the same folder as script, use full absolute path\nThe file dependencies should follow the format: \"- package_name\\\n\"\n\n"
else
	if [ -f "$1" ]; then
		check_internet_conn
		if [ $? -eq 1 ];then #If internet connection, then continue
			echo -e "\nCorrect internet connection...\n"
			#~ Based on example in https://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable
			#~ By Jeff Puckett
			#~ -r prevents backslash escapes from being interpreted.
			#~ || [[ -n "$line" ]] prevents the last line from being ignored if it doesn't end with a \n (since read returns a non-zero exit code when it encounters EOF).
			installed_dependencies=$(<"$1")
			echo -e "\n***************\nThe following dependencies will be checked and if they doesn't exist they'll be installed using apt-get\n$installed_dependencies\n"
			echo -e "\nRemember that the package will be taken as the word without spaces after the hyphen+space a the beginning of each line and until an space or end of line is found\n"
			while read -r line || [[ -n "$line" ]]; do
				package_name=$(echo "$line" | cut -d" " -f2) #Separate the one work package name				
				echo -e "\nExecuting...\n\tsudo apt-get --assume-yes install $package_name\n"
				eval "sudo apt-get --assume-yes install $package_name"
			done < "$1"
			

		#~ sudo apt-get --assume-yes install 
		else #if not, advise and close
			echo -e "\n>>Error: No internet connection\n"
		fi
	else
		echo -e "\n>>Error: $1 is not a file\n"
	fi #end if $1 is file
fi #end check initial parameters
