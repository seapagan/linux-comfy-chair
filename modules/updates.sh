#!/usr/bin/env bash
# updates.sh
# ensure we have the latest packages, including git and sublime text repos

# Later versions of Ubuntu server dont have the full sources.list for apt which restricts us
# a bit so we need to add them.
# Before pushing to live we need to confirm they are actually missing...
#sudo sed -i 's/$/ restricted universe multiverse/' /etc/apt/sources.list

# some minimal versions of Ubuntu lack these...
sudo apt-get install software-properties-common curl ca-certificates gnupg -y

# Add some third-party PPA repos to give us more recent versions of assorted software...
# add the latest Git repo...
sudo add-apt-repository ppa:git-core/ppa -y
# add updated php repo ...
sudo add-apt-repository ppa:ondrej/php -y
# add updated Nginx repo, also contains some useful updated libraries ...
sudo add-apt-repository ppa:ondrej/nginx -y
# add Postgresql repo so we can get latest versions if needed.
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# update then upgrade...
sudo apt update
sudo apt -y full-upgrade
