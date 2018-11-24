#!/usr/bin/env bash
# sublime.sh
# set up Sublime Text with Package control and a useful selection of default packages.
# You can edit the list of pre-installed packages in the file `./support/Package\ Control.sublime-settings`
# These packages will be installed when subl is first run

sudo apt install sublime-text

mkdir -p ~/.config/sublime-text-3/Installed\ Packages
mkdir -p ~/.config/sublime-text-3/Packages/User
mkdir -p ~/.config/sublime-text-3/Local
curl -o ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
cp $THISPATH/support/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User
# install the sublime license if it is found...
if [ -f "$THISPATH/support/License.sublime_license" ] ; then
  cp $THISPATH/support/License.sublime_license ~/.config/sublime-text-3/Local
fi
# it would also be very useful to pre-configure some Subl default settings at this time
# TODO
