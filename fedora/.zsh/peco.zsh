# select file
peco-file() {
    local filepath="$(ls -1a 2>/dev/null | peco --prompt 'FILE>')"
    [ -z "$filepath" ] && return
    BUFFER="$LBUFFER$filepath"
    CURSOR=$#BUFFER
}
peco-file-recursive() {
    local filepath="$(find . -type f 2>/dev/null | peco --prompt 'FILE_RECURSIVE>')"
    [ -z "$filepath" ] && return
    BUFFER="$LBUFFER$filepath"
    CURSOR=$#BUFFER
}
zle -N peco-file
zle -N peco-file-recursive
bindkey '^f' peco-file
bindkey '^[f' peco-file-recursive


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