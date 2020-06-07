#!/usr/bin/env bash
# docker.sh
# install docker and docker-compose

# docker
sudo apt-get install docker-ce docker-ce-cli containerd.io
# remove the need for sudo...
sudo usermod -aG docker $USER

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
