#!/usr/bin/env bash
# extras.sh
# extra additions not in the main install script

# install 'zoxide' tool (this is a faster 'z' tool)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
if ! grep -qc 'zoxide init' ~/.bashrc ; then
  echo >> ~/.bashrc
  echo "# Set up 'zoxide' (jump around)" >> ~/.bashrc
  echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

# install 'fzf' tool (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# install 'lazygit' tool
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit

# install 'lazydocker' tool
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# install 'bat' tool (cat clone with syntax highlighting)
BAT_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo bat.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-musl_${BAT_VERSION}_amd64.deb"
sudo apt install ./bat.deb
rm ./bat.deb

# install 'ripgrep' tool (grep clone with better performance)
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "(\K[^"]*)')
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}-1_amd64.deb"
sudo dpkg -i ripgrep.deb
rm ./ripgrep.deb

# install 'fd' tool (find clone with better performance)
FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo fd.deb "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-musl_${FD_VERSION}_amd64.deb"
sudo dpkg -i fd.deb
rm ./fd.deb

# install 'direnv' tool (environment switcher)
curl -sfL https://direnv.net/install.sh | bash
if ! grep -qc 'direnv hook bash' ~/.bashrc ; then
  echo >> ~/.bashrc
  echo "# Set up 'direnv' (environment switcher)" >> ~/.bashrc
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
fi
