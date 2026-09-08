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

# fzf: key bindings, completion and previews (colors come from $FZF_DEFAULT_OPTS_FILE)
if command -v fzf &>/dev/null; then
    show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

    export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

    _fzf_comprun() {
      local command=$1
      shift

      case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
      esac
    }

    source <(fzf --zsh)
fi

# eza reads its theme from $EZA_CONFIG_DIR/theme.yml (rendered for the active theme)
if command -v eza &>/dev/null; then
    export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
fi
