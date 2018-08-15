#!/bin/bash

echo "#################################################"
echo "Please be Patient: Installation will start now..."
echo "#################################################"

#Update
sudo ufw allow OpenSSH
sudo ufw --force enable
sudo apt-get update

#Nginx
sudo apt-get -y install nginx
sudo ufw allow 'Nginx Full'
sed -i 's/14/30/g' /etc/logrotate.d/nginx

cat << 'eof' >> /etc/nginx/sites-available/default

server {
	listen 80;
	listen [::]:80;

	server_name exampledomain.com www.exampledomain.com;

	root /var/www/exampledomain.com;
	index index.php index.html index.htm index.nginx-debian.html;

	location / {
		try_files $uri $uri/ =404;
	}
	
	  location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
eof

sudo systemctl reload nginx

#Php
sudo apt-get -y install php-fpm php-mysql php7.0-xml php-curl
sed -i 's/;cgi.fix_pathinfo=0/	cgi.fix_pathinfo=1/g' /etc/php/7.0/fpm/php.ini
sudo systemctl restart php7.0-fpm

#Letsencrypt certbot
yes n | sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install python-certbot-nginx

read -p "Enter Domain Name: "  domainname
sed -i "s/exampledomain.com/$domainname/g" /etc/nginx/sites-available/default
sudo systemctl reload nginx

mkdir ../var/www/$domainname/
chown -R www-data:www-data ../var/www/$domainname/

sudo certbot --nginx -d $domainname -d www.$domainname

echo "#################################################"
echo "############### Server is Ready #################"
echo "#################################################"

