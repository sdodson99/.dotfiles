# plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# enable zsh vim mode
bindkey -v

# aliases
alias vim="nvim"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if [ -f ~/.zsh/.zshrc ]; then 
    source ~/.zsh/.zshrc
else
    print "INFO: system specific .zshrc not found (~/.zsh/.zshrc)"
fi

if [ "$TMUX" = "" ]; then tmux; fi

