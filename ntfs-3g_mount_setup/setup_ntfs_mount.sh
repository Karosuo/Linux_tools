#!/bin/bash
#Setup ubuntu ntfs-3g's to be able to edit ntfs on windows 10, this is focus to use in a bootable usb
#ntfs-3g supports the windows compression after version 2016.22.2AR.1 which is available since ubuntu 17.04 (zesty), but if you add the package repository and update
#it will be installed without troubles in older versions of ubuntu
#~ 
#~ 	Takes one parameter, which is the device that will be mounted using ntfs-3g
#~ 		Example:
#~ 			setup_ntfs_mount.sh "/dev/sda3"
#~
#~ 	Check this for possible errors solutions
#~		http://www.tuxera.com/community/ntfs-3g-faq/#ioerror 
#~ 
#~ 		By Rafael Karosuo rafaelkarosuo@gmail.com UABC, Apr 2017

function check_internet_conn()
{
	wget --spider http://www.google.com #Check if there's connection
	if [ $? -eq 0 ]; then
		return 1; #C int boolean convention
	else
		return 0;
	fi
}

if [ -z "$1" ]; then #Check if first parameter is there
	echo -e "\n>>Error: Need one parameter, the name of the device which will be mounted with ntfs-3g\n\nUsage: $0 <Name_of_the_device>\n\n"
else
	if [ -e "$1" ]; then #Check if device exists
		check_internet_conn	#call function to check internet
		if [ $? -eq 1 ]; then
			##Add the last repo reference
			sudo apt-get remove ntfs-3g
			sudo vi /etc/apt/sources.list +$'i\ndeb http://ubuntu.cs.utah.edu/ubuntu zesty main\n' +w +q
			sudo apt-get update

			##Install ntfs-3g, should be the last version
			sudo apt-get install ntfs-3g

			##Add to fstab and mount the device
			sudo mkdir /mnt/windows
			current_user=$(whoami)
			sudo vi /etc/fstab +$'i\n$1 /mnt/windows ntfs-3g uid=$current_name,gid=users,umask=0000 0 0\n' +w +q
			sudo mount -a #Re-read fstab
		else
			echo -e "\n>>Error: No internet connection available\n\n"
		fi		
	else
		echo -e "\n>>Error: $1 isn't a valid device name, should be something like /dev/sda3\n\n"
	fi
	
fi 


