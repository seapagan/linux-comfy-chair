#!/usr/bin/env bash
# cleanup.sh
# any last tidy and config changes to be done

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cp $THISPATH/support/.gitconfig ~/.gitconfig
fi
