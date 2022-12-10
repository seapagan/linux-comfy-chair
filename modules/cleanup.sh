#!/usr/bin/env bash
# cleanup.sh
# any last tidy and config changes to be done

echo ""
echo "---------------------------------------------------------------"
echo "| Performing Clean-up tasks.                                  |"
echo "---------------------------------------------------------------"
echo ""

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cat $THISPATH/support/.gitconfig >> ~/.gitconfig
fi
