# Oh My Zsh owns compinit; do not call compinit again in local settings.
typeset -g DOTFILES_SSH_SESSION=0
[[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]] && DOTFILES_SSH_SESSION=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
)

# SSH keeps standard Zsh completion. The rich input widgets stay local, while
# the Powerlevel10k prompt is safe again with Ghostty compatibility mode.
if (( ! DOTFILES_SSH_SESSION )); then
  plugins+=(fzf-tab)
  plugins+=(zsh-autosuggestions zsh-syntax-highlighting)
fi

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
