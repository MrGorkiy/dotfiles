# Shared environment. Keep personal exports in ~/.zshrc.local instead.
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
export EDITOR="${EDITOR:-nano}"
export VISUAL="${VISUAL:-$EDITOR}"
export PATH="$DOTFILES_REPO/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# Docker completion must be on fpath before Oh My Zsh runs compinit.
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
