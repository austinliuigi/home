bind -x '"\e[39;5": nvim -c "Neogit kind=replace"'

bind -x '"\C-f": nvim -c "lua vim.schedule(function() require(\"fzf-lua\").files() end)"'

cdf() {
  local dir
  if command -v fd >/dev/null 2>&1; then
    dir=$(fd --type d --hidden --exclude .git . "${1:-.}" 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  elif command -v fdfind >/dev/null 2>&1; then
    dir=$(fdfind --type d --hidden --exclude .git . "${1:-.}" 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  else
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf --prompt="cd > " --height=40% --reverse)
  fi

  # Return if no directory was selected.
  [[ -z "$dir" ]] && return 0

  # Resolve to an absolute path while preserving symlinks.
  dir=$(builtin cd -- "$dir" 2>/dev/null && printf '%s\n' "$PWD") || {
    printf 'cdf: cannot access directory: %s\n' "$dir" >&2
    return 1
  }

  # Change directory in the current shell.
  printf 'cd -- %q' "$(builtin unset CDPATH && builtin cd -- "$dir" && builtin pwd)"
}
bind -m emacs-standard '"\C-z": vi-editing-mode'
bind -m vi-command '"\C-z": emacs-editing-mode'
bind -m vi-insert '"\C-z": emacs-editing-mode'

# we insert a space which is later deleted so that \C-y doesn't error if there
# is nothing to paste, and vi mode can be re-entered successfully
bind -m emacs-standard '"\e[102;6u": "\C-e \C-u`cdf`\C-m\C-y\C-?"'
bind -m vi-command '"\e[102;6u": "\C-z\e[102;6u\C-z"'
bind -m vi-insert '"\e[102;6u": "\C-z\e[102;6u\C-z"'

bind -x '"\C-g": nvim -c "lua vim.schedule(function() require(\"fzf-lua\").live_grep_native() end)"'

bind -x '"\e[103;6u": nvim -c "lua vim.schedule(function() require(\"config.plugins.configurations.fzf-lua\").dirgrep() end)"'

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
