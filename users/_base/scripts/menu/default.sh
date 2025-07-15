#!/usr/bin/env bash

modes="\
apps
emojis
wifi
power\
"

if [ ! -z "$1" ]; then
  mode="$1"
else
  mode="$(echo -e "$modes" | fuzzel --dmenu)"
  if [ -z $mode ]; then
      exit 0
  fi
fi

current_script_dir="$(dirname "$(realpath $0)")"

case "$mode" in
    "apps")
        fuzzel
        ;;
    "wifi")
        eval "${current_script_dir}/wifi/default.sh"
        ;;
    "power")
        eval "${current_script_dir}/power.sh"
        ;;
esac
