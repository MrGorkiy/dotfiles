#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

repo_dir="${DOTFILES_REPO:?DOTFILES_REPO is required}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
managed_root="$config_home/dotfiles"
backup_root="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
backup_used=0

backup_path() {
  local destination="$1"
  local relative="${destination#$HOME/}"
  local backup="$backup_root/$relative"
  run mkdir -p "$(dirname -- "$backup")"
  log "Backing up $destination to $backup"
  run mv "$destination" "$backup"
  backup_used=1
}

link_path() {
  local source="$1" destination="$2"
  local resolved_source
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]] && [[ ! -e "$source" ]] && [[ "$source" == "$managed_root"/* ]]; then
    source="$repo_dir/${source#"$managed_root"/}"
  fi
  resolved_source="$(cd -- "$(dirname -- "$source")" && pwd)/$(basename -- "$source")"

  if [[ -L "$destination" ]] && [[ "$(readlink "$destination")" == "$resolved_source" ]]; then
    log "Already linked: $destination"
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup_path "$destination"
  fi
  run mkdir -p "$(dirname -- "$destination")"
  log "Linking $destination -> $resolved_source"
  run ln -s "$resolved_source" "$destination"
}

copy_local_template_if_missing() {
  local target="$HOME/.zshrc.local"
  if [[ -e "$target" || -L "$target" ]]; then
    log 'Keeping existing ~/.zshrc.local.'
    return
  fi
  log 'Creating an editable ~/.zshrc.local template for machine-specific settings.'
  run cp "$repo_dir/configs/zsh/.zshrc.local.example" "$target"
}

link_path "$repo_dir" "$managed_root"
link_path "$managed_root/configs/zsh/.zshrc" "$HOME/.zshrc"
link_path "$managed_root/configs/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
link_path "$managed_root/configs/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_path "$managed_root/configs/atuin/config.toml" "$config_home/atuin/config.toml"
link_path "$managed_root/configs/bat/config" "$config_home/bat/config"

if [[ "$(uname -s)" == Darwin ]]; then
  link_path "$managed_root/configs/ghostty/config" "$config_home/ghostty/config"
fi

copy_local_template_if_missing

managed_git_config="$managed_root/configs/git/gitconfig"
if command_exists git; then
  if ! git config --global --get-all include.path 2>/dev/null | grep -Fxq "$managed_git_config"; then
    log "Adding Git include: $managed_git_config"
    run git config --global --add include.path "$managed_git_config"
  else
    log 'Git include already configured.'
  fi
else
  warn 'Git is not installed; add the Git include after package installation.'
fi

if (( backup_used )); then
  log "Backups created in: $backup_root"
  log 'Review the old .zshrc there and copy only personal exports/functions to ~/.zshrc.local.'
fi
