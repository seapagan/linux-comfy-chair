#!/usr/bin/env bash
# these will run as the default non-privileged user.

# set a version number
VERSION="1.0.0"

# lets see if we are running under WSL (Windows Sunsystem for Linux)
read osrelease </proc/sys/kernel/osrelease
if [[ $osrelease =~ "WSL" ]]; then
  os="wsl"
else
  os="linux"
fi

echo "Linux Comfy Chair v $VERSION (c) Grant Ramsay (seapagan@gmail.com)"
if [ $os = "wsl" ]; then
  echo " - Running under the 'Windows Subsystem for Linux (WSL)"
fi

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo
echo "We are running from : $THISPATH"
echo

# make sure we have Git and sudo installed already. Some very minimal images
# will not have these (eg the standard Ubuntu Docker image)
if [ ! $(which git) ] || [ ! $(which sudo) ]; then
  echo "Git or/and Sudo are not installed, please install these and restart."
  exit 1
fi

# source in the configuration file..
. $THISPATH/comfy.config

# run the individual modules. This will be changed to read from an array of
# modules..
. $THISPATH/modules/updates.sh
. $THISPATH/modules/packages.sh

# WSL Specific work
if [ $os = "wsl" ]; then
  . $THISPATH/modules/wsl.sh
fi

# . $THISPATH/modules/nginx-php-pgsql.sh
# . $THISPATH/modules/docker.sh
. $THISPATH/modules/ruby.sh
. $THISPATH/modules/node.sh
. $THISPATH/modules/python.sh
. $THISPATH/modules/perl.sh
#. $THISPATH/modules/qemu-kvm.sh
. $THISPATH/modules/cleanup.sh

echo
echo "You now need to reboot this system for all the new changes to take affect."
