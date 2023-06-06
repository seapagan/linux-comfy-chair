#!/usr/bin/env bash
# extras.sh
# extra additions not in the main install script

# install 'z' tool (https://github.com/rupa/z)
\curl https://raw.githubusercontent.com/rupa/z/master/z.sh ~/.z.sh
chmod +x ~/.z.sh
# set up the z tool in the shell
if ! grep -qc 'z.sh' ~/.bashrc ; then
  echo >> ~/.bashrc
  echo "# Set up 'z' (jump around)" >> ~/.bashrc
  echo '. ~/z.sh' >> ~/.bashrc
fi


# install 'fzf' tool (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
