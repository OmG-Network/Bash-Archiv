#!/bin/bash

##
## First install for Ubuntu Servers
##

# Update
apt update && apt upgrade -y

# Install monitor Software
apt install wget git curl htop iftop python-pip -y

# Updating PiP
pip install -U pip && pip install speedtest-cli

# Flushing SSH Keys

rm /etc/ssh/ssh_host*
dpkg-reconfigure openssh-server 

# Change SSH Port
sed -i s/Port\ 22/Port\ 567/g /etc/ssh/sshd_config
/etc/init.d/ssh restart

exit 0