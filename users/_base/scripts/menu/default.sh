#!/usr/bin/env bash

modes="\
apps
symbols
clipboard
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

current_script_dir="$(dirname "$(realpath $BASH_SOURCE[0])")"

case "$mode" in
    "apps")
        fuzzel
        ;;
    "symbols")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/symbols.sh"
        # eval "${current_script_dir}/symbols.sh"
        ;;
    "clipboard")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/clipboard.sh"
        # eval "${current_script_dir}/clipboard.sh"
        ;;
    "wifi")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/wifi/default.sh"
        # eval "${current_script_dir}/wifi/default.sh"
        ;;
    "power")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/power.sh"
        # eval "${current_script_dir}/power.sh"
        ;;
esac
