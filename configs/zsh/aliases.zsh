# Safe interactive aliases. System commands remain available by their own names.

if (( $+commands[eza] )); then
  alias ls='eza --icons=auto --group-directories-first'
  alias la='eza --all --icons=auto --group-directories-first'
  alias ll='eza --long --all --header --git --icons=auto --group-directories-first'
  alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
fi
(( $+commands[bat] )) && alias cat='bat --style=plain'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias reload='exec zsh'

alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --graph --decorate --oneline --all'
(( $+commands[lazygit] )) && alias lg='lazygit'

alias dc='docker compose'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcl='docker compose logs --follow --tail=200'
(( $+commands[kubectl] )) && {
  alias k='kubectl'
  alias kgp='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kctx='kubectl config current-context'
}

(( $+commands[btop] )) && alias bp='btop'
(( $+commands[btm] )) && alias bt='btm'
