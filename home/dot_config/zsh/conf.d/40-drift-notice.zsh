# One-line notice when the last drift check (chezmoi-drift-check, run daily by launchd) found
# managed files that differ from the chezmoi source state.
_chezmoi_drift="${XDG_CACHE_HOME:-$HOME/.cache}/chezmoi/drift"
if [[ -s "$_chezmoi_drift" ]]; then
    print -P "%F{yellow}chezmoi:%f $(wc -l <"$_chezmoi_drift" | tr -d ' ') managed file(s) differ from the source. Run \`chezmoi diff\`; list in $_chezmoi_drift"
fi
unset _chezmoi_drift
