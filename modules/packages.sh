#!/usr/bin/env bash
# packages.sh
# make sure we have the required libraries and tools already installed before starting.

echo ""
echo "---------------------------------------------------------------"
echo "| Installing More packages that will be needed later.         |"
echo "---------------------------------------------------------------"
echo ""

# now install some important libraries for the next stages...
sudo DEBIAN_FRONTEND=noninteractive apt install -y build-essential gettext \
                    libssl-dev libreadline-dev zlib1g-dev sqlite3 \
                    libsqlite3-dev libbz2-dev libxml2-dev libdb-dev ccache \
                    libffi-dev libpq-dev mcrypt liblzma-dev lzma \
                    libncurses5-dev xz-utils libxmlsec1-dev tk-dev llvm \
                    libicu-dev libcurl4-openssl-dev checkinstall libyaml-dev \
                    terminator lld gh clang nfs-common

# install some 'nice to have' that are missing from very mininal images...
sudo DEBIAN_FRONTEND=noninteractive apt install -y nano htop openssh-server openssh-client

# install winbind and its support lib to ping WINS hosts
sudo DEBIAN_FRONTEND=noninteractive apt install -y winbind libnss-winbind
# need to append to the /etc/nsswitch.conf file to enable if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi
