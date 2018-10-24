# updates.sh
# ensure we have the latest packages, including git and sublime text repos

sudo add-apt-repository ppa:git-core/ppa -y
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt -y full-upgrade
