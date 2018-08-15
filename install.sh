#!/bin/sh -e

echo "###################################################################################"
echo "Please be Patient: Installation will start now..."
echo "###################################################################################"

cat << 'eof' >> /etc/nginx/sites-available/default
server {
	listen 80;
	listen [::]:80;

	server_name example.com www.example.com;

	root /var/www/c;
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
