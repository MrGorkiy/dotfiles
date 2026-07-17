# Compact Powerlevel10k profile: one line, no right-aligned status bar.
# The host is shown on SSH but hidden on the local Mac.
typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=false
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=48
typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=true
typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=''

# A failed command is signalled by a red prompt character instead of a wide
# right-side status segment.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=cyan
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=red
