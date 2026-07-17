# Oh My Zsh owns compinit; do not call compinit again in local settings.
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
)

# fzf-tab redraws the whole command line. Standard Zsh completion is more
# reliable inside SSH, especially before a remote terminal database is fixed.
if [[ -z "${SSH_CONNECTION:-}" && -z "${SSH_TTY:-}" ]]; then
  plugins+=(fzf-tab)
fi

plugins+=(zsh-autosuggestions zsh-syntax-highlighting)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
