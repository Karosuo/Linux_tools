#!/bin/bash
		#~ Install and basic config of CUPS
		#~ it's just a wrapper script of the steps presented in the Ubuntu Server Guide 2016
		#~ by Rafael Karosuo

#Check error logs on
#~ /var/log/cups/error_log
#Check config on
#~ /etc/cups/cupsd.conf

sudo apt-get update #Update repositories
sudo apt-get -y install cups #Install cups
sudo cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.original #Backup conf file
sudo chmod a-w /etc/cups/cupsd.conf.original #Take away write premissions from everyone, so this is just a ref file
sudo cp ./cupsd.conf /etc/cups/cupsd.conf #Copy the modified file
sudo systemctl restart cups.service #Restart CUPS services
eval "sudo usermod -aG lpadmin $(whoami)" #Append the current user to the lpadmin group, to admin printer server
