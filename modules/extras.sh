#!/usr/bin/env bash
# extras.sh
# extra additions not in the main install script

# get this device arch:
ARCH=$(dpkg --print-architecture)

# map Debian architecture names to upstream release asset names
ARCH_SUPPORTED="yes"
case "$ARCH" in
  amd64)
    LAZYGIT_ARCH="x86_64"
    HYPERFINE_ARCH="amd64"
    SHELLCHECK_ARCH="x86_64"
    SHFMT_ARCH="amd64"
    YQ_ARCH="amd64"
    DUF_ARCH="amd64"
    ;;
  arm64)
    LAZYGIT_ARCH="arm64"
    HYPERFINE_ARCH="arm64"
    SHELLCHECK_ARCH="aarch64"
    SHFMT_ARCH="arm64"
    YQ_ARCH="arm64"
    DUF_ARCH="arm64"
    ;;
  armhf)
    LAZYGIT_ARCH="armv6"
    HYPERFINE_ARCH="armhf"
    SHELLCHECK_ARCH="armv6hf"
    SHFMT_ARCH="arm"
    YQ_ARCH="arm"
    DUF_ARCH="armv7"
    ;;
  i386)
    LAZYGIT_ARCH="32-bit"
    HYPERFINE_ARCH="i686"
    SHELLCHECK_ARCH=""
    SHFMT_ARCH="386"
    YQ_ARCH="386"
    DUF_ARCH="386"
    ;;
  *)
    ARCH_SUPPORTED="no"
    echo "Warning: no release asset mappings are available for '$ARCH'."
    ;;
esac

install_binary_from_url() {
  local component=$1
  local url=$2
  local binary_tmp="$install_tmp_dir/$component"

  if ! curl -fL -o "$binary_tmp" "$url" ||
    ! sudo install "$binary_tmp" "/usr/local/bin/$component"; then
    record_failed_install "$component"
  fi
}

# install 'zoxide' tool (this is a faster 'z' tool)
run_downloaded_installer zoxide \
  https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
  zoxide-installer.sh sh
if command -v zoxide > /dev/null && ! grep -q 'zoxide init' "$shell_rc"; then
  {
    echo
    echo "# Set up 'zoxide' (jump around)"
    echo "eval \"\$(zoxide init $shell_type)\""
  } >> "$shell_rc"
fi

# install 'fzf' tool (fuzzy finder)
fzf_install_failed="no"
if [ -x "$HOME/.fzf/install" ]; then
  if ! git -C "$HOME/.fzf" pull --ff-only; then
    fzf_install_failed="yes"
  fi
elif ! git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"; then
  fzf_install_failed="yes"
fi
if [ ! -x "$HOME/.fzf/install" ] || ! "$HOME/.fzf/install" --all; then
  fzf_install_failed="yes"
fi
if [ "$fzf_install_failed" = "yes" ]; then
  record_failed_install fzf
fi

# install 'lazygit' tool
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  lazygit_archive="$install_tmp_dir/lazygit.tar.gz"
  lazygit_binary="$install_tmp_dir/lazygit"
  if ! curl -fLo "$lazygit_archive" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_linux_${LAZYGIT_ARCH}.tar.gz" ||
    ! tar -xf "$lazygit_archive" -C "$install_tmp_dir" lazygit ||
    ! sudo install "$lazygit_binary" /usr/local/bin; then
    record_failed_install lazygit
  fi
else
  record_failed_install lazygit
fi

# install 'lazydocker' tool
run_downloaded_installer lazydocker \
  https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh \
  lazydocker-installer.sh bash

# install 'bat' tool (cat clone with syntax highlighting)
BAT_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
bat_package="$install_tmp_dir/bat.deb"
if ! curl -fLo "$bat_package" "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCH}.deb" ||
  ! sudo apt install -y "$bat_package"; then
  record_failed_install bat
fi

# install 'ripgrep' tool (grep clone with better performance)
RIPGREP_VERSION=$(curl -s "https://api.github.com/repos/BurntSushi/ripgrep/releases/latest" | grep -Po '"tag_name": "(\K[^"]*)')
ripgrep_package="$install_tmp_dir/ripgrep.deb"
if ! curl -fLo "$ripgrep_package" "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}-1_$ARCH.deb" ||
  ! sudo dpkg -i "$ripgrep_package"; then
  record_failed_install ripgrep
fi

# install 'fd' tool (find clone with better performance)
FD_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/fd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
fd_package="$install_tmp_dir/fd.deb"
if ! curl -fLo "$fd_package" "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-musl_${FD_VERSION}_$ARCH.deb" ||
  ! sudo dpkg -i "$fd_package"; then
  record_failed_install fd
fi

# install bob neovim version manager
install_with_cargo_binstall bob-nvim
# ensure we can find nvim if installed by bob:
if command -v bob > /dev/null && ! grep -q 'bob/nvim-bin' "$shell_rc"; then
  {
    echo
    echo "# so we can find nvim"
    echo 'export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"'
  } >> "$shell_rc"
fi

# install 'lsplus' as an available `ls` replacement
install_with_cargo_binstall lsplus

# install 'yazi' terminal file manager
install_with_cargo_binstall yazi-fm
if command -v yazi > /dev/null && ! grep -Fq 'function y()' "$shell_rc"; then
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
ATUIN_NO_MODIFY_PATH=1 run_downloaded_installer atuin \
  https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh \
  atuin-installer.sh sh

if [ -x "$HOME/.atuin/bin/atuin" ]; then
  export PATH="$HOME/.atuin/bin:$PATH"
else
  record_failed_install atuin
fi

if command -v atuin > /dev/null &&
  ! grep -Fq 'export PATH="$HOME/.atuin/bin:$PATH"' "$shell_rc"; then
  cat << 'EOF' >> "$shell_rc"

# Add 'atuin' to the path
export PATH="$HOME/.atuin/bin:$PATH"
EOF
fi
if command -v atuin > /dev/null && [ "$shell_type" = "bash" ]; then
  bash_preexec_tmp="$install_tmp_dir/bash-preexec.sh"
  if ! curl --proto '=https' --tlsv1.2 -LsSf \
    https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh \
    -o "$bash_preexec_tmp" ||
    ! mv "$bash_preexec_tmp" "$HOME/.bash-preexec.sh"; then
    rm -f -- "$bash_preexec_tmp"
    record_failed_install bash-preexec
  fi
  if [ -f "$HOME/.bash-preexec.sh" ] &&
    ! grep -Fq '.bash-preexec.sh' "$shell_rc"; then
    cat << 'EOF' >> "$shell_rc"

# Set up bash-preexec for Atuin
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
EOF
  fi
fi
if command -v atuin > /dev/null &&
  { [ "$shell_type" != "bash" ] || [ -f "$HOME/.bash-preexec.sh" ]; } &&
  ! grep -Fq 'atuin init' "$shell_rc"; then
  {
    echo
    echo "# Set up Atuin shell history"
    printf "eval \"\$(atuin init %s --disable-up-arrow)\"\n" "$shell_type"
  } >> "$shell_rc"
fi

# install 'delta' syntax-highlighting pager
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  delta_package="$install_tmp_dir/git-delta.deb"
  if ! curl -fLo "$delta_package" "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb" ||
    ! sudo DEBIAN_FRONTEND=noninteractive apt install -y "$delta_package"; then
    record_failed_install delta
  fi
else
  record_failed_install delta
fi

# install 'hyperfine' command-line benchmarking tool
# Debian reports 32-bit x86 as i386, but hyperfine names its package i686.
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  HYPERFINE_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/hyperfine/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  hyperfine_package="$install_tmp_dir/hyperfine.deb"
  if ! curl -fLo "$hyperfine_package" "https://github.com/sharkdp/hyperfine/releases/download/v${HYPERFINE_VERSION}/hyperfine_${HYPERFINE_VERSION}_${HYPERFINE_ARCH}.deb" ||
    ! sudo DEBIAN_FRONTEND=noninteractive apt install -y "$hyperfine_package"; then
    record_failed_install hyperfine
  fi
else
  record_failed_install hyperfine
fi

# install 'xh' HTTP client
XH_BINDIR="$HOME/.local/bin" run_downloaded_installer xh \
  https://raw.githubusercontent.com/ducaale/xh/master/install.sh \
  xh-installer.sh sh

# install 'watchexec' command runner
install_with_cargo_binstall watchexec-cli

# install 'tokei' code statistics tool
install_with_cargo_binstall tokei

# install 'television' fuzzy finder
install_with_cargo_binstall television

# install 'shellcheck' shell script analyser
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  if [ -n "$SHELLCHECK_ARCH" ]; then
    SHELLCHECK_VERSION=$(curl -s "https://api.github.com/repos/koalaman/shellcheck/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    shellcheck_archive="$install_tmp_dir/shellcheck.tar.xz"
    shellcheck_binary="$install_tmp_dir/shellcheck"
    if ! curl -fLo "$shellcheck_archive" "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.${SHELLCHECK_ARCH}.tar.xz" ||
      ! tar -xf "$shellcheck_archive" -C "$install_tmp_dir" --strip-components=1 \
        "shellcheck-${SHELLCHECK_VERSION}/shellcheck" ||
      ! sudo install "$shellcheck_binary" /usr/local/bin/shellcheck; then
      record_failed_install shellcheck
    fi
  else
    # Upstream does not publish a Linux i386 binary.
    if ! sudo DEBIAN_FRONTEND=noninteractive apt install -y shellcheck; then
      record_failed_install shellcheck
    fi
  fi
else
  record_failed_install shellcheck
fi

# install 'shfmt' shell script formatter
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  SHFMT_VERSION=$(curl -s "https://api.github.com/repos/mvdan/sh/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  install_binary_from_url shfmt \
    "https://github.com/mvdan/sh/releases/download/${SHFMT_VERSION}/shfmt_${SHFMT_VERSION}_linux_${SHFMT_ARCH}"
else
  record_failed_install shfmt
fi

# install 'jq' command-line JSON processor
install_binary_from_url jq \
  "https://github.com/jqlang/jq/releases/latest/download/jq-linux-${ARCH}"

# install 'yq' command-line YAML processor
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  install_binary_from_url yq \
    "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}"
else
  record_failed_install yq
fi

# install `dust` as an alternative to `du`
install_with_cargo_binstall du-dust

# install 'duf' as an alternative to 'df'
if [ "$ARCH_SUPPORTED" = "yes" ]; then
  DUF_VERSION=$(curl -s "https://api.github.com/repos/muesli/duf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  duf_package="$install_tmp_dir/duf.deb"
  if ! curl -fLo "$duf_package" "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${DUF_ARCH}.deb" ||
    ! sudo DEBIAN_FRONTEND=noninteractive apt install -y "$duf_package"; then
    record_failed_install duf
  fi
else
  record_failed_install duf
fi

# install 'direnv' tool (environment switcher)
bin_path="$HOME/.local/bin" run_downloaded_installer direnv \
  https://direnv.net/install.sh direnv-installer.sh bash
if command -v direnv > /dev/null && ! grep -q 'direnv hook' "$shell_rc"; then
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
  if ! grep -Fq '.local/share/zsh/site-functions' "$shell_rc"; then
    cat << 'EOF' >> "$shell_rc"

# Load completions for user-installed tools
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)
if (( ${+functions[compdef]} )); then
  for completion_file in "$HOME/.local/share/zsh/site-functions"/_*(N); do
    completion_function=${completion_file:t}
    if [[ $completion_function = "_lazygit" ]]; then
      source "$completion_file"
    else
      autoload -Uz "$completion_function"
    fi
    compdef "$completion_function" "${completion_function#_}"
  done
  unset completion_file completion_function
else
  autoload -Uz compinit
  compinit
fi
EOF
  fi
fi
mkdir -p "$completion_dir"

generate_completion() {
  local component=$1
  local output_file=$2
  local completion_tmp
  shift 2

  if ! completion_tmp=$(mktemp "$completion_dir/.${component}.XXXXXX"); then
    record_failed_install "$component completions"
    return
  fi

  if "$@" > "$completion_tmp" && [ -s "$completion_tmp" ] &&
    mv "$completion_tmp" "$output_file"; then
    return
  fi

  rm -f -- "$completion_tmp"
  record_failed_install "$component completions"
}

if command -v lazygit > /dev/null; then
  generate_completion lazygit \
    "$completion_dir/${completion_prefix}lazygit" \
    lazygit completion "$shell_type"
fi
if command -v bob > /dev/null; then
  generate_completion bob "$completion_dir/${completion_prefix}bob" \
    bob complete "$shell_type"
fi
if command -v atuin > /dev/null; then
  generate_completion atuin "$completion_dir/${completion_prefix}atuin" \
    atuin gen-completions --shell "$shell_type"
fi
if command -v delta > /dev/null; then
  generate_completion delta "$completion_dir/${completion_prefix}delta" \
    delta --generate-completion "$shell_type"
fi
if command -v xh > /dev/null; then
  generate_completion xh "$completion_dir/${completion_prefix}xh" \
    xh --generate "complete-$shell_type"
fi
if command -v watchexec > /dev/null; then
  generate_completion watchexec \
    "$completion_dir/${completion_prefix}watchexec" \
    watchexec --completions "$shell_type"
fi
if command -v yq > /dev/null; then
  generate_completion yq "$completion_dir/${completion_prefix}yq" \
    yq completion "$shell_type"
fi
