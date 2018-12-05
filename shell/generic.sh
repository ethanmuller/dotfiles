# Source files
. ~/github/dotfiles/shell/generic/aliases.sh
. ~/github/dotfiles/shell/generic/functions.sh
. ~/github/dotfiles/shell/generic/app-dependent.sh

cdpath=( ~ ~/Library/Application\ Support/pico-8/)

# export PATH="$PATH:/users/ethanmuller/.bin"

export EDITOR=nvim

# Unblock <C-s> in tmux
stty -ixon
