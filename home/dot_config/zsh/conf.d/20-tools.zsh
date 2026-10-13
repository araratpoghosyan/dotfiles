# Tool initialization: completions, shell hooks, per-tool environment.
# Aliases belong in 30-aliases.zsh. Theming is handled by each tool's own config,
# rendered by chezmoi for the active theme; nothing here knows which theme is active.

# chezmoi completions
if command -v chezmoi &>/dev/null; then
    eval "$(chezmoi completion zsh)"
fi

# zoxide replaces cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# mise runtime manager
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# fzf: key bindings, completion and previews (colors come from $FZF_DEFAULT_OPTS_FILE).
# Previews degrade to ls/head when eza or bat is missing.
if command -v fzf &>/dev/null; then
    _fzf_tree_preview='eza --tree --color=always {} | head -200'
    command -v eza &>/dev/null || _fzf_tree_preview='ls -la {}'
    _fzf_file_preview="if [ -d {} ]; then $_fzf_tree_preview; else bat -n --color=always --line-range :500 {}; fi"
    command -v bat &>/dev/null || _fzf_file_preview="if [ -d {} ]; then $_fzf_tree_preview; else head -500 {}; fi"

    export FZF_CTRL_T_OPTS="--preview '$_fzf_file_preview'"
    export FZF_ALT_C_OPTS="--preview '$_fzf_tree_preview'"

    # Preview per completion context; the two variables above stay defined for this function
    _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
            cd)           fzf --preview "$_fzf_tree_preview" "$@" ;;
            export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
            ssh)          fzf --preview 'dig {}' "$@" ;;
            *)            fzf --preview "$_fzf_file_preview" "$@" ;;
        esac
    }

    source <(fzf --zsh)
fi

# theme switcher (~/.local/bin/theme): complete the registered theme names
if command -v theme &>/dev/null; then
    _theme() {
        local names
        names="$(theme --list | tr '\n' ' ')"
        _arguments "1:theme:($names)" '--list[print registered theme names]' '--current[print the active theme]'
    }
    compdef _theme theme
fi

# eza reads its theme from $EZA_CONFIG_DIR/theme.yml (rendered for the active theme)
if command -v eza &>/dev/null; then
    export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
fi
