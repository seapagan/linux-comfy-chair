# Linux 'Comfy Chair'

You know how it is; your own Linux is set up like your favourite comfy chair -
everything is close to hand, set up the way you want, and there are no
surprises. That's why it's so annoying to set up a new computer or virtual
machine, especially if you are testing stuff (like this script!!) that needs
both a certain amount of installed dependencies and a dependable state.

Hence this script. This is the evolution of my previous work to bootstrap a new
Raspberry PI system and Windows 10 'WSL', but for pure (Debian Based) Linux.
Primary usage and testing has been done with Ubuntu though it should now work
with any Debian-based distribution. Note that the script will only run on
debian-based distributions (Debian, Ubuntu, Kali, Mint etc etc) as well as
Raspberry PI or WSL variants on those.

**Note that the script is geared towards and tested on _server_ versions more
than Desktop ones, though it has been used successfully on both**. In fact my
primary day-to-day machine runs Ubuntu Desktop (22.04) which was set up using
this script.

## Compatible Linux systems

This script has been tested on the following systems:

- [x] Ubuntu Desktop and Server 64-bit, 20.x and up.
- [x] Debian Bullseye 64-bit minimal network install (so it should work fine on
  the full GUI install)
- [x] Raspberry PI 3 Arm64 running Ubuntu 22.04
- [x] Raspberry PI 4 Arm64 running Raspbian Bullseye
- [x] WSL2 on Windows 10 & 11, running Ubuntu or Debian images.

If you have experience (good or bad) running this script on other hardware, cpu
and Debian-based OS's please get in touch and I will add to the list, or fix the
problem 😁

## Prerequisites

At the absolute minimum, you need a working system that you can log into, either
locally or over ssh. The only 2 other absolute requirements are that `git` and
`sudo` are installed. In 99% of cases, they will be. Some minimal images may not
have these - for example, the standard Docker Ubuntu image does NOT, nor does a
minimal (non-GUI, network install) installation of Debian Bullseye. The script
will install any other missing base dependencies that are critical for the rest
of the script to function.

## Note: WSL2 (Windows Subsystem for Linux)

This system has also been tested on Ubuntu 20.04 running under WSL2 and works
perfectly as far as I can see with the below caveats:

- **The Docker Script is DISABLED**. If you wish to use Docker under WSL then
  please install the '**Docker Desktop**' under windows itself. This already is
  very well and tightly integrated with WSL. Just ensure that you have Docker
  Desktop running in the background. As a side effect, your Docker containers in
  Windows will now run using the WSL so will be proper linux containers.
- Due to the lack of background services, you will need to manually start
  Postgresql, Nginx, ssh etc as required. I use a script in my home dir so I can
  enable and disable at will when needed.
- This may work under WSL version 1, and has worked in the past, however I no
  longer test against this version of WSL. In all cases it is worthwhile and
  very easy to upgrade to WSL Version 2

If WSL is detected, the package `ubuntu-wsl` will also be installed if missing.
This should already be there in the official Ubuntu image, but probably not
custom ones

I have moved away from using WSL, as I have migrated to Linux full-time for my
development and day-to-day machine, however, I will try to test on WSL and fix
any errors for each official release.

## Note 2: Currently only for `bash` and `zsh` shells

The installer uses Bash and expects Bash to be present on the system, which is
the default on Debian-based distributions. It detects the login shell from
`$SHELL` and writes configuration to `.bashrc` or `.zshrc`. Other login shells
are not currently supported.

As a result, under shells other than Bash or Zsh the Pyenv/Rbenv/NVM etc **will
not work at this time**, though you can certainly move the relevant sections
from `.bashrc` or `.zshrc` to the correct file for your shell.

## General Information

> [!IMPORTANT]
> This bootstrapper deliberately installs the latest stable packages and tools
> available at provisioning time. APT packages and most third-party tools are
> intentionally not pinned, so separate runs may install different versions.
> It is not intended to produce bit-for-bit reproducible systems.

The script works on a bare newly installed system and provides the following
functionality :

- Updated to the latest package versions from Ubuntu / Debian upstream.
- Have the `build-essential` package installed plus all required support
  libraries to enable the below functionality to work.
- The Latest version of [`Git`][git] installed. A skeleton `.gitconfig` will be
  set up with a few aliases.
- The [`Ruby`][ruby] scripting language is installed via [`Rbenv`][rbenv] with
  the current Rails version and several other common gems.
- [`Node.js`][node] both the most recent LTS version and latest stable version
  via [`NVM`][nvm]. The LTS version is activated by default.
- The [`Python`][python] scripting language, latest 3.x version
  via [`Pyenv`][pyenv]. [uv](https://docs.astral.sh/uv/),
  [Poetry](https://python-poetry.org/), [PipX](https://pypa.github.io/pipx/),
  and [Ruff](https://github.com/astral-sh/ruff) are all pre-installed.
- The latest version of [`Rust`](https://www.rust-lang.org/) via `rustup`, with
  [cargo-binstall](https://github.com/cargo-bins/cargo-binstall),
  [cargo-edit](https://github.com/killercup/cargo-edit), and
  [cargo-make](https://github.com/sagiegurari/cargo-make).
- Install the latest STABLE [`Perl`][perl] scripting language via
  [`Perlbrew`][perlbrew] with cpan and cpanm pre-installed and configured.
  Several Perl modules that make CPAN easier to use are also pre-installed.
- Enable resolution of WINS hostnames
- [`DISABLED BY DEFAULT`] Install the latest Nginx web server, PHP 8.5 FPM, CLI,
  common PHP extensions, and PostgreSQL 18.
- Install Docker and Docker-compose (unless on WSL2)
- Some useful command-line tools are installed automatically:
  - Navigation and search: [zoxide](https://github.com/ajeetdsouza/zoxide),
    [fzf](https://github.com/junegunn/fzf),
    [Yazi](https://github.com/sxyazi/yazi),
    [Television](https://github.com/alexpasmantier/television), and
    [direnv](https://direnv.net/).
  - Git and containers: [GitHub CLI](https://github.com/cli/cli),
    [lazygit](https://github.com/jesseduffield/lazygit),
    [delta](https://github.com/dandavison/delta), and
    [lazydocker](https://github.com/jesseduffield/lazydocker).
  - Files and storage: [bat](https://github.com/sharkdp/bat),
    [ripgrep](https://github.com/BurntSushi/ripgrep),
    [fd](https://github.com/sharkdp/fd),
    [lsplus](https://github.com/seapagan/lsplus),
    [dust](https://github.com/bootandy/dust), and
    [duf](https://github.com/muesli/duf).
  - Shell and development: [Atuin](https://github.com/atuinsh/atuin),
    [Bob](https://github.com/MordechaiHadad/bob),
    [ShellCheck](https://github.com/koalaman/shellcheck),
    [shfmt](https://github.com/mvdan/sh),
    [hyperfine](https://github.com/sharkdp/hyperfine), and
    [Watchexec](https://github.com/watchexec/watchexec).
  - Data and HTTP: [jq](https://github.com/jqlang/jq),
    [yq](https://github.com/mikefarah/yq),
    [xh](https://github.com/ducaale/xh), and
    [Tokei](https://github.com/XAMPPRocky/tokei).

You can enable or disable each module by commenting out the relevant section in
the `comfy-chair.sh` script.

## Security

Please be aware that no attempt has been made to Secure or harden the final
Linux system. This is something you will need to do yourself. Indeed, if your
server is public, I'd advise that a very restrictive firewall blocking
everything IN except for SSH is the first thing you do before even running this
script! No responsibility will be taken for security breaches on systems set up
with this script.

## Current Issues/Bugs

- Shell startup configuration is currently generated for Bash and Zsh only.
  Other shells need manual setup.

## Usage

The simplest way to use this script is to clone into a completely new clean
Operating System.

From the terminal run the following commands:

```bash
git clone https://github.com/seapagan/linux-comfy-chair.git
cd linux-comfy-chair
./comfy-chair.sh
```

### Local Docker test shell

For local testing without modifying your host system, you can start an
ephemeral Ubuntu 24.04 container:

```bash
./docker-shell.sh
```

To record the full container terminal session to `logs/`, run:

```bash
./docker-shell.sh --log
```

The helper builds a local test image, starts a fresh container, mounts this
repository at `~/comfy-chair`, and asks whether to log in with Bash or Zsh. The
container user is created with your host UID and GID, so the bind-mounted
working tree remains writable. The container is removed when you exit, so
installed packages and system changes do not persist.

When `./comfy-chair.sh` runs inside ANY container, it skips the Docker install
module to avoid trying to install Docker inside Docker.

Obviously, you need to have `Docker` installed already on your local machine.

### Default branch has been renamed

In line with many Open-Source projects, I have renamed the Default branch from
`master` to `main`. If you have already cloned or forked this repository, please
run the following commands in your local copies :

```bash
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

Optionally, also remove any tracking references to the old branch name :

```bash
git remote prune origin
```

## Development checks

Run the shell syntax and ShellCheck validation with:

```bash
./scripts/check-shell.sh
```

This requires `shellcheck`; on Ubuntu, install it with:

```bash
sudo apt install shellcheck
```

The check validates the main bootstrapper and follows its sourced modules in
context.

## To-Do

- More robust fall-over on already configured systems. If Rbenv etc are already
  installed then ignore installing that part
- set up configuration keys to determine what modules to install

### Further proposed modules

- Vagrant
- Samba

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
