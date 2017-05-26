
#~ **********Server****************
find /home -group test #See files owned by "test" group

cut -d: -f1 /etc/passwd #Other way to list unix users 
getent passwd # list unix users in server
echo "user:passwd" | chpasswd #Reset unix user passwd in one line
last #show last logged in users
id #show current logged user and groups for the user
sudo systemctl restart smbd.service nmbd.service #Restart samba services
sudo service smbd status #Check status of samba daemon
sudo smbstatus #Report on current samba connections, try man for further info
sudo pdbedit -L -v #show all samba users
sudo smbstatus --shares #Only list shares
initctl list #lists all the starting proceses
sudo cat /etc/group #Samba groups are mapped over the ubuntu ones

#Mount a smb share
mount -t  smbfs -o username=<username> //<servername>/<sharename> /mnt/point/

lpadmin -p lp0 -E -v file:///dev/null #add a dummy printer
lpstat -t #Check printers available

lpadmin -p danka_infotec -u deny:uwe,danimo,root #deny users in cups
lpadmin -p danka_infotec -u allow:kurt,chris,michael  #allow users


sudo tail /var/lib/dhcp/dhcpd.leases #Check DHCP lease



#~ **********Client****************
smbclient -L ubuntu-server.str.edu
