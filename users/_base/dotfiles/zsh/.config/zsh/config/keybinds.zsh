#===========================================================================================
# Vi Mode
#===========================================================================================
bindkey -v
export KEYTIMEOUT=1

# Update cursor
#-------------------------------------------------------------------------------------------
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

# Fix vi keybinds
#-------------------------------------------------------------------------------------------
bindkey -M viins "^?" backward-delete-char
bindkey -M viins '^h' backward-delete-char
bindkey -M viins '^w' backward-kill-word

bindkey -M visual "D" vi-delete

# Add text objects
#-------------------------------------------------------------------------------------------
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

#===========================================================================================
# Misc
#===========================================================================================
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end # up arrow takes into account what is currently typed
bindkey "^[[B" history-beginning-search-forward-end # down arrow takes into account what is currently typed

# edit current command line in vim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

neogit() { nvim -c "Neogit kind=replace" }
zle -N neogit
bindkey "^g" neogit

# https://github.com/knqyf263/pet?tab=readme-ov-file#select-snippets-at-the-current-line-like-c-r-recommended
function pet-select() {
  BUFFER=$(pet search --raw --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^_' pet-select # ctrl+slash generates the same character code as ctrl-underscore for some reason

# https://github.com/pindexis/marker/blob/ef68f2a26fe479f75bbaf5c30d3cd0fd7fd45a45/bin/marker.sh#L87C1-L96C6
function _pet_move_cursor_to_next_parameter() {
    match="$(echo "$BUFFER" | perl -nle 'print $& if /<.*?>/')"
    if [ ! -z "$match" ]; then
      default="$(echo "$match" | perl -nle 'print $& if /(?<==).*(?=>)/')"
      match_len=${#match}
      default_len=${#default}
      parameter_offset=${#BUFFER%%$match*}

      CURSOR="$((${parameter_offset} + ${default_len}))"
      BUFFER="${BUFFER[1,$parameter_offset]}${default}${BUFFER[$parameter_offset+$match_len+1,-1]}"
    fi        
}
zle -N _pet_move_cursor_to_next_parameter
bindkey '^n' _pet_move_cursor_to_next_parameter 
