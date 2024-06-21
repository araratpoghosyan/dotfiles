# oh-my-zsh configurations
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    docker
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Do not upgrade homebrew on every install (MacOS specific)
export HOMEBREW_NO_AUTO_UPDATE=1
