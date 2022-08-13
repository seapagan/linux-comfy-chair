#!/usr/bin/env bash
# nginx-php.sh
# install the Nginx webbrowser, php7.4-fpm and Postgresql database

# we already installed all the required ppa's etc in the packages/updates so
# lets just install
sudo apt install -y nginx nginx-extras php7.4-fpm postgresql-14

# also install php version 8.1
sudo apt install -y php8.1 php8.1-fpm php8.1-cli

# now some common PHP extensions ...
sudo apt install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc \
                    php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev \
                    php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap \
                    php7.4-zip php7.4-intl php7.4-pgsql php7.4-json

# their php 8.1 equivalents ...
sudo apt install -y php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc \
                    php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev \
                    php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap \
                    php8.1-zip php8.1-intl php8.1-pgsql

# make sure we are using 7.4 cli by default though for now.
sudo update-alternatives --set php /usr/bin/php7.4
