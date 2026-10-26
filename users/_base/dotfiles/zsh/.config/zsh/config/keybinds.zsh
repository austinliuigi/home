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

function smart-up-history() {
    local pattern='### CWD$'
    local last_histno=$HISTNO

    while true; do
        # Move up to the next match that starts with the prefix typed so far
        zle history-beginning-search-backward

        # Break loop if we didn't actually move (hit the top of history matches)
        if [[ $HISTNO -eq $last_histno ]]; then
            break
        fi
        last_histno=$HISTNO

        # Break loop if the match does NOT match your exclusion regex
        if [[ ! "$BUFFER" =~ $pattern ]]; then
            CURSOR=${#BUFFER}
            break
        fi
    done
}
zle -N smart-up-history
# bindkey "^[[A" smart-up-history

smart-down-history() {
    local pattern='### CWD$'
    local last_histno=$HISTNO

    while true; do
        zle history-beginning-search-forward

        # Break if we hit the bottom (current command line)
        if [[ $HISTNO -eq $last_histno ]]; then
            break
        fi
        last_histno=$HISTNO

        # Break if the command does NOT match the excluded regex
        if [[ ! "$BUFFER" =~ $pattern ]]; then
            break
        fi
    done
}
zle -N smart-down-history
# bindkey "^[[B" smart-down-history

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
bindkey "^[[39;5" neogit

function neofind() { nvim -c "lua vim.schedule(function() require('fzf-lua').files() end)" }
zle -N neofind
bindkey "^f" neofind

cdf() {
  local dir
  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --exclude .git . "${1:-.}" 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  elif command -v fdfind >/dev/null 2>&1; then
    dir=$(fdfind --type d --hidden --exclude .git . "${1:-.}" 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  else
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  fi

  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi

  # Use subshell expansion to get the absolute PWD of the target dir.
  # This allows the recorded shell history to be reused even from a different
  # working directory.
  # If failed, fallback to the unexpanded path to surface the error to the user.
  # NOTE: Don't use the `:a` modifier as it resolves symlinks like `pwd -P`.
  dir=$(builtin cd -q >/dev/null -- "${dir}" && echo "${PWD}" || echo "${dir}")
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="cd ${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle -N cdf
bindkey "^[[102;6u" cdf

function neogrep() { nvim -c "lua vim.schedule(function() require('fzf-lua').live_grep_native() end)" }
zle -N neogrep
bindkey "^g" neogrep

function neodirgrep() { nvim -c "lua vim.schedule(function() require('config.plugins.configurations.fzf-lua').dirgrep() end)" }
zle -N neodirgrep
bindkey "^[[103;6u" neodirgrep

# https://github.com/knqyf263/pet?tab=readme-ov-file#select-snippets-at-the-current-line-like-c-r-recommended
function neosearch() { 
    nvim -c 'lua vim.schedule(function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-/>", true, false, true), "m", false) end)'
}
zle -N neosearch
bindkey '^_' neosearch # ctrl+slash generates the same character code as ctrl-underscore for some reason
