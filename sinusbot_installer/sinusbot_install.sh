#!/bin/bash

##
##   Sinusbot Installer
##  Cloudflare Optimized
##

if [ $(whoami) = 'root' ]; then
    echo "Bitte nicht als root ausführen"
  exit 1
fi

echo "Wie viele bots sollen erstellt werden ?"
read BOT

if [[ ! $BOT =~ ^-?[0-9]+$ ]]; then
        echo "Bitte nur ganze Zahlen angeben"
    exit 1
fi

echo "Speicherort wählen"
read path

SBURL="https://www.sinusbot.com/dl/sinusbot-beta.tar.bz2"
TSURL="http://dl.4players.de/ts/releases/3.0.19.4/TeamSpeak3-Client-linux_amd64-3.0.19.4.run"
SBCONF="http://fastdl.omg-network.de/cdn/sinusbot/config.ini"

# Create TMP Folder
mkdir -P $path/tmp/sb

# Download

wget -P $path/tmp/sb $SBURL
wget -P $path/tmp $TSURL

# Prepare Sinusbot
cd $path/tmp/sb/
tar -xjvf $path/tmp/sb/*.tar.bz2
rm $path/tmp/sb/*.tar.bz2
wget -P $path/tmp/sb $SBCONF

# Prepare TS Client
chmod +x $path/tmp/*.run
$path/tmp/*.run --quiet --target $path/tmp/client/

for ((i=1; i<BOT; i++))
do
mkdir $path/Sbot$i
cp -r $path/tmp/sb/* $path/Sbot$i && cp $path/tmp/sb/* $path/Sbot$i
cp -r $path/tmp/client/ $path/Sbot$i/
cp $path/Sbot$i/plugin/libsoundbot_plugin.so $path/Sbot$i/client/plugins
sed 's/%TSPATH%/\$path\/\Sbot$i\/\client\/\ts3client_linux_amd64/g' $path/tmp/sb/config.ini > $path/Sbot$i/config.ini
sed 's/%DATADIR%/\$path\/\Sbot$i\/\data\/\/g' $path/tmp/sb/config.ini > $path/Sbot$i/config.ini 
chmod +x $path/Sbot$i/sinusbot
done

exit 0
