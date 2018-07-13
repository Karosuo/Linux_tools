sudo /sbin/ifconfig wlo1 up
sudo /sbin/iwlist wlo1 scan
sudo /sbin/iwconfig wlo1 essid "INFINITUM73d3"
sudo /sbin/iwconfig wlo1 key 3732343131
sudo /sbin/iwconfig wlo1 enc on

#Check with
sudo /sbin/iwconfig wlo1
#Start dhclient disvoery
sudo dhclient wlo1

#Up the interface
#sudo /sbin/ifconfig wlo1 up
