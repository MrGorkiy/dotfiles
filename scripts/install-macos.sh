#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

if ! command_exists brew; then
  log 'Homebrew is required and will be installed by its official installer.'
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
    log 'Would run the official Homebrew installer.'
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi

brew_packages=(
  zsh git fzf zoxide eza bat fd ripgrep dust ncdu xh jq yq hyperfine watchexec
  git-delta lazygit gh tmux btop bottom lnav tldr procs atuin glow
  zsh-history-substring-search
)
log 'Installing or updating Homebrew CLI packages.'
run brew install "${brew_packages[@]}"

if [[ "${DOTFILES_SKIP_GHOSTTY:-0}" != "1" ]]; then
  log 'Installing Ghostty and Meslo Nerd Font when missing.'
  run brew install --cask ghostty font-meslo-lg-nerd-font
fi

install_shell_plugins
