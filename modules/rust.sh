#!/usr/bin/env bash
# rust.sh Install the latest version of 'Rust' using 'Rustup'.
echo
echo "---------------------------------------------------------------"
echo "| Installing Rust and related tools.                          |"
echo "---------------------------------------------------------------"
echo

if ! run_downloaded_installer rustup https://sh.rustup.rs \
  rustup-installer.sh sh -y; then
  return 1
fi

# add the .cargo/bin to the path for this shell in case we want to use it
# later in the script.
export PATH="$HOME/.cargo/bin:$PATH"

# install some useful tools
rustup component add clippy
rustup component add rustfmt

# add 'cargo-binstall' to speed up later installs.
if ! run_downloaded_installer cargo-binstall \
  https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
  cargo-binstall-installer.sh bash; then
  :
fi

install_with_cargo_binstall cargo-edit # upgrade dependencies from the CLI
install_with_cargo_binstall cargo-make # useful task runner
