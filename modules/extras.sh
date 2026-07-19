#!/usr/bin/env bash
# extras.sh
# extra additions not in the main install script

# get this device arch:
ARCH=$(dpkg --print-architecture)

# install 'zoxide' tool (this is a faster 'z' tool)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
if ! grep -qc 'zoxide init' "$shell_rc" ; then
{
  echo
  echo "# Set up 'zoxide' (jump around)"
  echo "eval \"\$(zoxide init $shell_type)\""
} >> "$shell_rc"

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
curl -Lo bat.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCH}.deb"
sudo apt install ./bat.deb
rm ./bat.deb

# install 'ripgrep' tool (grep clone with better performance)
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "(\K[^"]*)')
curl -Lo ripgrep.deb "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}-1_$ARCH.deb"
sudo dpkg -i ripgrep.deb
rm ./ripgrep.deb

# install 'fd' tool (find clone with better performance)
FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo fd.deb "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-musl_${FD_VERSION}_$ARCH.deb"
sudo dpkg -i fd.deb
rm ./fd.deb

# install bob neovim version manager
cargo binstall bob-nvim --no-confirm
# ensure we can find nvim if installed by bob:
if ! grep -qc 'bob/nvim-bin' "$shell_rc"; then
{
  echo
  echo "# so we can find nvim"
  echo 'export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"'
} >> "$shell_rc"
fi

# install 'lsplus' as an available `ls` replacement
cargo binstall lsplus --no-confirm

# install 'yazi' terminal file manager
cargo binstall yazi-fm --no-confirm
if ! grep -Fqc 'function y()' "$shell_rc"; then
  cat <<'EOF' >> "$shell_rc"

# Set up 'yazi' with directory changing on exit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}
EOF
fi

# install 'atuin' shell history
curl --proto '=https' --tlsv1.2 -LsSf \
  https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh \
  | ATUIN_NO_MODIFY_PATH=1 sh
if ! grep -Fqc '.atuin/bin/env' "$shell_rc"; then
  cat <<'EOF' >> "$shell_rc"

# Add 'atuin' to the path
. "$HOME/.atuin/bin/env"
EOF
fi
if [ "$shell_type" = "bash" ]; then
  curl --proto '=https' --tlsv1.2 -LsSf \
    https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh \
    -o "$HOME/.bash-preexec.sh"
  if ! grep -Fqc '.bash-preexec.sh' "$shell_rc"; then
    cat <<'EOF' >> "$shell_rc"
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
EOF
  fi
fi
if ! grep -Fqc 'atuin init' "$shell_rc"; then
  printf "eval \"\$(atuin init %s --disable-up-arrow)\"\n" "$shell_type" \
    >> "$shell_rc"
fi

# install 'delta' syntax-highlighting pager
DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
curl -Lo git-delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb"
sudo DEBIAN_FRONTEND=noninteractive apt install -y ./git-delta.deb
rm ./git-delta.deb

# install 'hyperfine' command-line benchmarking tool
# Debian reports 32-bit x86 as i386, but hyperfine names its package i686.
if [ "$ARCH" = "i386" ]; then
  HYPERFINE_ARCH="i686"
else
  HYPERFINE_ARCH="$ARCH"
fi
HYPERFINE_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/hyperfine/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo hyperfine.deb "https://github.com/sharkdp/hyperfine/releases/download/v${HYPERFINE_VERSION}/hyperfine_${HYPERFINE_VERSION}_${HYPERFINE_ARCH}.deb"
sudo DEBIAN_FRONTEND=noninteractive apt install -y ./hyperfine.deb
rm ./hyperfine.deb

# install 'xh' HTTP client
curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh

# install 'watchexec' command runner
cargo binstall watchexec-cli --no-confirm

# install `dust` as an alternative to `du`
cargo binstall du-dust --no-confirm

# install 'duf' as an alternative to 'df'
case "$ARCH" in
  amd64|arm64)
    DUF_ARCH="$ARCH"
    ;;
  armhf)
    DUF_ARCH="armv7"
    ;;
  i386)
    DUF_ARCH="386"
    ;;
  ppc64el)
    DUF_ARCH="ppc64le"
    ;;
  *)
    echo "Unsupported architecture for duf: $ARCH"
    exit 1
    ;;
esac
DUF_VERSION=$(curl -s "https://api.github.com/repos/muesli/duf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo duf.deb "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${DUF_ARCH}.deb"
sudo DEBIAN_FRONTEND=noninteractive apt install -y ./duf.deb
rm ./duf.deb

# install 'direnv' tool (environment switcher)
curl -sfL https://direnv.net/install.sh | bash
if ! grep -qc 'direnv hook' "$shell_rc" ; then
{
  echo
  echo "# Set up 'direnv' (environment switcher)"
  echo "eval \"\$(direnv hook $shell_type)\""
} >> "$shell_rc"
fi
