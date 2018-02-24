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
PROMPT="%F{yellow}f%(!.#.$)%f "
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
bindkey '^U' backward-kill-line
bindkey '^G' clear-screen


# --------------------------------------------------
# Alias
# --------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias history='history -f 1'
alias e='emacsclient -nw -a ""'
alias ekill='emacsclient -e "(kill-emacs)"'
alias todo='emacsclient -nw -a "" ~/todo.org'
alias less='less -i -N -S -M -R'
[ -d ~/.mutt/attachment ] && alias mutt='cd ~/.mutt/attachment; mutt'


# --------------------------------------------------
# Others
# --------------------------------------------------
export NO_AT_BRIDGE=1
[ -t 0 ] && stty stop undef
[ -t 0 ] && stty start undef

# remove '/', and add '|' from default
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'

LS_COLORS=
ZSH_HOME=~/.zsh

# common func
gecho() { printf "\e[1;32m$*\e[m\n" }
recho() { printf "\e[1;31m$*\e[m\n" }
fload() {
    if [ -f "$1" ]; then
        . "$1"
        gecho "'$1' loaded"
        return 0
    else
        recho "'$1' doesn't exist"
        return 1
    fi
}
fcheck() {
    if [ -f "$1" ]; then
        gecho "'$1' exists"
        return 0
    else
        recho "'$1' doesn't exist"
        return 1
    fi
}

# user options
fload "${ZSH_HOME}/options.zsh"

# peco
fcheck "/usr/local/bin/peco"
[ $? ] && fload "${ZSH_HOME}/peco.zsh"

# zsh-syntax-highlighting
fload "${ZSH_HOME}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ $? ] ; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor line)
    ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
fi

# default browser
export BROWSER='lynx'


