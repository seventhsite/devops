#! /bin/bash

# Get hostname
read -p "Please, enter server address to connect: " srvaddress
read -p "Please, enter hostname: " hname


# Connect and execute
ssh "$srvaddress" -t " \
sudo apt update \
&& sudo apt full-upgrade \
&& sudo sed -i -e 's/# Hostname=/Hostname=$hname/g' /etc/zabbix/zabbix_agentd.conf \
&& sudo systemctl restart zabbix-agent \
&& sudo systemctl status zabbix-agent "

echo "Done!"
