# Arcanist Manager

## Installation

To install or update arcanist manager, you can use the install script using cURL:

```sh
curl -o- https://raw.githubusercontent.com/chazcb/arcanist-manager/master/install.sh | bash
```

or Wget:

```sh
wget -qO- https://raw.githubusercontent.com/chazcb/arcanist-manager/master/install.sh | bash
```

<sub>The script clones the arcanist-manager repository to `~/.arcanist-manager` and adds the source line to your profile (`~/.bash_profile`, `~/.zshrc`, `~/.profile`, or `~/.bashrc`).</sub>

```sh
export ARCANIST_MANAGER_DIR="$HOME/.arcanist-manager"
[ -s "$ARCANIST_MANAGER_DIR/arcanist-manager.sh" ] && . "$ARCANIST_MANAGER_DIR/arcanist-manager.sh" # This loads arcanist
```

### Verify installation

To verify that arcanist-manager has been installed, do:

```sh
command -v arc
```

which should output 'arc'.

### Manual install

For manual install create a folder somewhere in your filesystem with the `arcanist-manager.sh` file inside it. I put mine in `~/.arcanist-manager`.

Or if you have `git` installed (requires git v1.5.5+):

1. clone this repo
1. check out the latest version
1. activate arcanist-manager by sourcing it from your shell

```sh
export ARCANIST_MANAGER_DIR="$HOME/.arcanist-manager" && (
  git clone https://github.com/chazcb/arcanist-manager.git "$ARCANIST_MANAGER_DIR"
  cd "$ARCANIST_MANAGER_DIR"
  git checkout master
) && . "$ARCANIST_MANAGER_DIR/nvm.sh"
```

Add these lines to your `~/.bashrc`, `~/.profile`, or `~/.zshrc` file to have it automatically sourced upon login:
(you may have to add to more than one of the above files)

```sh
export ARCANIST_MANAGER_DIR="$HOME/.arcanist-manager"
[ -s "$NVM_DIR/arcanist-manager.sh" ] && . "$NVM_DIR/arcanist-manager.sh" # This loads arcanist-manager
```

### Manual upgrade

For manual upgrade with `git` (requires git v1.5.5+):

1. change to the `$ARCANIST_MANAGER_DIR`
1. pull down the latest changes
1. check out the latest version
1. activate the new version

```sh
(
  cd "$ARCANIST_MANAGER_DIR"
  git fetch origin
  git checkout master
) && . "$ARCANIST_MANAGER_DIR/arcanist-manager.sh"
```

## Usage

To upgrade to the latest version of arcanist:

```sh
arcanist-manager update
```

To build build `.arclint` and `.arcconfig` within a project

```sh
arcanist-manager project init
```

## Thanks

To creationix/nvm for providing inspiration for arcanist-manager. I've pulled some parts of NVM's README and install scripts wholesale. For that reason, portions of this package are MIT licensed copyright of Tim Caswell and Jordan Harband.

## License

arcanist-manager is released under the MIT license.

Copyright (C) 2016 Charles Covey-Brandt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
