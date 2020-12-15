#!/usr/bin/env bash
# node.sh
# Install nvm, the latest LTS version of Node and the latest actual version of Node..

echo "## Setting up NVM (Node Version Manager) ##"
echo >> ~/.bashrc
echo "# Set up NVM" >> ~/.bashrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion # This loads nvm bash_completion

nvm install --lts
nvm install node
nvm use --lts
