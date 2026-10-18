bind -x '"\C-g": nvim -c "Neogit"'

bind -x '"\C-f": nvim -c "lua vim.schedule(function() require(\"fzf-lua\").files() end)"'

bind -x '"\e[102;6u": nvim -c "lua vim.schedule(function() require(\"fzf-lua\").live_grep_native() end)"'

bind -x '"\C-_": nvim -c "lua vim.schedule(function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(\"<C-/>\", true, false, true), \"m\", false) end)"'

function edit_cmd_line() {
    # 1. Create a secure temporary file
    local tmpfile
    tmpfile=$(mktemp /tmp/bash_edit.XXXXXX.sh)

    # 2. Write the current line to the file
    echo "$READLINE_LINE" > "$tmpfile"

    # 3. Open in NeoVim with your custom command (hiding terminal noise)
    nvim -c "d" -c "FzfLuaSnippets $READLINE_LINE" "$tmpfile"

    # 4. Read the edited file back into the command line buffer
    READLINE_LINE=$(cat "$tmpfile")
    
    # 5. Move the cursor to the end of the new text and clean up
    READLINE_POINT=${#READLINE_LINE}
    rm -f "$tmpfile"
}

# Bind Ctrl-E to trigger the direct edit function
bind -x '"\C-e": edit_cmd_line'
