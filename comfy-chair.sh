#!/usr/bin/env bash
# these will run as the default non-privileged user.

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo "We are running from : $THISPATH"

# source in the configuration file..
. comfy.config

# run the individual modules. This will be changed to read from an array of
# modules..
. modules/updates.sh
. modules/packages.sh
. modules/ruby.sh
. modules/node.sh
. modules/python.sh
. modules/perl.sh
. modules/qemu-kvm.sh
. modules/sublime.sh
. modules/cleanup.sh

echo
echo "You now need to reboot this system for all the new changes to take affect."
