function peco-history-selection() {
    local reverse_cmd
    if [[ $(uname) == "Darwin" ]]; then
        reverse_cmd="tail -r"
    else
        reverse_cmd="tac"
    fi
    BUFFER=$(history -n 1 | eval $reverse_cmd | awk '!a[$0]++' | peco)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
