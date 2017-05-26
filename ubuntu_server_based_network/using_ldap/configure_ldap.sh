#sshfs pi@192.168.1.65:/home/pi /home/karosuo/Documents/UABC/2016-2/Checo/Fermentadora de pan/plotter/remote_pi/


###The user structure in the LDIF file should be something like this, instead of the offered by the guide
#~ dn: uid=john,ou=People,dc=str,dc=edu
#~ objectClass: inetOrgPerson
#~ objectClass: shadowAccount
#~ cn: John Doe
#~ uid: john
#~ sn: Doe
#~ givenName: John Doe
#~ displayName: John Doe
#~ userPassword: johnldap

###Changing the logLevel, should follow the table bellow
#~ http://www.openldap.org/doc/admin24/slapdconf2.html
#~ dn: cn=config
#~ changetype: modify
#~ replace olcLogLevel
#~ olcLogLevel: 256


###To generate certificates, to enable encrypted auth
#Fill and follow the chapt. 1.8 TLS from SLAP server on Ubuntu Server 2016 Admin guide
#~ sudo apt install gnutls-bin ssl-cert
#~ sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"

