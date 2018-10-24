#!/usr/bin/env bash
# these will run as the default non-privileged user.

# save the path to this script for later use
THISPATH="$(dirname $(readlink -f "$0"))"
echo "We are running from : $THISPATH"

# ensure we have the latest packages, including git and sublime text repos
sudo add-apt-repository ppa:git-core/ppa -y
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt -y full-upgrade

# make sure we have the required libraries and tools already installed before starting.
sudo apt install -y build-essential curl gettext libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev libgtk2.0-0 libbz2-dev sublime-text libxml2-dev libdb-dev gedit ccache libffi-dev

# install winbind and support lib to ping WINS hosts
sudo apt install -y winbind libnss-winbind
# need to append to the /etc/nsswitch.conf file to enable if not already done ...
if ! grep -qc 'wins' /etc/nsswitch.conf ; then
  sudo sed -i '/hosts:/ s/$/ wins/' /etc/nsswitch.conf
fi

# start with rbenv and plugins installation
export PATH="$HOME/.rbenv/bin:$PATH"
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
# install dynamic bash extension
cd ~/.rbenv && src/configure && make -C src
# add the rbenv setup to our profile, only if it is not already there
if ! grep -qc 'rbenv init' ~/.bashrc ; then
  echo "## Adding rbenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Rbenv" >> ~/.bashrc
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi
# run the above command locally so we can get rbenv to work on this provisioning shell
eval "$(rbenv init -)"
# install a set of useful plugins for rbenv...
mkdir -p ~/.rbenv/plugins
git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs
git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
git clone https://github.com/rbenv/rbenv-each.git ~/.rbenv/plugins/rbenv-each
git clone https://github.com/nabeo/rbenv-gem-migrate.git ~/.rbenv/plugins/rbenv-gem-migrate
git clone https://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset
git clone https://github.com/nicknovitski/rbenv-gem-update ~/.rbenv/plugins/rbenv-gem-update
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
git clone https://github.com/toy/rbenv-update-rubies.git ~/.rbenv/plugins/rbenv-update-rubies
git clone https://github.com/rkh/rbenv-whatis.git ~/.rbenv/plugins/rbenv-whatis
git clone https://github.com/yyuu/rbenv-ccache.git ~/.rbenv/plugins/rbenv-ccache

# set up a default-gems file for gems to install with each ruby...
echo $'bundler\nsass\nscss_lint\nrails\nrspec\nrspec-rails' > ~/.rbenv/default-gems
# set up .gemrc to avoid installing documentation for each gem...
echo "gem: --no-document" > ~/.gemrc
# install the required ruby version and set as default
rbenv install 2.5.1
rbenv global 2.5.1

# we need to erase 2 files temporarily (they will be regenerated) otherwise the installation will pause for overwrite confirmation
# These are the 'ri' and 'rdoc' scripts
rm ~/.rbenv/versions/2.5.1/bin/rdoc
rm ~/.rbenv/versions/2.5.1/bin/ri
# now update RubyGems and the default gems
gem update --system
gem update

# now install nvm, the latest LTS version of Node and the latest actual verision of Node..
echo "## Setting up NVM (Node Version Manager) ##"
echo >> ~/.bashrc
echo "# Set up NVM" >> ~/.bashrc
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
nvm install node
nvm use --lts

# next install python (both 2.x and 3.x trees) using Pyenv
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
# install a couple of plugins...
git clone git://github.com/yyuu/pyenv-pip-migrate.git ~/.pyenv/plugins/pyenv-pip-migrate
git clone https://github.com/yyuu/pyenv-ccache.git ~/.pyenv/plugins/pyenv-ccache

if ! grep -qc 'pyenv init' ~/.bashrc ; then
  echo "## Adding pyenv to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Pyenv" >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi
# run the above locally to use in this shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 2.7.15
pyenv install 3.7.0
# 'python' and 'python2.7' target 2.7.15 while 'python3.6' targets 3.6.5
pyenv global 2.7.15 3.7.0

# now to install Perl using Perlbrew...
\curl -L https://install.perlbrew.pl | bash
if ! grep -qc '~/perl5/perlbrew/etc/bashrc' ~/.bashrc ; then
  echo "## Adding Perlbrew to .bashrc ##"
  echo >> ~/.bashrc
  echo "# Set up Perlbrew" >> ~/.bashrc
  echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
fi
# source perlbrew setup so we can use in this shell
source ~/perl5/perlbrew/etc/bashrc
# Currently the tests will fail under WSL so we dont run them. Needs further investigation.
perlbrew install perl-5.29.2 --notest
perlbrew switch perl-5.29.2
perlbrew install-cpanm
# set up some cpan configuration
(echo y; echo o conf auto_commit 1; echo o conf yaml_module YAML::XS; echo o conf use_sqlite yes; echo o conf commit) | cpan
(echo o conf prerequisites_policy follow; echo o conf build_requires_install_policy yes) | cpan
(echo o conf colorize_output yes; echo o conf colorize_print bold white on_black; echo o conf colorize_warn bold red on_black; echo o conf colorize_debug green on_black) | cpan
# now install useful modules for CPAN...
cpanm Term::ReadLine::Perl --notest # we install this separately and with no tests so it will not timeout on unattended installs. Ohterwise may timeout and crash the script.
cpanm CPAN Term::ReadKey YAML YAML::XS LWP CPAN::SQLite App::cpanoutdated Log::Log4perl XML::LibXML Text::Glob
# Upgrade any modules that need it...
cpanm Net::Ping --force # this fails tests on WSL so must be forced
cpan-outdated -p | cpanm

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cp $THISPATH/support/.gitconfig ~/.gitconfig
fi

# set up Sublime Text with Package control and a useful selection of default packages.
# You can edit the list of pre-installed packages in the file `./support/Package\ Control.sublime-settings`
# These packages will be installed when subl is first run
mkdir -p ~/.config/sublime-text-3/Installed\ Packages
mkdir -p ~/.config/sublime-text-3/Packages/User
mkdir -p ~/.config/sublime-text-3/Local
curl -o ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package
cp $THISPATH/support/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User
# install the sublime license if it is found...
if [ -f "$THISPATH/support/License.sublime_license" ] ; then
  cp $THISPATH/support/License.sublime_license ~/.config/sublime-text-3/Local
fi
# it would also be very useful to pre-configure some Subl default settings at this time
# TODO

echo
echo "You now need to reboot this system for all the new changes to take affect."
