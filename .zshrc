# pnpm
export PNPM_HOME="/Users/sean/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -v

alias vim="nvim"
alias repos="cd ~/Projects/repos"
alias projects="cd ~/Projects"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if [ "$TMUX" = "" ]; then tmux; fi

