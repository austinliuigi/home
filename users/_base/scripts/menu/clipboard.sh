#!/usr/bin/env bash

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

actions="\
󰆏 Copy
 Type
 Delete
 Wipe\
"

action="$(echo -e "$actions" | fuzzel --dmenu)"
if [ -z $action ]; then
    exit 0
fi

case "$action" in
    *Copy*)
        # selection="$(cliphist list | fuzzel --dmenu)"
        selection="$(cliphist-rofi-img | fuzzel --dmenu)"
        if [ -n "$selection" ]; then
            echo -n "$selection" | cliphist decode | copy
        fi
        ;;
    *Type*)
        # selection="$(cliphist list | fuzzel --dmenu)"
        selection="$(cliphist-rofi-img | fuzzel --dmenu)"
        if [ -n "$selection" ]; then
            echo -n "$selection" | cliphist decode | type
        fi
        ;;
    *Delete*)
        # selection="$(cliphist list | fuzzel --dmenu)"
        selection="$(cliphist-rofi-img | fuzzel --dmenu)"
        if [ -n "$selection" ]; then
            echo -n "$selection" | cliphist delete
        fi
        ;;
    *Wipe*)
        cliphist wipe
        ;;
esac
