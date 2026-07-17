# Oh My Zsh owns compinit; do not call compinit again in local settings.
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
  fzf-tab zsh-autosuggestions zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
