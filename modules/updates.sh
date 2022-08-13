#!/usr/bin/env bash
# updates.sh
# ensure we have the latest packages, including git and sublime text repos

# Later versions of Ubuntu server dont have the full sources.list for apt which restricts us
# a bit so we need to add them.
# Before pushing to live we need to confirm they are actually missing...
#sudo sed -i 's/$/ restricted universe multiverse/' /etc/apt/sources.list

# update the package index just in case...
sudo apt update

# some minimal versions of Ubuntu lack these...
sudo apt-get install -y dialog apt-utils software-properties-common curl wget \
                        ca-certificates gnupg gnupg-agent apt-transport-https \
                        bash-completion cmake pkg-config iputils-ping lsb-release


# Add some third-party PPA repos to give us more recent versions of assorted
# software...

# add the latest Git repo...
sudo add-apt-repository ppa:git-core/ppa -y

# add updated php repo ...
sudo add-apt-repository ppa:ondrej/php -y

# add updated Nginx repo, also contains some useful updated libraries ...
sudo add-apt-repository ppa:ondrej/nginx -y

# add Postgresql repo so we can get latest versions if needed...
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# add the official Docker repo so we can install recent versions if needed...
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# update then upgrade...
sudo apt update
sudo apt -y full-upgrade
