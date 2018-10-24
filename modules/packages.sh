# packages.sh
# make sure we have the required libraries and tools already installed before starting.

sudo apt install -y build-essential curl gettext libssl-dev libreadline-dev /
                    zlib1g-dev sqlite3 libsqlite3-dev libgtk2.0-0 libbz2-dev /
                    libxml2-dev libdb-dev gedit ccache libffi-dev

# install winbind and support lib to ping WINS hosts
sudo apt install -y winbind libnss-winbind
# need to append to the /etc/nsswitch.conf file to enable if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi
