# Managed by dotfiles. Machine-specific settings belong in ~/.zshrc.local.

# Keep the P10K instant prompt at the top: it makes new shells noticeably faster.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# :A resolves this file's symlink, so the modules work from any clone location.
typeset -g ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"
typeset -g DOTFILES_REPO="${DOTFILES_REPO:-${ZSH_CONFIG_DIR:h:h}}"

source "$ZSH_CONFIG_DIR/exports.zsh"
source "$ZSH_CONFIG_DIR/plugins.zsh"
source "$ZSH_CONFIG_DIR/completion.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/functions.zsh"

# Never commit secrets, work paths or machine-specific SDK setup. Put them here.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
