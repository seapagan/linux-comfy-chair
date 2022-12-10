#!/usr/bin/env bash
# docker.sh
# install docker and docker-compose

echo ""
echo "---------------------------------------------------------------"
echo "| Installing Docker and Compose.                              |"
echo "---------------------------------------------------------------"
echo ""

# DONT DO ANY OF THIS IN WSL (Windows Subsystem for Linux)!
if [ ! $os = "wsl" ]; then
  # docker. We no longer use the old V1 of docker compose, we install v2.
  sudo DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  # remove the need for sudo...
  sudo usermod -aG docker $USER
else
  echo
  echo " -<[ Skipping Docker in WSL ]>- "
  echo
fi
