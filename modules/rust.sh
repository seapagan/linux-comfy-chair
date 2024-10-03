#!/usr/bin/env bash
# rust.sh Install the latest version of 'Rust' using 'Rustup'.
echo ""
echo "---------------------------------------------------------------"
echo "| Installing Rust and related tools.                          |"
echo "---------------------------------------------------------------"
echo ""

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# add the .cargo/bin to the path for this shell in case we want to use it
# later in the script.
export PATH="$HOME/.cargo/bin:$PATH"

# install some useful tools
rustup component add clippy
rustup component add rustfmt

cargo install cargo-edit # upgrade dependencies from the CLI

cargo install bob-nvim # neovim version manager
