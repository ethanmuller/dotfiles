# Here are some handy-dandy aliases
# for both zsh and bash

#[CONFIG]
alias ev='vim ~/.vimrc'
alias ez='vim ~/.zshrc'
alias ea='vim ~/dotfiles/aliases.sh'

#[MISC]
alias c=clear
alias h=history
alias tr='trash'
alias l='ls -lG'
alias gsp='grep -F'
alias m='open -a Marked'

#[TMUX]
alias t=tmux

#[GIT]
alias git=/usr/local/bin/git
alias gp='git push'
alias gu='git pull'
alias gs='git status -sb'
alias gl='git log --graph'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gsh='git show'
alias gk='git checkout'
alias gls='git ls-files'
alias gi='git ignored'
alias gf='git fetch'
alias gclean="git remote prune origin && git branch --merged | grep -v \* | xargs git branch -D"

##[GRUNT]
#alias g='grunt'
#alias gcs='grunt && grunt server' # compile & watch

#[GULP]
alias g='gulp --fatal=off'

#[VIM]
alias v=vim
