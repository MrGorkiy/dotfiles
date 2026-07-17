# Oh My Zsh owns compinit; do not call compinit again in local settings.
typeset -g DOTFILES_SSH_SESSION=0
[[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]] && DOTFILES_SSH_SESSION=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
)

# fzf-tab redraws the command line, so it remains local-only. The other
# interactive Zsh widgets are safe on macOS and SSH with Ghostty compatibility
# mode, keeping history and suggestions consistent across machines.
if (( ! DOTFILES_SSH_SESSION )); then
  plugins+=(fzf-tab)
fi
plugins+=(zsh-autosuggestions zsh-syntax-highlighting)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
