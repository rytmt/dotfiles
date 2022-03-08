# select file
peco-file() {
    [ -z "$LBUFFER" ] && return
    local bufferpath="$(printf $LBUFFER | awk '{print $NF}' | sed 's/\/$//g')"
    if [[ "${bufferpath}" =~ "^/.*" ]]; then
        local fullpath="${bufferpath}"
    else
        local fullpath="${PWD}/${bufferpath}"
    fi
    if [ -d "${fullpath}" ]; then
        local filepath="$(ls -1a --file-type "$fullpath" 2>/dev/null | peco --prompt 'FILE>')"
    else
        local filepath="$(ls -1a --file-type 2>/dev/null | peco --prompt 'FILE>')"
    fi
    [ -z "$filepath" ] && return
    BUFFER="$LBUFFER$filepath"
    CURSOR=$#BUFFER
}
peco-file-recursive() {
    if type fdfind; then
        local filepath="$(fdfind . -t f -H -E .git -E .vscode-server 2>/dev/null | peco --prompt 'FILE_RECURSIVE>')"
    else
        local filepath="$(find . -type f 2>/dev/null | grep -vF '.git' | peco --prompt 'FILE_RECURSIVE>')"
    fi
    [ -z "$filepath" ] && return
    BUFFER="$LBUFFER$filepath"
    CURSOR=$#BUFFER
}
zle -N peco-file
zle -N peco-file-recursive
#bindkey '^[f' peco-file
bindkey '^f' peco-file-recursive


# select command history
peco-command-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
                 eval $tac | \
                 peco --query "$LBUFFER" --prompt 'COMMAND_HISTORY>')
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-command-history
bindkey '^r' peco-command-history


# select directory history
autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi
function peco-directory-history () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco --prompt 'DIRECTORY_HISTORY>')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-directory-history
bindkey '^[r' peco-directory-history


# general usage
function peco-buffer() {
    BUFFER=$(eval ${BUFFER} | peco)
    CURSOR=0
}
zle -N peco-buffer
bindkey "^[p" peco-buffer
