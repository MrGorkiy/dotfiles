#!/usr/bin/env bash
# Shared helpers for installer scripts. This file is sourced, not run directly.
set -euo pipefail

log() { printf '[dotfiles] %s\n' "$*"; }
warn() { printf '[dotfiles] Warning: %s\n' "$*" >&2; }

run() {
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

command_exists() { command -v "$1" >/dev/null 2>&1; }

clone_if_missing() {
  local url="$1" destination="$2"
  if [[ -d "$destination/.git" ]]; then
    log "Already present: $destination"
    return
  fi
  if [[ -e "$destination" ]]; then
    warn "Not replacing existing path: $destination"
    return
  fi
  run git clone --depth=1 "$url" "$destination"
}

install_shell_plugins() {
  local zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"

  if [[ ! -d "$zsh_dir/.git" ]]; then
    log 'Installing Oh My Zsh without changing the default shell or .zshrc.'
    run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$zsh_dir"
  fi

  clone_if_missing https://github.com/romkatv/powerlevel10k.git "$zsh_dir/custom/themes/powerlevel10k"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_dir/custom/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_dir/custom/plugins/zsh-syntax-highlighting"
  clone_if_missing https://github.com/zsh-users/zsh-history-substring-search.git "$zsh_dir/custom/plugins/zsh-history-substring-search"
  clone_if_missing https://github.com/Aloxaf/fzf-tab.git "$zsh_dir/custom/plugins/fzf-tab"
}
