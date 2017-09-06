#!/bin/bash

#############################
###     Whitelist DE      ###
###      2017-04-22       ###
### markus@omg-network.de ###
#############################

# Benutzer Einstellungen

port=22 # Port der Anwendung eintragen

protokoll=tcp # Protokoll der Anwendung eintragen

zone1=http://www.ipdeny.com/ipblocks/data/countries/de.zone # Deutschland
zone2=http://www.ipdeny.com/ipblocks/data/countries/at.zone # Österreich
zone3=http://www.ipdeny.com/ipblocks/data/countries/ch.zone # Schweiz
zone4=http://www.ipdeny.com/ipblocks/data/countries/lu.zone # Luxembourg
zone5=http://www.ipdeny.com/ipblocks/data/countries/li.zone # Lichtenstein

dir=/tmp/ipdeny

# Root Check

if [ ! $(whoami) = "root" ]; then
    echo "Bitte als root starten"
    exit 1
fi

# Erstelle Ordner oder Lösche alte Dateien

if [ -d $dir ]; then
    rm -rf $dir/*
  else
    mkdir -p $dir
fi

# Download Zone Dateien

   wget -P $dir $zone1 > /dev/null 2>&1
   wget -P $dir $zone2 > /dev/null 2>&1
   wget -P $dir $zone3 > /dev/null 2>&1
   wget -P $dir $zone4 > /dev/null 2>&1
   wget -P $dir $zone5 > /dev/null 2>&1

# Alle Dateien aneinaderhängen

  cat $dir/de.zone $dir/at.zone $dir/ch.zone $dir/lu.zone $dir/li.zone >> $dir/all.zone
    sed 's/^/iptables -A INPUT -p '$protokoll' --dport '$port' -s /' $dir/all.zone | sed 's/$/ -j ACCEPT/' > $dir/iptables.sh
  echo "iptables -A INPUT -p $protokoll --dport $port -j DROP" >> $dir/iptables.sh


# Änderungen anwenden

 # Firewall zurücksetzen

  iptables -F
    echo "Firewall wurde Resettet"
  $dir/iptables.sh &
    echo "Neue Einstellungene werden geladen dies dauert eine weile..."
exit 0
