# Here are some handy-dandy aliases
# for both zsh and bash

#[MISC]
alias c=clear
alias h=history
alias psd='open -a /Applications/Adobe\ Photoshop\ CS6/Adobe\ Photoshop\ CS6.app'
alias tr="trash"
alias l="ls -l"
alias gsp="grep -F"

#[GIT]
alias git=/usr/local/git/bin/git
alias gp='git push'
alias gu='git up'
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
alias gbc='git branch --merged | grep -v master | xargs git branch -d'

#[GRUNT]
alias g='grunt'
alias gstart='grunt && grunt watch'
alias gst='gstart'

#[VIM]
alias vim=/Applications/MacVim.app/Contents/MacOS/Vim # use the MacVim binary
