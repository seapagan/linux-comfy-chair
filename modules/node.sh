# node.sh
# Install nvm, the latest LTS version of Node and the latest actual version of Node..

echo "## Setting up NVM (Node Version Manager) ##"
echo >> ~/.bashrc
echo "# Set up NVM" >> ~/.bashrc
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
nvm install node
nvm use --lts
