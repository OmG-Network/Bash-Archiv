#!/bin/bash

## Silent CSGO Server installer
## 2018-01-22

# VARS sort by priority
GAME_TYPE=      # 1vs1 / Diegel / MM (Competitive)
steamCMD=/opt/steamcmd
server_inst_dir=/opt/server
install_user_name=csgo
retry=5

metamod="https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git961-linux.tar.gz"
sourcemod="https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6040-linux.tar.gz"
esl_cfg="http://fastdl.omg-network.de/csgo/esl.tar"

LSB=$(/usr/bin/lsb_release -i | awk '{ print $3 }')

############################################## Start of Script ##############################################
function check_root ()
{
 if [ ! $(whoami) == "root" ]; then
        echo "Start as root an try again"
        exit 1
fi
}

function check_distro ()
{
    if [ -x /usr/bin/lsb_release ]; then
        if [ !$LSB == "Ubuntu" ] || [ !$LSB == "Debian" ]; then
          echo "Your distro isn´t supported"
         exit 1
        fi
    else
        echo "Your distro isn´t supported."
        exit 1
    fi
}

function inst_req ()
{
    # System Update
apt update && apt upgrade -y
    # Add x86 Arch
dpkg --add-architecture i386
    # Install Req via APT
apt install -y curl debconf libc6 libstdc++6 libstdc++6:i386 libc6:i386 lib32gcc1
    # Create User
    if [ ! -d $server_inst_dir ]; then
        mkdir $server_inst_dir
    fi
    if [[ ! $(getent passwd $install_user_name) = *"$install_user_name"* ]]; then
        useradd $install_user_name -d $server_inst_dir --shell /usr/sbin/nologin
    fi
    # Download SteamCMD
 if [ -d $steamCMD ]; then
         curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C $steamCMD >/dev/null 2>&1
    else
        mkdir $steamCMD
        curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C $steamCMD >/dev/null 2>&1
 fi
    # Set User rights
    chown -cR $install_user_name $steamCMD && chmod -cR 770 $install_user_name $steamCMD
    # Clean up
apt-get autoclean

}

function inst_vanilla_cs_srv ()
{
    tmp_dir="$(su $install_user_name --shell /bin/sh -c "mktemp -d")"
    # Download CSGO Server
    echo "### DOWNLOADING CSGO Server ###"
    su $install_user_name --shell /bin/sh -c "$steamCMD/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir $tmp_dir/ +app_update 740 validate +quit" > $tmp_dir/log
    # Check install status
    if [[ $(cat $tmp_dir/log) = *"Success! App '740' fully installed."* ]] ; then
        echo "CSGO Download success"
    else
        rm -rf $tmp_dir
        echo "CSGO Download failed retry..."
         COUNTER=$((COUNTER +1))
             if [ $retry == $COUNTER ]; then
               echo "CSGO Download failed after $retry attempts exiting..."
            exit 1
             fi 
       inst_vanilla_cs_srv
    fi
    # Move Folder
    mv $tmp_dir/* $server_inst_dir
    # Clean up
    rm -rf $tmp_dir
}

function csgo_srv_init ()
{
# Inst Metamod & Sourcemod
# Metamod
echo "### INST Metamod ###"
curl -sqL $metamod | tar zxvf - -C $server_inst_dir/csgo/
# Sourcemod
echo "### INST Sourcemod ###"
curl -sqL $sourcemod | tar zxvf - -C $server_inst_dir/csgo/
# Update Config
# Create Server CFG
echo "### UPDATE Server CFG ###"
if [ -a $server_inst_dir/csgo/cfg/server.cfg ]; then
    rm $server_inst_dir/csgo/cfg/server.cfg
fi
echo // Base Configuration >> $server_inst_dir/csgo/cfg/server.cfg
echo hostname "[OmG] Network" >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_password "" >> $server_inst_dir/csgo/cfg/server.cfg
echo rcon_password "" >> $server_inst_dir/csgo/cfg/server.cfg
echo  >> $server_inst_dir/csgo/cfg/server.cfg
echo // Network Configuration >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_loadingurl "https://aimb0t.husos.wtf" >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_downloadurl "http://fastdl.omg-network.de/csgo/csgo/" >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_allowdownload 0 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_allowupload 0 >> $server_inst_dir/csgo/cfg/server.cfg
echo net_maxfilesize 64 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_setsteamaccount  >> $server_inst_dir/csgo/cfg/server.cfg
echo  >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_maxrate 0 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_minrate 196608 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_maxcmdrate 128 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_mincmdrate 128 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_maxupdaterate 128 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_minupdaterate 128 >> $server_inst_dir/csgo/cfg/server.cfg
echo  >> $server_inst_dir/csgo/cfg/server.cfg
echo // Logging Configuration >> $server_inst_dir/csgo/cfg/server.cfg
echo log on >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_logbans 0 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_logecho 0 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_logfile 1 >> $server_inst_dir/csgo/cfg/server.cfg
echo sv_log_onefile 0 >> $server_inst_dir/csgo/cfg/server.cfg

# Add ESL Config files
echo "### ADD ESL Config ###"
curl -sqL $esl_cfg | tar xf - -C $server_inst_dir/csgo/cfg/
}

function csgo_1vs1 ()
{

}

function csgo_diegel ()
{

}

function csgo_mm ()
{

}
############################################## End of Functions ##############################################

# Main Starts here....
# Call Functions
check_root
check_distro
inst_req
inst_vanilla_cs_srv
csgo_srv_init

    if [ "$GAME_TYPE" == "1vs1" ]; then
        csgo_1vs1
fi
    if [ "$GAME_TYPE" == "Diegel" ]; then
        csgo_diegel
fi
    if [ "$GAME_TYPE" == "MM" ]; then
        csgo_mm
else
    echo "ERROR: Wrong GAME_TYPE exiting..."
    exit 1
fi


exit 0
