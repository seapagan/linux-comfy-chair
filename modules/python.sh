#!/usr/bin/env bash
# python.sh
# next install python (both 2.x and 3.x trees) using Pyenv
# will probably stop installing python2 in the near future as it is EOL.

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
# install a couple of plugins...
git clone https://github.com/yyuu/pyenv-pip-migrate.git ~/.pyenv/plugins/pyenv-pip-migrate
git clone https://github.com/yyuu/pyenv-ccache.git ~/.pyenv/plugins/pyenv-ccache
git clone https://github.com/jawshooah/pyenv-default-packages.git ~/.pyenv/plugins/pyenv-default-packages

# set up a default-packages file for python libraries to install with each new python or venv ...
# for now, just a few that allow my vscode settings to work easier.
cat <<- EOF > ~/.pyenv/default-packages
wheel
pylint
black
flake8
flake8-docstrings
pep8-naming
pydocstyle
ipython
EOF


if ! grep -qc 'pyenv init' ~/.bashrc ; then
  echo "## Adding pyenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Pyenv" >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
fi
# run the above locally to use in this shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

pyenv install 2.7.18
pyenv install 3.10.4
# 'python' and 'python3' target 3.10.4 while 'python2' targets 2.7.18
pyenv global 3.10.4 2.7.18
# now update 'pip' in both versions ...
python2 -m pip install --upgrade pip
python3 -m pip install --upgrade pip
