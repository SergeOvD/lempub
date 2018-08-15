#!/bin/bash

echo "###################################################################################"
echo "Please be Patient: Installation will start now..."
echo "###################################################################################"

#Update
sudo apt-get update

#Nginx
sudo apt-get -y install nginx
sudo ufw allow 'Nginx Full'
sed -i 's/14/30/g' /etc/logrotate.d/nginx

#Php
sudo apt-get -y install php-fpm php-mysql php7.0-xml php-curl
sed -i 's/;cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/g' /etc/php/7.0/fpm/php.ini