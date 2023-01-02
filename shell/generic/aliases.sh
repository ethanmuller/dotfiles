# --- CONFIG ---
alias ev='vim ~/.vimrc'
alias ez='vim ~/.zshrc'
alias ea='vim ~/github/dotfiles/shell/generic/aliases.sh'

# --- MISC ---
alias c=clear
alias h=history
alias o='open'
alias ssh='TERM=xterm-256color ssh'

# --- TMUX ---
alias t=tmux
alias m=tmuxinator
alias mux=tmuxinator

# --- VIM ---
alias v=nvim

# --- GIT ---
# (Most other git aliases are coming from prezto)
alias cdg='cd "$(git rev-parse --show-toplevel)"'
alias gcb="git rev-parse --abbrev-ref HEAD"
alias gs="git status"
alias gst="git stash"
alias gsh="git show"
alias ga="git add"
# "Git branch history"
alias gbrh="git for-each-ref --sort='-committerdate' --format='%(refname)' refs/heads | sed -e 's-refs/heads/--'"
# Hub aliases
alias gbr="git browse --"
alias gpr="git pull-request"

# --- yarn ---
alias y='yarn'
alias yr='yarn run'
alias ys='yarn start'
alias ysd='yarn start-dev'

# alias for github/hub
# eval "$(hub alias -s)"

# docker
alias d=docker

# alias to love
alias love="/Applications/love.app/Contents/MacOS/love"

# alias to pico8
alias pico8="/Applications/PICO-8.app/Contents/MacOS/pico8"

