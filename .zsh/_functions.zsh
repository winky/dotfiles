function fzf-history-selection() {
    local reverse_cmd
    if [[ $(uname) == "Darwin" ]]; then
        reverse_cmd="tail -r"
    else
        reverse_cmd="tac"
    fi
    BUFFER=$(history -n 1 | eval $reverse_cmd | awk '!a[$0]++' | fzf --no-sort)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-history-selection
