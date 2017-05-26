#!/bin/bash

#Check internet access

sudo apt-get -y install samba libpam-winbind #Install samba to have a file,printer and AD server and libpam to sync user db paswd to the samba user db

#~ Modify /etc/samba/smb.conf with appropiate values
#~ workgroup = str.edu #Change str.edu to appropiate domain
#~ ...
#~ security = user


#The shared directory segment permits
#	browsable (appears in the neighborhood in windows or smbshared)
#	anyone could access (guest ok)
#	anyone can write new files, but only read and execute the files from others
#	also added the sticky bit so no other user than the one that create the file can delete it


#create the samba shared directory
sudo mkdir -p /srv/samba/share #p=create entire tree if not exist
sudo chmod +s /srv/samba/share #use sticky bit, instead of chown nobody:nogroup

#restart samba service
sudo systemctl restart smbd.service nmbd.service


###Enable printer service share

##Ensure the following in [printers]
#~ browsable = yes
#~ guest ok = yes

#~ restart samba
sudo systemctl restart smbd.service nmbd.service


###Adding user security to the file and printer shares
#
#

###Enabling the AD DC behavior
#As the smb.conf was edited only adding domain logons = yes, and uncommented the following parts
	#~ NOTE: Don't copy these options, better find the equivalence on the current version smb.conf installed with the samba package
#~ domain logons = yes
#~ logon path = \\%N\%U\profile
#~ logon drive = H:
#~ logon home = \\%N\%U
#~ logon script = logon.cmd
#~ add machine script = sudo /usr/sbin/useradd -N -g machines -c Machine -d /var/lib/samba -s /bin/false %u
# We need to create the machines group
sudo addgroup machines #Add the machines group to enable the machine append to the domain
sudo mkdir -p /srv/samba/netlogon #Create the logon directory
sudo touch /srv/samba/netlogon/logon.cmd #Create an empty logon.cmd file, changes the time in the file, but as it wasn't created, it creates one
sudo systemctl restart smbd.service nmbd.service #Restart samba services
sudo adduser sysadmin #The net admin that will be mapped to a user in the WinNT "Domain Admins" group
						#Each user has a group with same name, so sysadmin group will be the "Domain Admins" equivalent
sudo addgroup admin #Compatiblity sudo group
sudo adduser sysadmin admin #Add sysadmin to the machine sudoers (backward compatible)
sudo adduser sysadmin sudo #Adding sysadmin to the machine sudoers (current versions)
							#sysadmin user will be the one that joins the machines to the domain, so needs sudo privileges
sudo net groupmap add ntgroup="Domain Admins" unixgroup=sysadmin rid=512 type=d #Map the sysadmin group with the Domain Admins of WinNT
																				#type=d indicates "domain" group type and rid is an identifier unique in the domain
sudo smbpasswd -a sysadmin #Add sysadmin user to samba DB
#~ eval "sudo adduser $(whoami) admin" #Add current user to admin group to be able to copy the smb.conf file to /etc/samba/
#~ eval "sudo deluser $(whoami) admin" #Remove current user from admin group
