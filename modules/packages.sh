#!/usr/bin/env bash
# packages.sh
# make sure we have the required libraries and tools already installed before starting.

# now install some important libraries for the next stages...
sudo apt install -y build-essential curl gettext libssl-dev libreadline-dev \
                    zlib1g-dev sqlite3 libsqlite3-dev libbz2-dev \
                    libxml2-dev libdb-dev ccache libffi-dev libpg-dev

# install winbind and its support lib to ping WINS hosts
sudo apt install -y winbind libnss-winbind
# need to append to the /etc/nsswitch.conf file to enable if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi
