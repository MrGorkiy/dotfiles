# Small interactive helpers. Standalone cross-platform commands live in bin/.
mkcd() {
  if (( $# != 1 )); then
    printf 'Usage: mkcd <directory>\n' >&2
    return 2
  fi
  mkdir -p -- "$1" && cd -- "$1"
}

terminal-help() {
  local cheatsheet="$DOTFILES_REPO/docs/cheatsheet.md"
  if (( $+commands[glow] )); then
    glow --tui "$cheatsheet"
  elif (( $+commands[bat] )); then
    bat --paging=always --style=plain "$cheatsheet"
  else
    less "$cheatsheet"
  fi
}

alias th='terminal-help'
alias the='${EDITOR:-nano} "$DOTFILES_REPO/docs/cheatsheet.md"'
