#!/usr/bin/env bash
# node.sh
# Install nvm, the latest LTS version of Node and the latest actual version of Node..

echo ""
echo "---------------------------------------------------------------"
echo "| Installing Latest Node and the LTS (default).               |"
echo "---------------------------------------------------------------"
echo ""

echo "## Setting up NVM (Node Version Manager) ##"
echo >> "$shell_rc"
echo "# Set up NVM" >> "$shell_rc"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[[ -r $NVM_DIR/bash_completion ]] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# set up some default packages to always install - these 2 allow the use of a
# '.node-version' file which will choose the version of node to make default on
# a per-directory basis
# echo $'avn\navn-nvm\n' > ~/.nvm/default-packages

# install the latest LTS version of node and make it the default. We also
# install the latest non-LTS version of node which will be available for use
nvm install --lts
nvm install node
nvm use --lts

# load the avn shim
# [[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"
