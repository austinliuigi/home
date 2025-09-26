#!/usr/bin/env bash

# credit: https://github.com/marty-oehme/bemoji

db_dir="${XDG_DATA_HOME:-$HOME/.local/share}/scripts/menu/symbols"

unicode_file="${db_dir}/unicode.txt"
emojis_file="${db_dir}/emojis.txt"
math_file="${db_dir}/math.txt"
nerdfont_file="${db_dir}/nerdfont.txt"



# ==================== DOWNLOAD SYMBOLS ====================

# https://www.unicode.org/reports/tr44/#UnicodeData.txt
#   - explains the different semicolon delimited fields in UnicodeData.txt
function dl_unicode() {
  echo "Downloading unicode symbols"
  curl -sSL "https://unicode.org/Public/UCD/latest/ucd/UnicodeData.txt" | grep -ve '<control>' |
  while IFS= read -r line; do
    # echo "$line" >&2

    # Extract the code point from the line (the first part before space)
    codepoint=$(echo "$line" | cut -d';' -f1)
    
    # Convert the code point to the actual Unicode character using printf
    unicode_char=$(printf "\U${codepoint}")
    
    # Replace the code point with the actual Unicode character in the output
    echo "${unicode_char} $(echo "$line" | cut -d';' -f2)" # Print the character followed by its name
  done >"$unicode_file"
}

function dl_emojis() {
  echo "Downloading emojis"
  local emojis
  emojis=$(curl -sSL "https://unicode.org/Public/emoji/latest/emoji-test.txt")
  printf "%s" "$emojis" | sed -ne 's/^.*; fully-qualified.*# \(\S*\) \S* \(.*$\)/\1 \2/gp' >"$emojis_file"
}

function dl_math_symbols() {
  echo "Downloading math symbols"
  curl -sSL "https://unicode.org/Public/math/latest/MathClassEx-15.txt" |
    grep -ve '^#' | cut -d';' -f3,7 | sed -e 's/;/ /' >"$math_file"
}

function dl_nerd_symbols() {
  echo "Downloading nerdfont symbols"
  local nerdfont_symbols_raw nerdfont_symbols
  nerdfont_symbols_raw=$(curl -sSL "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/css/nerd-fonts-generated.css")
  nerdfont_symbols=$(printf "%s" "$nerdfont_symbols_raw" | sed -ne '/\.nf-/p' -e '/\s*[^_]content:/p' | sed -e 'N;s/^\.nf-\(.*\):before.* content: \"\\\(.*\)\";/\\U\2 \1/')
  echo -e "$nerdfont_symbols" > "$nerdfont_file"
}

function dl_all() {
  if [ ! -d $db_dir ]; then
    mkdir -p "$db_dir"
  fi
  dl_unicode
  dl_emojis
  dl_math_symbols
  dl_nerd_symbols

  echo "Downloaded symbols"
}

# force download
if [ "$1" = "download" ]; then
  dl_all
  exit 0
fi

# automatic download
if [ -z "$(ls "${db_dir}/"*.txt 2>/dev/null)" ]; then
  dl_all
fi



# ==================== ACTIONS ====================

function copy() {
  if [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  elif [ -n "$DISPLAY" ] && command -v xsel >/dev/null 2>&1; then
    xsel -b
  else
    msg "No suitable clipboard tool found."
    exit 1
  fi
}

function type() {
  if [ -n "$WAYLAND_DISPLAY" ] && command -v wtype >/dev/null 2>&1; then
    wtype -
  elif [ -n "$DISPLAY" ] && command -v xdotool >/dev/null 2>&1; then
    xdotool type --delay 30 "$(cat -)"
  else
    msg "No suitable typing tool found."
    exit 1
  fi
}

actions="\
󰆏 Copy
 Type
"

action="$(echo -e "$actions" | fuzzel --dmenu)"
if [ -z $action ]; then
    exit 0
fi

case "$action" in
    *Copy*)
        action_fn=copy
        ;;
    *Type*)
        action_fn=type
        ;;
esac

# ==================== MAIN ====================

categories="\
 All
 Nerdfont
󰻐 Unicode
󰙃 Emojis
󰊕 Math
"

category="$(echo -e "$categories" | fuzzel --dmenu)"
if [ -z $category ]; then
    exit 0
fi

case "$category" in
    *All*)
        selection="$(cat "${db_dir}/"*.txt | fuzzel --dmenu)"
        ;;
    *Nerdfont*)
        selection="$(fuzzel --dmenu <$nerdfont_file)"
        ;;
    *Unicode*)
        selection="$(fuzzel --dmenu <$unicode_file)"
        ;;
    *Emojis*)
        selection="$(fuzzel --dmenu <$emojis_file)"
        ;;
    *Math*)
        selection="$(fuzzel --dmenu <$math_file)"
        ;;
esac

symbol="$(echo "$selection" | grep -o '^\S\+' | tr -d '\n')"
echo -n "$symbol" | $action_fn
