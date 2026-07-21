#!/usr/bin/env bash
# rust.sh Install the latest version of 'Rust' using 'Rustup'.
echo
echo "---------------------------------------------------------------"
echo "| Installing Rust and related tools.                          |"
echo "---------------------------------------------------------------"
echo

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# add the .cargo/bin to the path for this shell in case we want to use it
# later in the script.
export PATH="$HOME/.cargo/bin:$PATH"

# install some useful tools
rustup component add clippy
rustup component add rustfmt

# add 'cargo-binstall' to speed up later installs.
cargo_binstall_tmp="$install_tmp_dir/cargo-binstall-installer.sh"
if ! curl -L --proto '=https' --tlsv1.2 -sSf \
  https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
  -o "$cargo_binstall_tmp" ||
  ! (cd "$install_tmp_dir" && bash "$cargo_binstall_tmp"); then
  record_failed_install cargo-binstall
fi

install_with_cargo_binstall cargo-edit # upgrade dependencies from the CLI
install_with_cargo_binstall cargo-make # useful task runner
