#!/usr/bin/env bash

option="$(echo -e "Connect\nDisconnect\nForget" | fuzzel --dmenu)"

if [ -z $option ]; then
    exit 0
fi

current_script_dir="$(dirname "$(realpath $BASH_SOURCE[0])")"

case "$option" in
    "Connect")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/wifi/connect.sh"
        # eval "${current_script_dir}/connect.sh"
        ;;
    "Disconnect")
        iwctl station wlan0 disconnect
        notify-send --urgency=normal --icon="$HOME/.cache/txn/icons/wifi-none.png" "WiFi" "Disconnected"
        ;;
    "Forget")
        eval "${HOME}/.config/home-manager/users/_base/scripts/menu/wifi/forget.sh"
        # eval "${current_script_dir}/forget.sh"
        ;;
esac
