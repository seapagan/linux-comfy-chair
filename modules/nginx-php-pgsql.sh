#!/usr/bin/env bash
# nginx-php.sh
# install the Nginx webbrowser, php7.4-fpm and Postgresql database

# we already installed all the required ppa's etc in the packages/updates so
# lets just install

sudo apt install -y nginx php7.4-fpm postgresql-12

# now some common PHP extensions ...
sudo apt install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc \
                    php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev \
                    php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap \
                    php7.4-zip php7.4-intl php7.4-pgsql php7.4-json
