#!/usr/bin/env bash
# these will run as the default non-privileged user.

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo "We are running from : $THISPATH"

# make sure we have Git installed already...
if [ ! $(which git) ]; then
  echo "Git is not installed, can't continue."
  exit 1
fi

# source in the configuration file..
. $THISPATH/comfy.config

# run the individual modules. This will be changed to read from an array of
# modules..
. $THISPATH/modules/updates.sh
. $THISPATH/modules/packages.sh
. $THISPATH/modules/ruby.sh
. $THISPATH/modules/node.sh
. $THISPATH/modules/python.sh
. $THISPATH/modules/perl.sh
. $THISPATH/modules/qemu-kvm.sh
. $THISPATH/modules/cleanup.sh

echo
echo "You now need to reboot this system for all the new changes to take affect."
