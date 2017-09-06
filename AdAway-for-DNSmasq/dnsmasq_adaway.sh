#!/bin/bash

###
### AdAway host Blocker
###     2017-04-09
###       Markus
###

# TMP Folder
dir=/tmp/dns_hosts

# Hosts Dateien
host1=%Direct Link to Hosts File%
host2=%Direct Link to Hosts File%

# TMP Folder Check
if [ ! -d $dir ]; then

mkdir $dir

fi

# Ad File Check / Download
if [ -e $dir/hosts1 ] || [ -e $dir/hosts2 ]; then

rm $dir/*

wget -O $dir/hosts1 --no-check-certificate $host1 > /dev/null 2>&1
wget -O $dir/hosts2 --no-check-certificate $host2 > /dev/null 2>&1

else

wget -P $dir/hosts1 --no-check-certificate $host1 > /dev/null 2>&1
wget -P $dir/hosts2 --no-check-certificate $host2 > /dev/null 2>&1

fi

# Host Dateien Zusammenfügen
cat $dir/hosts1 >> $dir/hosts
cat $dir/hosts2 >> $dir/hosts

# IPv4 zu IPv6
sed s/127.0.0.1/::1/g $dir/hosts > $dir/hosts6

# Hosts Datei leeren
> /etc/hosts

# Doppelte einträge löschen alle anderen werden in Hosts Datei geschrieben
sort -u $dir/hosts > /etc/hosts
sort -u $dir/hosts6 | cat >> /etc/hosts

# Restart DNSMASQ
/etc/init.d/dnsmasq restart > /dev/null 2>&1

exit 0
