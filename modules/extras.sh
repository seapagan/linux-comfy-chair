#!/usr/bin/env bash
# extras.sh
# extra additions not in the main install script

# get this device arch:
ARCH=$(dpkg --print-architecture)

# install 'zoxide' tool (this is a faster 'z' tool)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
if ! grep -qc 'zoxide init' "$shell_rc"; then
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
  cat << 'EOF' >> "$shell_rc"

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
  https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh |
  ATUIN_NO_MODIFY_PATH=1 sh
if ! grep -Fqc '.atuin/bin/env' "$shell_rc"; then
  cat << 'EOF' >> "$shell_rc"

# Add 'atuin' to the path
. "$HOME/.atuin/bin/env"
EOF
fi
if [ "$shell_type" = "bash" ]; then
  curl --proto '=https' --tlsv1.2 -LsSf \
    https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh \
    -o "$HOME/.bash-preexec.sh"
  if ! grep -Fqc '.bash-preexec.sh' "$shell_rc"; then
    cat << 'EOF' >> "$shell_rc"
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
curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh |
  XH_BINDIR="$HOME/.local/bin" sh

# install 'watchexec' command runner
cargo binstall watchexec-cli --no-confirm

# install 'tokei' code statistics tool
cargo binstall tokei --no-confirm

# install 'television' fuzzy finder
cargo binstall television --no-confirm

# map Debian architecture names to upstream release asset names
case "$ARCH" in
  amd64)
    SHELLCHECK_ARCH="x86_64"
    SHFMT_ARCH="amd64"
    YQ_ARCH="amd64"
    ;;
  arm64)
    SHELLCHECK_ARCH="aarch64"
    SHFMT_ARCH="arm64"
    YQ_ARCH="arm64"
    ;;
  armhf)
    SHELLCHECK_ARCH="armv6hf"
    SHFMT_ARCH="arm"
    YQ_ARCH="arm"
    ;;
  i386)
    SHELLCHECK_ARCH=""
    SHFMT_ARCH="386"
    YQ_ARCH="386"
    ;;
  *)
    echo "Unsupported architecture for shell tools: $ARCH"
    exit 1
    ;;
esac

# install 'shellcheck' shell script analyser
if [ -n "$SHELLCHECK_ARCH" ]; then
  SHELLCHECK_VERSION=$(curl -s "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo shellcheck.tar.xz "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.${SHELLCHECK_ARCH}.tar.xz"
  tar xf shellcheck.tar.xz --strip-components=1 \
    "shellcheck-${SHELLCHECK_VERSION}/shellcheck"
  sudo install shellcheck /usr/local/bin/shellcheck
  rm shellcheck.tar.xz shellcheck
else
  # Upstream does not publish a Linux i386 binary.
  sudo DEBIAN_FRONTEND=noninteractive apt install -y shellcheck
fi

# install 'shfmt' shell script formatter
SHFMT_VERSION=$(curl -s "https://api.github.com/repos/mvdan/sh/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
curl -Lo shfmt "https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/shfmt_${SHFMT_VERSION}_linux_${SHFMT_ARCH}"
sudo install shfmt /usr/local/bin/shfmt
rm ./shfmt

# install 'jq' command-line JSON processor
curl -Lo jq "https://github.com/jqlang/jq/releases/latest/download/jq-linux-${ARCH}"
sudo install jq /usr/local/bin/jq
rm ./jq

# install 'yq' command-line YAML processor
curl -Lo yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}"
sudo install yq /usr/local/bin/yq
rm ./yq

# install `dust` as an alternative to `du`
cargo binstall du-dust --no-confirm

# install 'duf' as an alternative to 'df'
case "$ARCH" in
  amd64 | arm64)
    DUF_ARCH="$ARCH"
    ;;
  armhf)
    DUF_ARCH="armv7"
    ;;
  i386)
    DUF_ARCH="386"
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
curl -sfL https://direnv.net/install.sh |
  bin_path="$HOME/.local/bin" bash
if ! grep -qc 'direnv hook' "$shell_rc"; then
  {
    echo
    echo "# Set up 'direnv' (environment switcher)"
    echo "eval \"\$(direnv hook $shell_type)\""
  } >> "$shell_rc"
fi

# generate shell completions for tools not installed from system packages
if [ "$shell_type" = "bash" ]; then
  completion_dir="$HOME/.local/share/bash-completion/completions"
  completion_prefix=""
else
  completion_dir="$HOME/.local/share/zsh/site-functions"
  completion_prefix="_"
  if ! grep -Fqc '.local/share/zsh/site-functions' "$shell_rc"; then
    cat << 'EOF' >> "$shell_rc"

# Load completions for user-installed tools
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)
autoload -Uz compinit
compinit
EOF
  fi
fi
mkdir -p "$completion_dir"

lazygit completion "$shell_type" \
  > "$completion_dir/${completion_prefix}lazygit"
bob complete "$shell_type" > "$completion_dir/${completion_prefix}bob"
atuin gen-completions --shell "$shell_type" \
  > "$completion_dir/${completion_prefix}atuin"
delta --generate-completion "$shell_type" \
  > "$completion_dir/${completion_prefix}delta"
xh --generate "complete-$shell_type" > "$completion_dir/${completion_prefix}xh"
watchexec --completions "$shell_type" \
  > "$completion_dir/${completion_prefix}watchexec"
yq completion "$shell_type" > "$completion_dir/${completion_prefix}yq"
