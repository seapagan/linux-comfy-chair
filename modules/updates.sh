#!/usr/bin/env bash
# updates.sh

flavour=$1
echo "OS Flavour is $flavour"

# ensure we have the latest packages, including git and sublime text repos
export DEBIAN_FRONTEND=noninteractive
# update the package index just in case...
sudo apt update

# some minimal versions of Ubuntu lack these...
echo ""
echo "---------------------------------------------------------------"
echo "| Installing some packages that are often missing, but needed |"
echo "| for the next step.                                          |"
echo "---------------------------------------------------------------"
echo ""
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
  sudo curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
  echo \
    "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ \
    $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list > /dev/null
  sudo curl -sSLo /usr/share/keyrings/deb.sury.org-nginx.gpg https://packages.sury.org/nginx/apt.gpg
  echo \
    "deb [signed-by=/usr/share/keyrings/deb.sury.org-nginx.gpg] https://packages.sury.org/nginx/ \
    $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null
fi

# Create the keyring folder if doesn't alredy exist.
sudo mkdir -p /etc/apt/keyrings

# add Postgresql repo so we can get latest versions if needed...
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/keyrings/postgresql.gpg
sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt  \
  $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

# add the official Docker repo so we can install recent versions if needed...
curl -fsSL https://download.docker.com/linux/$flavour/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$flavour \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# add the GitHub CLI repo so we can install recent versions if needed...
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \

# update then upgrade...
echo ""
echo "---------------------------------------------------------------"
echo "| Updating all the currently installed Packages.              |"
echo "---------------------------------------------------------------"
echo ""
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt -y full-upgrade
