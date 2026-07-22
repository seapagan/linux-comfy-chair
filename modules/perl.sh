#!/usr/bin/env bash
# perl.sh
# install Perl using Perlbrew and set up cpan etc

echo
echo "---------------------------------------------------------------"
echo "| Installing Perl.                                            |"
echo "---------------------------------------------------------------"
echo

if ! run_downloaded_installer perlbrew https://install.perlbrew.pl \
  perlbrew-installer.sh bash; then
  return 1
fi
if ! grep -q 'perl5/perlbrew/etc/bashrc' "$shell_rc"; then
  echo "## Adding Perlbrew to $shell_rc ##"
  {
    echo
    echo "# Set up Perlbrew"
    echo 'source "$HOME/perl5/perlbrew/etc/bashrc"'
  } >> "$shell_rc"
fi
# source perlbrew setup so we can use in this shell...
source "$HOME/perl5/perlbrew/etc/bashrc"

# install perl and select it...
perlbrew install perl-5.44.0
perlbrew switch perl-5.44.0
perlbrew install-cpanm
# set up some cpan configuration
(
  echo y
  echo o conf auto_commit 1
  echo o conf yaml_module YAML::XS
  echo o conf use_sqlite yes
  echo o conf commit
) | cpan
(
  echo o conf prerequisites_policy follow
  echo o conf build_requires_install_policy yes
  echo o conf commit
) | cpan
(
  echo o conf colorize_output yes
  echo o conf colorize_print bold white on_black
  echo o conf colorize_warn bold red on_black
  echo o conf colorize_debug green on_black
  echo o conf commit
) | cpan
# now install useful modules for CPAN...
cpanm Term::ReadLine::Perl --notest # we install this separately and with no tests so it will not timeout on unattended installs. Ohterwise may crash the script.
cpanm CPAN Term::ReadKey YAML YAML::XS LWP CPAN::SQLite App::cpanoutdated Log::Log4perl XML::LibXML Text::Glob App::cpanminus
# Its test suite downloads an obsolete Neovim nightly asset.
cpanm Neovim::Ext --notest
# Upgrade any modules that need it...
echo "-> running 'cpan-outdated' on Perl modules...."
cpan-outdated -p | cpanm
