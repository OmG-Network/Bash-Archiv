#!/bin/bash

## Vultr Cloud CSGO Server Deploy post INST
## 2018-01-24

# Game Settings

export GAME_TYPE=Diegel
export hostname="[OmG] Network DEV Server"
export sv_password=""
export rcon_password=""
export sv_setsteamaccount=""

# Download options

export metamod="https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git961-linux.tar.gz"
export sourcemod="https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6040-linux.tar.gz"
export esl_cfg="http://fastdl.omg-network.de/csgo/esl.tar"

# Install options

export steamCMD=/opt/steamcmd
export server_inst_dir=/opt/server
export install_user_name=csgo
export retry=5

export LSB=$(/usr/bin/lsb_release -i | awk '{ print $3 }')

# Start Script

curl -sql https://raw.githubusercontent.com/OmG-Network/Bash-Archiv/master/cloud_deploy/csgo_deploy/vultr/csgo_cloud_vultr.sh | bash &


exit 0
