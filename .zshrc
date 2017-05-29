# --------------------------------------------------
# Completion
# --------------------------------------------------
autoload -U compinit promptinit
compinit
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
autoload colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"


# --------------------------------------------------
# History
# --------------------------------------------------
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
PATH=${PATH}:~/bin

HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

# --------------------------------------------------
# Prompt
# --------------------------------------------------
PROMPT="%B%F{green}%(!.#.$)%f%b "
RPROMPT='[%B%F{blue}%~%f%b] (%?)'


# --------------------------------------------------
# Setopt
# --------------------------------------------------
unsetopt AUTO_PARAM_KEYS
setopt MARK_DIRS
setopt LIST_TYPES
setopt NO_BEEP
setopt AUTO_PARAM_SLASH
unsetopt complete_aliases
setopt LIST_PACKED
setopt NOTIFY
setopt PRINT_EIGHT_BIT
setopt TRANSIENT_RPROMPT
unsetopt PRINT_EXIT_VALUE
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_NO_FUNCTIONS
unsetopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt NO_PROMPTCR
unsetopt XTRACE
unsetopt CHASE_LINKS
setopt FUNCTION_ARGZERO
setopt NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS
unsetopt SINGLE_LINE_ZLE
setopt COMPLETE_IN_WORD


# --------------------------------------------------
# Keybind
# --------------------------------------------------
bindkey -e
bindkey "^U" backward-kill-line
bindkey "^G" clear-screen


# --------------------------------------------------
# Alias
# --------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias history='history -f 1'
alias telnet='/usr/bin/telnet'


# --------------------------------------------------
# Others
# --------------------------------------------------
export NO_AT_BRIDGE=1
[ -t 0 ] && stty stop undef
[ -t 0 ] && stty start undef


# --------------------------------------------------
# Plugin
# --------------------------------------------------

# zsh-syntax-highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor line)
    ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
fi

if [ -f ~/.zsh_options ]; then
    . ~/.zsh_options
fi

