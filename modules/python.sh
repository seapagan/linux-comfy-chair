#!/usr/bin/env bash
# python.sh Install the latest version of Python 3 using 'Pyenv'. Also install
# 'uv' and 'Poetry' for dependency management and 'pipx' for managing global
# python packages. Python 2 is no longer installed by default, but can be
# installed using 'pyenv' if needed.
echo
echo "---------------------------------------------------------------"
echo "| Installing Python 3, uv, Poetry and PipX.                   |"
echo "---------------------------------------------------------------"
echo

# we still install pyenv, though I now tend to use `uv` for python version
# management too. Pyenv is still handy to have an updated global version
# available.
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
# install a couple of plugins...
git clone https://github.com/yyuu/pyenv-pip-migrate.git ~/.pyenv/plugins/pyenv-pip-migrate
git clone https://github.com/yyuu/pyenv-ccache.git ~/.pyenv/plugins/pyenv-ccache
git clone https://github.com/jawshooah/pyenv-default-packages.git ~/.pyenv/plugins/pyenv-default-packages

# Set up a default-packages file for python libraries to install with each new
# python or venv ... for now, just a few that allow my vscode settings to work
# easier. Will probably deprecate this later, as I now use 'Poetry' for
# dependency management.
cat <<- EOF > ~/.pyenv/default-packages
wheel
ruff
ipython
EOF

if ! grep -qc 'pyenv init' "$shell_rc"; then
  echo "## Adding pyenv to $shell_rc ##"
  {
    echo
    echo "# Set up Pyenv"
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    echo "eval \"\$(pyenv init - $shell_type)\""
    echo 'eval "$(pyenv virtualenv-init -)"'
  } >> "$shell_rc"
fi
# run the above locally to use in this shell
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.14
pyenv global 3.14
# now update 'pip' to the latest version ...
python3 -m pip install --upgrade pip

# Install 'poetry' for packaging and dependency management.
curl -sSL https://install.python-poetry.org | python3 -

# Tell poetry to create the venvs in the local project folder not global
# This is optional, but I find it helps to cut down on the amount of random
# venvs on your system, and keeps things obviously grouped.
poetry config virtualenvs.in-project true

# install pipx for managing global python packages
python3 -m pip install --user pipx
pipx ensurepath

# add autocompletion for pipx
if ! grep -qc 'pipx' "$shell_rc"; then
  echo 'eval "$(register-python-argcomplete pipx)"' >> "$shell_rc"
fi

# run the above locally to use in this shell
eval "$(register-python-argcomplete pipx)"

# install 'uv' for python project and version management (replaces poetry). This
# can also replace 'pipx' but we'll keep both available for now.
curl -LsSf https://astral.sh/uv/install.sh | sh

# prepare the uv config file if it does not exist
mkdir -p "$HOME/.config/uv"
touch "$HOME/.config/uv/uv.toml"
if ! grep -qc 'python-preference' "$HOME/.config/uv/uv.toml"; then
  # only use uv's own python versions, not any pyenv
  echo 'python-preference="only-managed"' >> "$HOME/.config/uv/uv.toml"
fi
