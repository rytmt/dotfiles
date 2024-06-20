# Performance Check
#zmodload zsh/zprof

# --------------------------------------------------
# General
# --------------------------------------------------
ZSH_HOME=~/.zsh
PATH=${PATH}:~/bin:~/.local/bin
export GOPATH="$HOME/go"; PATH=${PATH}:${GOPATH}/bin


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

HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "


# --------------------------------------------------
# Prompt
# --------------------------------------------------
#PROMPT="%F{yellow}ubuntu@wsl2%(!.#.$)%f "
#RPROMPT='[%B%F{blue}%~%f%b] (%?)'
#precmd (){
#    PS1="$($GOPATH/bin/powerline-go -numeric-exit-codes -shell zsh -theme default -hostname-only-if-ssh -trim-ad-domain -error $?)"
#}
source "$ZSH_HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f "${ZSH_HOME}/.p10k.zsh" ]] || source "${ZSH_HOME}/.p10k.zsh"
# starship
#eval "$(starship init zsh)"


# --------------------------------------------------
# Setopt
# --------------------------------------------------
unsetopt AUTO_PARAM_KEYS
setopt MARK_DIRS
setopt LIST_TYPES
setopt NO_BEEP
setopt AUTO_PARAM_SLASH
setopt AUTO_CD
unsetopt complete_aliases
setopt LIST_PACKED
setopt NOTIFY
setopt PRINT_EIGHT_BIT
setopt TRANSIENT_RPROMPT
unsetopt PRINT_EXIT_VALUE
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
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
alias python='python3'
alias p='python'
alias b='cd ..'
alias u='cd -'
alias rmz='rm *:Zone.Identifier'
alias screen='screen -U' # for copy-mode encoding issue
alias fp='readlink -f'


# --------------------------------------------------
# Misc.
# --------------------------------------------------
# pty
export NO_AT_BRIDGE=1
[ -t 0 ] && stty stop undef
[ -t 0 ] && stty start undef

# remove '/', and add '|' from default
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>|'

LS_COLORS=

# terminal logging
logstart(){
    if [ $# -ne 1 ]; then
        echo 'argument error'
    else
        script -fq >(awk '{print strftime("%F %T ") $0}{fflush() }'>>"$1")
    fi
}

# shortcut
work (){
    work_folder="${HOME}/work/$(date '+%Y%m%d')"
    [ -d "${work_folder}" ] || mkdir -p "${work_folder}"
    cd "${work_folder}"
}
home (){
    cd "${HOME}"
}

# show colors
#colors_ansi (){
#    for ((i = 0; i < 16; i++)); do
#        for ((j = 0; j < 16; j++)); do
#            hex=$(($i*16 + $j))
#            printf '\e[38;5;%dm0x%02X\e[m ' $hex $hex
#        done
#        echo "";
#    done
#}

# docker
docker-tags(){
    curl -s "https://registry.hub.docker.com/v2/repositories/library/$1/tags?page_size=1024" | jq -r '.results[].name'
}


# --------------------------------------------------
# Common Functions
# --------------------------------------------------
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


# --------------------------------------------------
# External Config & Plugins
# --------------------------------------------------
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
    ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)
    ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/d)
fi

# fast-syntax-highlighting
#fload "${ZSH_HOME}/F-Sy-H/F-Sy-H.plugin.zsh"

# zsh-autosuggestions
fload "${ZSH_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ $? ] ; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
fi

# dircolor
#fcheck "${HOME}/dircolors-solarized/dircolors.ansi-dark"
#[ $? ] && eval $(dircolors "${HOME}/dircolors-solarized/dircolors.ansi-dark")
fcheck "${HOME}/.dircolors_gruvbox"
[ $? ] && eval $(dircolors "${HOME}/.dircolors_gruvbox")

# source-highlight
#fcheck "/usr/share/source-highlight/src-hilite-lesspipe.sh"
#[ $? ] && hilite (){ sh /usr/share/source-highlight/src-hilite-lesspipe.sh $* }


# --------------------------------------------------
# External Programs
# --------------------------------------------------
# exa
if [ 'type exa >/dev/null 2>&1' ]; then
    alias ll='exa -lah --icons'
    alias llt='exa -lah --icons -s modified'
fi
tree (){
    target="$1"
    if [ "${target}" = "" ]; then
        target="."
    else
        shift
    fi
    exa -lah --icons --color=always -T --ignore-glob='.git' "${target}" $@ | less -i -N -S -M -R
}
dtree (){
    target="$1"
    if [ "${target}" = "" ]; then
        target="."
    else
        shift
    fi
    exa -lah --icons --color=always -T -D --ignore-glob='.git' "${target}" $@ | less -i -N -S -M -R
}

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# for ranger file manager
disable r
# https://github.com/hut/rangerPOWER/blob/master/examples/shell_automatic_cd.sh
r() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}
#r() {
#    if [ -z "$RANGER_LEVEL" ]; then
#        ranger $@
#    else
#        exit
#    fi
#}

# bat
if type bat >/dev/null 2>&1; then
    # general
    export BAT_THEME='Monokai Extended'

    # ranger
    export BAT_STYLE='numbers'

    # man page
    export MANPAGER="sh -c 'col -bx | bat -l man -p --style=numbers --paging=always'"

    # help option
    alias -g -- --help='--help 2>&1 | bat --language=man --style=plain'
fi


# --------------------------------------------------
# GNU Screen
# --------------------------------------------------
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
#screenstart (){
#    # arguments check
#    if [ $# -ne 2 ]; then
#        echo 'Requires two arguments.'
#        return 1
#    fi
#    if [ ! -f "$2" ]; then
#        echo "cannot open $2. No such file."
#        return 1
#    fi
#
#    sname="$1" # set screen session name
#
#    # start screen session
#    if screen -ls | grep -q "${sname}"; then
#        echo "screen session '${sname}' already started"
#        return 1
#    fi
#    screen -d -m -S "${sname}" -t 'workspace'
#
#    # create screen window and execute command from csv
#    x=1
#    cat "$2" | while read line; do
#        # get window name and command string from csv file
#        winname="$(echo -E $line | cut -d ',' -f 1)"
#        cmdstr="$(echo -E $line | cut -d ',' -f 2)"
#
#        # check winname length
#        if [ ${#winname} -le 0 ]; then
#            x=$((x+1))
#            continue
#        fi
#
#        # create new window (using workspace window)
#        screen -S "${sname}" -p 0 -X stuff "screen -t ${winname}\n"
#
#        # execute command (using workspace window)
#        cmdstr=$(echo -E ${cmdstr} | sed 's/'\''/'\''"'\''"'\''/g') # escape single quote
#        screen -S "${sname}" -p 0 -X stuff "screen -p $x -X stuff '${cmdstr}\\\n'\n"
#        x=$((x+1))
#        sleep 1s
#    done
#
#    # remove workspace window
#    screen -S "${sname}" -p 0 -X stuff 'exit\n'
#
#    # attach screen
#    screen -r "${sname}" -p 1
#}
#
#dir_screen_title='~'
#command_screen_title=''
#set_screen_title(){
#    if [ ! "${STY}x" = "x" ]; then
#        if [ ! "${command_screen_title}x" = "x" ]; then
#            command_screen_title="(${command_screen_title})"
#        fi
#        screen -X title "${dir_screen_title} ${command_screen_title}"
#        echo -ne "\e]2;${dir_screen_title} ${command_screen_title}\007"
#    fi
#}
#chpwd_screen_title(){
#    dir_screen_title="$(basename "$(pwd)" | LANG=C sed 's/[\x80-\xFF]/x/g' | cut -c 1-16)"
#    set_screen_title
#}
#preexec_screen_title(){
#    command_screen_title="$(echo $1 | cut -d ' ' -f 1)"
#    set_screen_title
#}
#precmd_screen_title(){
#    command_screen_title=''
#    set_screen_title
#}
#autoload -Uz add-zsh-hook
#add-zsh-hook chpwd chpwd_screen_title
#add-zsh-hook preexec preexec_screen_title
#add-zsh-hook precmd precmd_screen_title
#
#SCREEN_LOGDIR="${HOME}/log/screen"
#screen_logdump(){
#    current_log="$(ls -rt1 ${SCREEN_LOGDIR} | tail -n 1)"
#    cat "${SCREEN_LOGDIR}/${current_log}" > "screen_$(date -Iseconds).log"
#}
#
## for vbell in screen
#vbell(){
#    ps j | awk '{if($10 ~ /^screen/){print $5}}' | while read pts; do
#        echo -en '\a' > "/dev/${pts}"
#    done
#}
#
## for vbell in screen (old)
##getppid(){
##    targetpid="$1"
##    cat "/proc/${targetpid}/status" | grep '^PPid:' | awk '{print $2}'
##}
##getppname(){
##    targetpid="$1"
##    targetppid="$(getppid ${targetpid})"
##    cat "/proc/${targetppid}/status" | grep '^Name' | awk '{print $2}'
##}
##getcpname(){
##    cat /proc/$$/cmdline | rev | cut -d '/' -f 1 | rev
##}
##vbell_cpid="$$"
##vbell(){
##    #targetname="$(getcpname)"
##    targetname="screen"
##
##    ppid="$(getppid ${vbell_cpid})"
##    ppname="$(getppname ${vbell_cpid})"
##    if [ "${ppname}" = "${targetname}" ]; then
##        echo $ppid
##        echo $ppname
##        echo -en "\a" > /proc/${ppid}/fd/1
##        return 0
##    elif [ ${ppid} -eq 1 ]; then
##        echo "Can't find ${targetname} in parent processes"
##        return 1
##    else
##        vbell_cpid="${ppid}"
##        vbell
##    fi
##}



# --------------------------------------------------
# Zellij
# --------------------------------------------------
zellij_pane_name_update() {
    if [[ -n $ZELLIJ ]]; then
        local current_dir=$PWD
        if [[ $current_dir == $HOME ]]; then
            current_dir="~"
        else
            current_dir=${current_dir##*/}
        fi
        command nohup zellij action rename-pane $current_dir >/dev/null 2>&1
    fi
}

zellij_pane_name_update
chpwd_functions+=(zellij_pane_name_update)


# --------------------------------------------------
# for WSL
# --------------------------------------------------
parsed_opts=''
parsed_args=''
parse_init (){
    parsed_opts=''
    parsed_args=''
}
parse_args (){
    parse_init
    opts=''
    args=''
    flg=0
    for n in $(seq 1 $#)
    do
        if echo -E "$1" | grep -qE '^--$'; then
            shift
            flg=1
            continue
        fi

        if [ "${flg}" -eq "0" ]; then
            if echo -E "$1" | grep -qE '^-'; then
                opts="${opts} $1"
                shift
                continue
            fi
        fi
        args="${args} $1"
        shift
    done
    parsed_opts="$(echo -E ${opts} | grep -Eo '\-\w.*\w')"
    parsed_args="$(echo -E ${args} | sed 's/^ *\| *$//')"
}

wcd () {
    cd "$(wslpath -u $1)"
}
e (){
    epath=$1
    [ "x$1" = "x" ] && epath='.'
    explorer.exe "$(wslpath -w ${epath})"
    :
}
wcode (){
    parse_args "$@"
    eval "code ${parsed_opts} $(wslpath -u ${parsed_args})"
}
c (){
    if echo -E "$@" | grep -Eq '[a-zA-Z]:\\'; then
        wcode "$@"
    else
        code "$@"
    fi
}
clip (){
    if [ -p /dev/stdin ]; then
        cat | tee >(iconv -c -t sjis | clip.exe)
    else
        echo "This function only used via pipe."
    fi
}
pwdwin (){
    curdir="$(pwd)"
    wslpath -w "${curdir}" | sed -z 's/\n//g' | clip.exe
    wslpath -w "${curdir}"
}
keyhac_config="$(find /mnt/c/Users/*/AppData/Roaming/Keyhac -name 'config.py' | head -n 1)"
keyhac_dotfiles="${HOME}/dotfiles/win/10/config.py"
keyhac_edit (){
    code "${keyhac_config}"
}
keyhac_show (){
    echo "dump config file (${keyhac_config})"
    echo '-----'
    cat "${keyhac_config}"
}
keyhac_diff (){
    if [ -f "${keyhac_config}" -a -f "${keyhac_dotfiles}" ]; then
        diff -u --color=always "${keyhac_config}" "${keyhac_dotfiles}"
    else
        echo "one or more following config file does not exist."
        echo "${keyhac_config}"
        echo "${keyhac_dotfiles}"
    fi
}
keyhac_local2git (){
    keyhac_diff
    cp "${keyhac_config}" "${keyhac_dotfiles}"
    if [ "$?" -eq "0" ]; then
        echo "copy successed"
    else
        echo "copy failed"
    fi
}
keyhac_git2local (){
    keyhac_diff
    cp "${keyhac_dotfiles}" "${keyhac_config}"
    if [ "$?" -eq "0" ]; then
        echo "copy successed"
    else
        echo "copy failed"
    fi
}
open (){
    if [ -f "$1" ]; then
        fullpath="$(wslpath -w $(readlink -f $1))"
        cmd.exe /c start "${fullpath}" >/dev/null 2>&1
    else
        cmd.exe /c start "$1" >/dev/null 2>&1
    fi
}
ghopen (){
    baseurl="$(git remote -v | grep -F '(fetch)' | grep -Eo 'https://.*\.git' | sed 's|\.git$|/|')"
    reponame="$(echo ${baseurl} | awk -F '/' '{print $(NF-1)}')"
    pathstr="$(pwd | grep -Eo "${reponame}/.*" | sed "s|${reponame}/||")"
    branch="$(git branch --contains | grep '^*' | cut -d ' ' -f 2)"
    fullpath="${baseurl}tree/${branch}/${pathstr}"
    cmd.exe /c start chrome.exe "${fullpath}" >/dev/null 2>&1
}

# compile
#if [ ${HOME}/.zshrc -nt ${HOME}/.zshrc.zwc ]; then
#    zcompile ${HOME}/.zshrc
#fi

# for return code 0
:

# Performance Check
#zprof

