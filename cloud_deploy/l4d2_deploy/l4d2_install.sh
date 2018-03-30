#!/bin/bash

## Silent L4D2 Server installer
## 2018-03-01

# Game Server options
hostname=""
sv_password=""
rcon_password=""
sv_setsteamaccount=""
steam_apikey=""

# FastDL Upload Portal Settings
fastdl_user=fastdl
fastdl_passwd=fastdl
php_max_upload=2048

# Install options
steamCMD=/opt/steamcmd
server_inst_dir=/opt/server
install_user_name=l4d2
retry=5

LSB=$(/usr/bin/lsb_release -i | awk '{ print $3 }')
WAN_IP=$(curl ipinfo.io/ip)
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
    # Install Req via APT
    apt install -y curl debconf libc6 lib32gcc1 screen curl wget apache2 php libapache2-mod-php
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
    apt-get autoclean -y

}

function inst_vanilla_l4d2_srv ()
{
    tmp_dir="$(su $install_user_name --shell /bin/sh -c "mktemp -d")"
    # Download CSGO Server
    echo "### DOWNLOADING L4D2 Server ###"
    su $install_user_name --shell /bin/sh -c "$steamCMD/steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir $tmp_dir/ +app_update 222860 validate +quit" > $tmp_dir/log
    # Check install status
    if [[ $(cat $tmp_dir/log) = *"Success! App '222860' fully installed."* ]] ; then
        echo "L4D2 Download success"
    else
        rm -rf $tmp_dir
        echo "L4D2 Download failed retry..."
         COUNTER=$((COUNTER +1))
             if [ $retry == $COUNTER ]; then
               echo "L4D2 Download failed after $retry attempts exiting..."
            exit 1
             fi 
       inst_vanilla_l4d2_srv
    fi
    # Move Folder
    mv $tmp_dir/* $server_inst_dir
    # Clean up
    rm -rf $tmp_dir
}

function init_fastdl ()
{
    # Create fastdl dir
    if [ ! -d /var/www/fastdl ]; then
        mkdir /var/www/fastdl
    fi
    if [ ! -d /var/www/fastdl/upload ]; then
        mkdir /var/www/fastdl/upload
    fi
    # Create fastdl apache2 config file
    if [ -a /etc/apache2/sites-available/fastdl.conf ]; then
        a2dissite fastdl.conf
        rm /etc/apache2/sites-available/fastdl.conf
    fi
    echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/fastdl.conf
    echo "        ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/fastdl.conf
    echo "        DocumentRoot /var/www/fastdl" >> /etc/apache2/sites-available/fastdl.conf
    echo "        LogLevel info" >> /etc/apache2/sites-available/fastdl.conf
    echo "        <Directory /var/www/fastdl>" >> /etc/apache2/sites-available/fastdl.conf
    echo "                Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/fastdl.conf
    echo "                AllowOverride All" >> /etc/apache2/sites-available/fastdl.conf
    echo "                Order allow,deny" >> /etc/apache2/sites-available/fastdl.conf
    echo "                allow from all" >> /etc/apache2/sites-available/fastdl.conf
    echo "        </Directory>" >> /etc/apache2/sites-available/fastdl.conf
    echo "        ErrorLog "'${APACHE_LOG_DIR}'"/fastdl_error.log" >> /etc/apache2/sites-available/fastdl.conf
    echo "        CustomLog "'${APACHE_LOG_DIR}'"/fastdl_access.log combined" >> /etc/apache2/sites-available/fastdl.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/fastdl.conf
    # Create .htaccess file
    echo "AuthType Basic" >> /var/www/fastdl/upload/.htaccess
    echo "AuthUserFile /etc/apache2/.passwd" >> /var/www/fastdl/upload/.htaccess
    echo "AuthName "fastdl"" >> /var/www/fastdl/upload/.htaccess
    echo "order deny,allow" >> /var/www/fastdl/upload/.htaccess
    echo "allow from all" >> /var/www/fastdl/upload/.htaccess
    echo "require valid-user" >> /var/www/fastdl/upload/.htaccess
    echo "" >> /var/www/fastdl/upload/.htaccess
    echo "php_value  upload_max_filesize ${php_max_upload}M" >> /var/www/fastdl/upload/.htaccess
    echo "php_value post_max_size ${php_max_upload}M" >> /var/www/fastdl/upload/.htaccess

    # Deactivate Default apache2 conf
    a2dissite 000-default.conf
    # Activate fastdl apache2 conf
    a2ensite fastdl
    # Restart apache2 server
    /etc/init.d/apache2 restart
    # Create fastdl user with password
    htpasswd -cbB /etc/apache2/.passwd $fastdl_user $fastdl_passwd

    # Create Upload PHP
    wget -P /var/www/fastdl/upload/ "https://raw.githubusercontent.com/OmG-Network/Bash-Archiv/master/cloud_deploy/csgo_deploy/dependencies/index.php"
    sed -i "s/{MAP_FOLDER_PATH}/${server_inst_dir//\//\\/}\/left4dead2\/maps\//g" /var/www/fastdl/upload/index.php

    # Link Map folder
    if [ ! -d /var/www/fastdl/l4d2 ]; then
        mkdir /var/www/fastdl/l4d2
    fi    
    ln -s $server_inst_dir/left4dead2/maps/ /var/www/fastdl/l4d2/maps
    ln -s $server_inst_dir/left4dead2/materials/ /var/www/fastdl/l4d2/materials
    ln -s $server_inst_dir/left4dead2/models/ /var/www/fastdl/l4d2/models
    ln -s $server_inst_dir/left4dead2/sound/ /var/www/fastdl/l4d2/sound   
}

function l4d2_srv_init ()
{
    echo "### UPDATE Server CFG ###"
    if [ -a $server_inst_dir/left4dead2/cfg/server.cfg ]; then
        rm $server_inst_dir/left4dead2/cfg/server.cfg
    fi
    echo // Base Configuration >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo hostname $hostname >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_password $sv_password >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo rcon_password "$rcon_password" >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo  >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo // Network Configuration >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_downloadurl '"'"http://$WAN_IP/l4d2/"'"' >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_allowdownload 0 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_allowupload 0 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo net_maxfilesize 64 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_setsteamaccount $sv_setsteamaccount >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo  >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_maxrate 0 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_minrate 196608 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_maxcmdrate 128 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_mincmdrate 128 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_maxupdaterate 128 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_minupdaterate 128 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo  >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo // Logging Configuration >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo log on >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_logbans 0 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_logecho 0 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_logfile 1 >> $server_inst_dir/left4dead2/cfg/server.cfg
    echo sv_log_onefile 0 >> $server_inst_dir/left4dead2/cfg/server.cfg

}

function l4d2_start ()
{
    # Set permissions
    echo "### SET Permissions for $install_user_name"
    chown -cR $install_user_name:www-data $server_inst_dir && chmod -cR 775 $server_inst_dir
    chmod +x $server_inst_dir/srcds_run
    # Starting L4D2 Server
    echo "### STARTING L4D2 Server ###"
    screen -dmS l4d2 su $install_user_name --shell /bin/sh -c "$server_inst_dir/srcds_run -game left4dead2 -console -usercon -tickrate 128 -maxplayers 10 -nobots -pingboost 3 -ip 0.0.0.0 +exec server.cfg"
}


############################################## End of Functions ##############################################

# Main Starts here....
# Call Functions
check_root
check_distro
inst_req
inst_vanilla_l4d2_srv
init_fastdl
l4d2_srv_init
l4d2_start
exit 0
