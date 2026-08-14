# https://github.com/knqyf263/pet?tab=readme-ov-file#select-snippets-at-the-current-line-like-c-r-recommended
function pet-select() {
  BUFFER=$(pet search --raw --query "$READLINE_LINE")
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}
bind -x '"\C-_": pet-select'

# https://github.com/pindexis/marker/blob/ef68f2a26fe479f75bbaf5c30d3cd0fd7fd45a45/bin/marker.sh#L112
function _pet_move_cursor_to_next_parameter() {
  match="$(echo "$READLINE_LINE" | perl -nle 'print $& if /<.*?>/')"
  if [ ! -z "$match" ]; then
    default="$(echo "$match" | perl -nle 'print $& if /(?<==).*(?=>)/')"
    match_len=${#match}
    default_len=${#default}

    pre_match=${READLINE_LINE%%$match*}
    parameter_offset=${#pre_match}

    READLINE_POINT="$((${parameter_offset} + ${default_len}))"
    READLINE_LINE="${READLINE_LINE:0:$parameter_offset}${default}${READLINE_LINE:$parameter_offset+$match_len}"
  fi        
}
bind -x '"\C-n": _pet_move_cursor_to_next_parameter'

bind -x '"\C-g": nvim -c "Neogit"'
bind -x '"\C-f": nvim -c "lua vim.schedule(function() require(\"fzf-lua\").files() end)"'
