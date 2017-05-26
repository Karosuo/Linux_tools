#!/bin/bash
	#~ Install and configures the client to be able to connect to samba, get data from dns server, dhcp server and copy it's profile to/from the server
#Check if there's internet connection

##Install tools to check the dns server
sudo apt-get -y install dnsutils whois

##Check if connection to server is correctly done
#~ ping <server_FQDN>

#Install samba and samba client
sudo apt-get -y install samba smbclient

#Install ntpdate
sudo apt-get -y install ntpdate


#Install kerberos modules
sudo apt-get -y install krb5-config krb5-user

#Install winbind and pam
sudo apt-get -y install winbind libpam-winbind libnss-winbind


#Check that ntpdate can query the domain
sudo ntpdate -q str.edu

#Sync time in domain server
sudo ntpdate str.edu
