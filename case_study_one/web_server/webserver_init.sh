#!/bin/bash
apt-get update
apt-get -y install net-tools nginx
MYIP=$(hostname -I | awk '{print $1}')
echo "Hello Team! This is my IP: $MYIP" > /var/www/html/index.html
