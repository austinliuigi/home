### Vi Mode
bindkey -v
export KEYTIMEOUT=1

# change cursor based on vi mode (bar for insert, block otherwise)
zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}

zle -N zle-keymap-select
# change cursor to bar for each new prompt
zle-line-init() {
    echo -ne '\e[5 q'
}
zle -N zle-line-init

# edit current command line in vim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# add text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>'}; do
    bindkey -M $km $c select-bracketed
  done
done

### Bindings
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end # up arrow takes into account what is currently typed
bindkey "^[[B" history-beginning-search-forward-end # down arrow takes into account what is currently typed

