# .dotfiles

## Setup

1. Setup temporary alias for accessing the bare dotfiles repository.

```zsh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

2. Clone the dotfiles repository as a bare repository.

```zsh
git clone --bare git@github.com:sdodson99/.dotfiles.git $HOME/.dotfiles
```

3. Force checkout the dotfiles from the `$HOME` directory (Warning: This will override existing dotfiles!).

```zsh
cd ~
dotfiles reset --hard master
```

4. Configure the bare dotfiles repository to hide untracked files.

```zsh
dotfiles config --local status.showUntrackedFiles no
```

## Install

### Brew Packages

1. Ensure Brew is installed.

```zsh
brew -v
```

2. Install Brew packages.

```zsh
brew bundle install
```

