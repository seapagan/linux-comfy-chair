#!/usr/bin/env bash

# specific handling if we are in Ubuntu WSL instead of a standard linux
# system ...we install a meta-package for Ubuntu after first checking we are
# definately using Ubuntu.

# ...
distro=`cat /etc/*-release | grep DISTRIB_ID | awk -F= '{print $2}'`
if [ "$distro" == "Ubuntu" ]; then
  sudo apt install -y ubuntu-wsl
fi
