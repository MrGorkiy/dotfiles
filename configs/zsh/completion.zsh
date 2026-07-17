# fzf's standard Ctrl+T, Alt+C and completion bindings where installed.
for fzf_file in \
  /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
  /usr/local/opt/fzf/shell/key-bindings.zsh \
  /usr/share/doc/fzf/examples/key-bindings.zsh; do
  [[ -r "$fzf_file" ]] && source "$fzf_file" && break
done
for fzf_file in \
  /opt/homebrew/opt/fzf/shell/completion.zsh \
  /usr/local/opt/fzf/shell/completion.zsh \
  /usr/share/doc/fzf/examples/completion.zsh; do
  [[ -r "$fzf_file" ]] && source "$fzf_file" && break
done

# Up/down search the current history by the text already typed.
for history_plugin in \
  /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh; do
  [[ -r "$history_plugin" ]] && source "$history_plugin" && break
done
bindkey -e
bindkey '^[[A' history-substring-search-up 2>/dev/null || true
bindkey '^[[B' history-substring-search-down 2>/dev/null || true

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( ! DOTFILES_SSH_SESSION && $+commands[atuin] )) && eval "$(atuin init zsh)"
