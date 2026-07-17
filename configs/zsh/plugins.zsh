# Oh My Zsh owns compinit; do not call compinit again in local settings.
typeset -g DOTFILES_SSH_SESSION=0
[[ -n "${SSH_CONNECTION:-}" || -n "${SSH_TTY:-}" ]] && DOTFILES_SSH_SESSION=1

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git history sudo colorize colored-man-pages extract safe-paste
)

# SSH uses a deliberately conservative ZLE setup. It keeps standard Zsh
# completion but avoids prompt and highlighting widgets that can redraw an
# unreliable remote terminal line incorrectly.
if (( ! DOTFILES_SSH_SESSION )); then
  plugins+=(fzf-tab)
  plugins+=(zsh-autosuggestions zsh-syntax-highlighting)
else
  ZSH_THEME=""
fi

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if (( DOTFILES_SSH_SESSION )); then
  PROMPT='%F{yellow}%n@%m%f %F{blue}%~%f %# '
  RPROMPT=''
else
  [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
fi
