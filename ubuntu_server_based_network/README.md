# Ubuntu server 16.04 based network configuration scripts
The idea is to have separated each service on a diferent directory and make a main script that joins them in a transparent installation.
The installation includes basic configuration but it's arbitrary, so the original config files are provided also.

##NOTE, CURRENT STATE OF SAMBA/CUPS PRINTER SERVER AND PDC (WITH OR WITHOUT LDAP) ARE UNCOMPLETE
Samba configuration about CUPS isn't correct so no user access control is implemented.
You can add printers as (everybody in the net has access), and samba is just half the way configured with the cups users integration.

##LDAP configuration and SAMBA integration is in the using_ldap, take care that it is mutually exlusive configuration with respect of the rest of the samba/cups/ubuntu config files.

Many of the scripts, are half the way through, all the steps are described in them but some are not implemented, so you'll need to read the scripts first to see if it's complete or not and if you'll need to do some steps by hand (ideally, implement them on the script and make a pull request)

All the scripts were based on the Ubuntu Server 2016 guide, Open LDAP guide, Samba main documentation and BIND project.
Plus some blogs that stated some of the errors that the guides could have, in the wiki section I added a report of all this work and it's bibliography, wich is just a pdf compilation of the tex code in the report directory.

