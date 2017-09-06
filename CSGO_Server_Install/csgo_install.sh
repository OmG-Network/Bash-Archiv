#!/bin/bash

##
##		CSGO Install Script
##			2017-04-15
##		markus@omg-network.de
##

##
## Das Script installiert einen CSGO Server
##

# Speicherort Angeben
 echo "Bitte gebe den Speicherort des Servers an"
 read dir
  if [ -d $dir ] || [ -e $dir ]; then
	echo "Der eingegeben Pfad existiert schon möchtest du überschreiben und fortfahren ? Y/N"
	read yn
		if [ $yn == Y ] || [ $yn == y ]; then
			rm -rf $dir
		else
			echo "Vorgang abgebrochen"
			exit 1
		fi
	fi
# Ordner und User anlegen
  mkdir -p $dir >/dev/null 2>&1
  useradd csgo -M -s /bin/false -d $dir >/dev/null 2>&1

# SteamCMD Installieren
	echo "SteamCMD wird installiert beliebige Taste um fortzufahren"
		read taste
		if [ -x /usr/bin/apt-get ]; then
			dpkg --add-architecture i386 >/dev/null 2>&1
			apt-get install -y debconf libc6 libstdc++6 libstdc++6:i386 libc6:i386 >/dev/null 2>&1
			wget -P /tmp/ http://ftp.de.debian.org/debian/pool/non-free/s/steamcmd/steamcmd_0~20130205-1_i386.deb >/dev/null 2>&1
			dpkg -i /tmp/steamcmd_0~20130205-1_i386.deb
		else
			yum install steamcmd
		fi
# CSGO Server mit SteamCMD herunterladen
	if [ -x /usr/games/steamcmd ]; then
		 chgrp -cR csgo $dir >/dev/null 2>&1
		 chmod -cR 770 $dir >/dev/null 2>&1
		su csgo --shell /bin/sh -c "/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir "$dir" +app_update 740 validate +quit" 
	else
		echo "SteamCMD kann nicht gestartet werden"
	exit 1
	fi
		if [ ! -x $dir/srcds_run ]; then
			chmod +x $dir/srcds_run
		fi
# Fertig
  echo "Die Installation ist abgeschlossen"
 exit 0
