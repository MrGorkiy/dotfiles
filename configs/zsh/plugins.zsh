# Oh My Zsh owns compinit; do not call compinit again in local settings.
typeset -g DOTFILES_SSH_SESSION=0
[[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]] && DOTFILES_SSH_SESSION=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
)

# Ghostty compatibility mode keeps this full interactive set stable both
# locally and over SSH. If a remote terminal starts corrupting input again,
# disable only fzf-tab there and keep the rest of the shell experience intact.
plugins+=(fzf-tab zsh-autosuggestions zsh-syntax-highlighting)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
