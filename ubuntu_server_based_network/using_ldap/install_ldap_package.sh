#!/bin/bash
##REFERENCE INSTALLATION SCRIPT

##Ensure that server has 2 net adapters, 1 bridged to get internet access and 1 internal network to enable the VLAN

#	Installs ldap, gives config reference and import config DB
sudo apt-get update
sudo apt-get -y install slapd ldap-utils # y=force yes
sudo vi /etc/hosts ##Add the domain to the host

#If want to reconfigure, don't ommit server config when prompted	
#sudo dpkg-reconfigure slapd

##/usr/local/etc/openldap/slapd.ldif
##slapd.ldif should contain something similar to the example bellow, where <MY-DOMAIN> <COM> should be replaced
##with your data
#~ dn: olcDatabase=mdb,cn=config
#~ objectClass: olcDatabaseConfig
#~ objectClass: olcMdbConfig
#~ olcDatabase: mdb
#~ OlcDbMaxSize: 1073741824
#~ olcSuffix: dc=<MY-DOMAIN>,dc=<COM>
#~ olcRootDN: cn=Manager,dc=<MY-DOMAIN>,dc=<COM>
#~ olcRootPW: secret
#~ olcDbDirectory: /usr/local/var/openldap-data
#~ olcDbIndex: objectClass eq
#~ dn: olcDatabase=mdb,cn=config
#~ objectClass: olcDatabaseConfig
#~ objectClass: olcMdbConfig
#~ olcDatabase: mdb
#~ OlcDbMaxSize: 1073741824
#~ olcSuffix: dc=example,dc=com
#~ olcRootDN: cn=Manager,dc=example,dc=com
#~ olcRootPW: secret
#~ olcDbDirectory: /usr/local/var/openldap-data
#~ olcDbIndex: objectClass eq

##If your domain contains additional components, such as eng.uni.edu.eu, use:
#~ dn: olcDatabase=mdb,cn=config
#~ objectClass: olcDatabaseConfig
#~ objectClass: olcMdbConfig
#~ olcDatabase: mdb
#~ OlcDbMaxSize: 1073741824
#~ olcSuffix: dc=eng,dc=uni,dc=edu,dc=eu
#~ olcRootDN: cn=Manager,dc=eng,dc=uni,dc=edu,dc=eu
#~ olcRootPW: secret
#~ olcDbDirectory: /usr/local/var/openldap-data
#~ olcDbIndex: objectClass eq
