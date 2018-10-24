# Linux 'Comfy Chair'

You know how it is, your own Linux is set up like your favorite comfy chair - everything is close to hand, set up the way you want and there are no surprises. That's why its so annoying to set up a new computer or virtual machine, especially if you are testing stuff (like this script!!) that needs both a certain amount of installed dependencies and a dependable state.

Hence this script. Adapted from my similar scripts to bootstrap a new Raspberry PI system and Windows 10 'WSL', but for pure (Debian Based) Linux. Primary usage has been tested with Ubuntu though it should work with any Debian-based distribution.

**Note that the script is geared towards and tested on _server_ versions more than Desktop ones, though should work for both.**

The script works on a bare newly installed system and provides the following functionality :

* Updated to the latest package versions from Ubuntu / Debian upstream.
* Have the `build-essential` package installed plus all required support libraries to enable the below functionality to work.
* [`Sublime Text 3`][sublime] Editor installed as standard with `Package Control` and a number of useful packages.
* The Latest version of [`Git`][git] installed. A skeleton `.gitconfig` will be set up with a few aliases.
* The [`Ruby`][ruby] scripting language installed via [`Rbenv`][rbenv] with the current version of Rails installed as standard along with several other common gems.
* [`Node.js`][node] both the most recent LTS version and latest stable version via [`NVM`][nvm]. The LTS version is activated by default.
* The [`Python`][python] scripting language both the latest 2.7 and 3.x versions via [`Pyenv`][pyenv]
* Install the latest STABLE [`Perl`][perl] scripting language via [`Perlbrew`][perlbrew] with cpan and cpanm pre-installed and configured. Several PERL modules that make cpan easier are also pre-installed
* Enable resolution of WINS hostnames

**Please read all of this file before starting**

## Usage
The simplest way to use this script is to clone into a completely new Ubuntu environment. 

From the terminal run the following commands:
```
git clone https://github.com/seapagan/linux-comfy-chair.git
cd ubuntu-win-bootstrap
./comfy-chair.sh
```

## Sublime Text 3
The bootstrap script will automatically install Sublime Text 3 with `Package Control` and a number of useful packages. These will properly be installed during the first and second times Sublime Text is opened. I recommend you run Sublime the first time,  wait a few seconds them close (this installs the `Package control` plugin). Open it a second time and the rest of the packages will be installed. It may take a few minutes for the packages to install depending on your internet speed so try not to close the program too soon.

#### Running sublime Text
```bash
$ subl
```

#### Packages installed are :
* All Autocomplete
* Babel
* Color Highlighter
* DocBlockr
* Emmet
* ExportHtml
* Git
* GitGutter
* HexViewer
* Markdown Preview
* MarkdownEditing
* Package Control
* SassBeautify
* SideBarEnhancements
* SublimeCodeIntel
* SublimeLinter
* SublimeREPL
* Terminal
* TrailingSpaces

The list of packages that are installed can be changed or added to by editing the  [Package Control.sublime-settings](support/Package%20Control.sublime-settings)

If you have a License for Sublime Text, copy that from your email into a file `support/License.sublime_license` before running the Bootstrap script, and it wil be properly installed to Sublime for you.

## To-Do

* More robust fall-over on already configured systems. If Rbenv etc are already installed then ignore installing that part

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[sublime]: https://www.sublimetext.com/
[git]: https://git-scm.com
[ruby]: https://www.ruby-lang.org
[rbenv]: https://github.com/rbenv/rbenv
[node]: https://nodejs.org
[nvm]: https://github.com/creationix/nvm
[python]: https://www.python.org/
[pyenv]: https://github.com/pyenv/pyenv
[perl]: https://www.perl.org/
[perlbrew]: https://perlbrew.pl/

