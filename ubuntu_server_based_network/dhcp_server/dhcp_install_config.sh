#!/bin/bash

#Check if internet available

sudo apt-get -y install isc-dhcp-server

#Edit the /etc/dhcp/dhcpd.conf, copy the formatted one
sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf #copy preformated configuration
sudo cp ./dhcpd.conf.sample /etc/dhcp/ #copy the original as template reference
sudo cp ./isc-dhcp-server /etc/default/ #copy the file that will state which interfaces will be served


sudo systemctl restart isc-dhcp-server.service #Restart dhcp daemon
