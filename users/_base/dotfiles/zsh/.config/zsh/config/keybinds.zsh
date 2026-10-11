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
function edit_cmd_line() {
    # 1. Create a secure temporary file
    local tmpfile
    tmpfile=$(mktemp /tmp/bash_edit.XXXXXX.sh)

    # 2. Write the current line to the file
    echo "$BUFFER" > "$tmpfile"

    # 3. Open in NeoVim with your custom command (hiding terminal noise)
    nvim -c "d" -c "FzfLuaSnippets $BUFFER" "$tmpfile"

    # 4. Read the edited file back into the command line buffer
    BUFFER=$(cat "$tmpfile")
    
    # 5. Move the cursor to the end of the new text and clean up
    CURSOR=${#BUFFER}
    rm -f "$tmpfile"
}
zle -N edit_cmd_line
bindkey '^e' edit_cmd_line

# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey '^e' edit-command-line
# zstyle :zle:edit-command-line editor nvim -c "d" -c "FzfLuaSnippets $BUFFER"

function neogit() { nvim -c "Neogit kind=replace" }
zle -N neogit
bindkey "^g" neogit

function neofind() { nvim -c "lua vim.schedule(function() require('fzf-lua').files() end)" }
zle -N neofind
bindkey "^f" neofind

# https://github.com/knqyf263/pet?tab=readme-ov-file#select-snippets-at-the-current-line-like-c-r-recommended
function neosearch() { 
    nvim -c 'lua vim.schedule(function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-/>", true, false, true), "m", false) end)'
}
zle -N neosearch
bindkey '^_' neosearch # ctrl+slash generates the same character code as ctrl-underscore for some reason
