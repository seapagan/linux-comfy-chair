#!/usr/bin/env bash
# updates.sh

flavour=$1
echo "OS Flavour is $flavour"

# ensure we have the latest packages, including git and sublime text repos
export DEBIAN_FRONTEND=noninteractive
# update the package index just in case...
sudo apt update

# some minimal versions of Ubuntu lack these...
sudo DEBIAN_FRONTEND=noninteractive apt install -y dialog apt-utils \
                        software-properties-common curl wget \
                        ca-certificates gnupg gnupg-agent apt-transport-https \
                        bash-completion cmake pkg-config iputils-ping lsb-release


# Add some third-party PPA repos to give us more recent versions of assorted
# software...
if [[ $flavour =~ "ubuntu" ]]; then
  # add the latest Git repo...
  sudo add-apt-repository ppa:git-core/ppa -y
  # add updated php repo ...
  sudo add-apt-repository ppa:ondrej/php -y
  # add updated Nginx repo, also contains some useful updated libraries ...
  sudo add-apt-repository ppa:ondrej/nginx -y
else
  # debian can't use the Ubuntu PPA's
  curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
  echo \
    "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ \
    $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
  curl -sSLo /usr/share/keyrings/deb.sury.org-nginx.gpg https://packages.sury.org/nginx/apt.gpg
  echo \
    "deb [signed-by=/usr/share/keyrings/deb.sury.org-nginx.gpg] https://packages.sury.org/nginx/ \
    $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx.list
fi

# Create the keyring folder if doesn't alredy exist.
sudo mkdir -p /etc/apt/keyrings

# add Postgresql repo so we can get latest versions if needed...
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/keyrings/postgresql.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt  \
  $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# add the official Docker repo so we can install recent versions if needed...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$flavour \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# update then upgrade...
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt -y full-upgrade
