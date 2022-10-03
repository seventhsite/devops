#!/bin/bash

set -e

# Get hostname
read -p "Please, enter server address to connect: " srvaddress

# Get ssh username
while true; do
    read -p "Do you want to connect with user \"$USER\"? Y/n: " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) read -p "Please, enter ssh username: " sshusername ; break;;
        * ) break;;
    esac
done

# Generate ssh username@hostname
[[ -n "$sshusername" ]] && userhost=$sshusername@$srvaddress || userhost=$srvaddress

# Connect and execute
ssh "$userhost" -t "sudo apt update && sudo apt -y upgrade && sudo apt dist-upgrade && sudo apt -y install mc tmux zabbix-agent gnupg2 curl"

echo "Done!"
