# Aliases. Tool-dependent ones are guarded so a missing tool never shadows the original command.

# Quick navigation
alias p='cd $HOME/Projects'

# eza in place of ls
if command -v eza &>/dev/null; then
    alias ls="eza --color=auto --icons=auto"
    alias ll="eza --color=auto --icons=auto --long --header"
    alias la="eza --color=auto --icons=auto --long --header --all"
    alias lt="eza --color=auto --icons=auto --tree"
fi

# neovim in place of vim
if command -v nvim &>/dev/null; then
    alias vim="nvim"
fi

# bat in place of cat
if command -v bat &>/dev/null; then
    alias cat="bat"
fi

# yazi file manager
if command -v yazi &>/dev/null; then
    alias y="yazi"
fi

# lowercase UUID
if command -v uuidgen &>/dev/null; then
    alias uuid="uuidgen | tr \"[:upper:]\" \"[:lower:]\""
fi
