# Linux 'Comfy Chair'

You know how it is; your own Linux is set up like your favourite comfy chair -
everything is close to hand, set up the way you want, and there are no
surprises. That's why it's so annoying to set up a new computer or virtual
machine, especially if you are testing stuff (like this script!!) that needs
both a certain amount of installed dependencies and a dependable state.

Hence this script. This is the evolution of my previous work to bootstrap a new
Raspberry PI system and Windows 10 'WSL', but for pure (Debian Based) Linux.
Primary usage has been tested with Ubuntu though it should work with any
Debian-based distribution. Note that the script will only run on debian-based
distributions (Debian, Ubuntu, Kali, Mint etc etc)

**Note that the script is geared towards and tested on _server_ versions more
than Desktop ones, though it has been used successfully on both.**

## Prerequisites

At the absolute minimum, you need a working system that you can log into, either
locally or over ssh. The only 2 other absolute requirements are that ```git```
and ```sudo``` are installed. In 99% of cases, they will be. Some minimal images
may not have these - for example, the standard Docker Ubuntu image does NOT. The
script will install any other missing base dependencies that are critical for
the rest of the script to function.

## Note: WSL2 (Windows Subsystem for Linux)

This system has also been tested on Ubuntu 20.04 running under WSL2 and works
perfectly as far as I can see with the below caveats:

* **The Docker Script is DISABLED**. If you wish to use Docker under WSL then
  please install the '**Docker Desktop**' under windows itself. This already is
  very well and tightly integrated with WSL. Just ensure that you have Docker
  Desktop running in the background. As a side effect, your Docker containers in
  Windows will now run using the WSL so will be proper linux containers.
* Due to the lack of background services, you will need to manually start
  Postgresql, Nginx, ssh etc as required. I use a script in my home dir so I can
  enable and disable at will when needed.
* This may work under WSL version 1, and has worked in the past, however I no
  longer test against this version of WSL. In all cases it is worthwhile and
  very easy to upgrade to WSL Version 2

If WSL is detected, the package `ubuntu-wsl` will also be installed if missing.
This should already be there in the official Ubuntu image, but probably not
custom ones

I will continue to ensure compatibility with WSL as I often use this for quick
development testing.

## Note 2: Currently only for `bash` shell

The script writes configuration settings to .bashrc, which will mean lack of
functionality under `Zsh` and others. I am currently starting to look at
migrating to Zsh myself, so this will likely be fixed in future releases.

Under Zsh and others the Pyenv/Rbenv/NVM etc **will not work at this time**,
though you can certainly move the relevant sections from the `.bashrc` to the
`.zshrc`

## General Information

The script works on a bare newly installed system and provides the following functionality :

* Updated to the latest package versions from Ubuntu / Debian upstream.
* Have the `build-essential` package installed plus all required support
  libraries to enable the below functionality to work.
* The Latest version of [`Git`][git] installed. A skeleton `.gitconfig` will be
  set up with a few aliases.
* The [`Ruby`][ruby] scripting language is installed via [`Rbenv`][rbenv] with
  the current Rails version and several other common gems.
* [`Node.js`][node] both the most recent LTS version and latest stable version
  via [`NVM`][nvm]. The LTS version is activated by default.
* The [`Python`][python] scripting language both the latest 2.7 and 3.x versions
  via [`Pyenv`][pyenv]
* Install the latest STABLE [`Perl`][perl] scripting language via
  [`Perlbrew`][perlbrew] with cpan and cpanm pre-installed and configured.
  Several PERL modules that make cpan easier are also pre-installed
* Enable resolution of WINS hostnames
* Install Nginx web server(Latest), PHP(v7.4) and Postgresql database(v12) ( all
  3 disabled by default). I am planning (yet) to upgrade PHP and Postgresql
  to more modern versions soon, though both these versions are currently (June
  2022) at least still supported with security fixes.
* Install Docker and Docker-compose (disabled by default)

## Security

Please be aware that no attempt has been made to Secure or harden the final
Linux system. This is something you will need to do yourself. Indeed, if your
server is public, I'd advise that a very restrictive firewall blocking
everything IN except for SSH is the first thing you do before even running this
script! No responsibility will be taken for security breaches on systems set up
with this script.

## Current Issues/Bugs

### Installing Ruby versions < 3.1 fails on Ubuntu 22.04

Issue #10. The OpenSSL version in Ubuntu 22.04 is incompatible with any ruby
below version 3 and causes installation errors. There is a work-around
[here][issue-10-workaround] which I will shortly add to the script.

## Usage

The simplest way to use this script is to clone into a completely new Ubuntu
environment.

From the terminal run the following commands:

```bash
git clone https://github.com/seapagan/linux-comfy-chair.git
cd ubuntu-win-bootstrap
./comfy-chair.sh
```

## To-Do

* More robust fall-over on already configured systems. If Rbenv etc are already
  installed then ignore installing that part
* set up configuration keys to determine what modules to install

### Further proposed modules

* Vagrant
* Samba

## Contributing

Please **do** feel free to open an Issue for any errors or missing dependencies
you find, or even a Pull Request with solutions 😎

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[git]: https://git-scm.com
[ruby]: https://www.ruby-lang.org
[rbenv]: https://github.com/rbenv/rbenv
[node]: https://nodejs.org
[nvm]: https://github.com/creationix/nvm
[python]: https://www.python.org/
[pyenv]: https://github.com/pyenv/pyenv
[perl]: https://www.perl.org/
[perlbrew]: https://perlbrew.pl/

[issue-10-workaround]:
    https://github.com/rbenv/ruby-build/discussions/1940#discussioncomment-2663209
