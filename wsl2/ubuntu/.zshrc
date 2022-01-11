# --------------------------------------------------
# Completion
# --------------------------------------------------
autoload -U compinit promptinit
compinit
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select true
zstyle ':completion:*:default' menu select=1
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
autoload colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

zstyle ':completion:*' verbose yes

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
#PROMPT="%F{yellow}ubuntu@wsl2%(!.#.$)%f "
#RPROMPT='[%B%F{blue}%~%f%b] (%?)'
precmd (){
    PS1="$($HOME/go/bin/powerline-go -numeric-exit-codes -shell zsh -theme solarized-dark16 -hostname-only-if-ssh -trim-ad-domain -error $?)"
}

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
setopt GLOBDOTS


# --------------------------------------------------
# Keybind
# --------------------------------------------------
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^G' clear-screen
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# --------------------------------------------------
# Alias
# --------------------------------------------------
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias history='history -f 1'
alias less='less -i -N -S -M -R'


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
fcheck "/usr/bin/peco"
[ $? ] && fload "${ZSH_HOME}/peco.zsh"

# zsh-syntax-highlighting
fload "${ZSH_HOME}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ $? ] ; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor line)
    ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[globbing]='none'
fi

# dircolor
fcheck "${HOME}/dircolors-solarized/dircolors.ansi-dark"
[ $? ] && eval $(dircolors "${HOME}/dircolors-solarized/dircolors.ansi-dark")

# for screen
cmdsend (){
    if [ $# -lt 2 ]; then
        echo 'Requires two or more arguments.'
        return 1
    fi
    cmdstr="$1"
    shift
    for x in "$@"; do
        # Check if it is numerical value
        expr $x + 1 >/dev/null
        if [ $? -lt 2 ]; then
            screen -p $x -X stuff "$cmdstr\n"
        fi
    done
}
# first arg.: session name
# second arg.: csv file name (first column: window name, second column: command)
screenstart (){
    # arguments check
    if [ $# -ne 2 ]; then
        echo 'Requires two arguments.'
        return 1
    fi
    if [ ! -f "$2" ]; then
        echo "cannot open $2. No such file."
        return 1
    fi

    sname="$1" # set screen session name

    # start screen session
    if screen -ls | grep -q "${sname}"; then
        echo "screen session '${sname}' already started"
        return 1
    fi
    screen -d -m -S "${sname}" -t 'workspace'

    # create screen window and execute command from csv
    x=1
    cat "$2" | while read line; do
        # get window name and command string from csv file
        winname="$(echo $line | cut -d ',' -f 1)"
        cmdstr="$(echo $line | cut -d ',' -f 2)"

        # check winname length
        if [ ${#winname} -le 0 ]; then
            x=$((x+1))
            continue
        fi

        # create new window (using workspace window)
        screen -S "${sname}" -p 0 -X stuff "screen -t ${winname}\n"

        # execute command (using workspace window)
        cmdstr=$(echo ${cmdstr} | sed 's/'\''/'\''"'\''"'\''/g') # escape single quote
        screen -S "${sname}" -p 0 -X stuff "screen -p $x -X stuff '${cmdstr}\\\n'\n"
        x=$((x+1))
        sleep 1s
    done

    # remove workspace window
    screen -S "${sname}" -p 0 -X stuff 'exit\n'

    # attach screen
    screen -r "${sname}" -p 1
}

# source-highlight
fcheck "/usr/share/source-highlight/src-hilite-lesspipe.sh"
[ $? ] && hilite (){ sh /usr/share/source-highlight/src-hilite-lesspipe.sh $* }

# misc
work (){
    work_folder="${HOME}/work/$(date '+%Y%m%d')"
    [ -d "${work_folder}" ] || mkdir -p "${work_folder}"
    cd "${work_folder}"
}

# for wsl2
wcd () {
    cd "$(wslpath -u $1)"
}
e (){
    explorer.exe "$(wslpath -w $1)"
}
wcode (){
    code "$(wslpath -u $1)"
}
