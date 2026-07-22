#!/usr/bin/env bash
# nginx-php.sh
# install the Nginx webbrowser, php8.5-fpm and Postgresql database,
# plus php8.5 itself. we already installed all the required ppa's etc in the
# packages/updates so lets just install

echo
echo "---------------------------------------------------------------"
echo "| Installing Nginx and Postgresql.                            |"
echo "---------------------------------------------------------------"
echo

sudo DEBIAN_FRONTEND=noninteractive apt install -y nginx nginx-extras php8.5-fpm postgresql-18

# install php version 8.1
sudo DEBIAN_FRONTEND=noninteractive apt install -y php8.5 php8.5-cli

# now some common PHP extensions ...
# sudo DEBIAN_FRONTEND=noninteractive apt install -y php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc \
#                     php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev \
#                     php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap \
#                     php7.4-zip php7.4-intl php7.4-pgsql php7.4-json

# their php 8.5 equivalents ...
sudo DEBIAN_FRONTEND=noninteractive apt install -y php8.5-common php8.5-mysql php8.5-xml php8.5-xmlrpc \
  php8.5-curl php8.5-gd php8.5-imagick php8.5-cli php8.5-dev \
  php8.5-imap php8.5-mbstring php8.5-soap \
  php8.5-zip php8.5-intl php8.5-pgsql

# make sure we are using 8.1 by default
sudo update-alternatives --set php /usr/bin/php8.5
