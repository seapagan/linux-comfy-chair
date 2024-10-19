#!/usr/bin/env bash
# python.sh Install the latest version of Python 3 using 'Pyenv'. Also install
# 'Poetry' for dependency management and 'pipx' for managing global python
# packages. Python 2 is no longer installed by
# default, but can be installed using 'pyenv' if needed.
echo ""
echo "---------------------------------------------------------------"
echo "| Installing Python 3, Poetry and PipX.                       |"
echo "---------------------------------------------------------------"
echo ""


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

if ! grep -qc 'pyenv init' ~/.bashrc ; then
  echo "## Adding pyenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Pyenv" >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi
# run the above locally to use in this shell
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.12
pyenv global 3.12
# now update 'pip' to the latest version ...
python3 -m pip install --upgrade pip

# add the .local/bin to the path if it isn't already there...
if ! grep -qc '/.local/bin' ~/.bashrc ; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
# run the above locally to use in this shell
export PATH="$HOME/.local/bin:$PATH"

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
if ! grep -qc 'pipx' ~/.bashrc ; then
  echo 'eval "$(register-python-argcomplete pipx)"' >> ~/.bashrc
fi

# run the above locally to use in this shell
eval "$(register-python-argcomplete pipx)"

# install 'uv' for python project and version management/ This can also replace
# 'pipx' but we'll keep both available for now.
curl -LsSf https://astral.sh/uv/install.sh | sh
