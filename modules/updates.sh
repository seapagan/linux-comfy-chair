#!/usr/bin/env bash
# updates.sh
# ensure we have the latest packages, including git and sublime text repos

# Later versions of Ubuntu server dont have the full sources.list for apt which restricts us
# a bit so we need to add them.
# Before pushing to live we need to confirm they are actually missing...
#sudo sed -i 's/$/ restricted universe multiverse/' /etc/apt/sources.list

sudo add-apt-repository ppa:git-core/ppa -y
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt -y full-upgrade
