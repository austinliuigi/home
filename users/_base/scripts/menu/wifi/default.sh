#!/usr/bin/env bash

option="$(echo -e "Connect\nDisconnect\nForget" | fuzzel --dmenu)"

if [ -z $option ]; then
    exit 0
fi

current_script_dir="$(dirname "$(realpath $0)")"

case "$option" in
    "Connect")
        eval "${current_script_dir}/connect.sh"
        ;;
    "Disconnect")
        iwctl station wlan0 disconnect
        notify-send --urgency=normal --icon="$HOME/.cache/txn/icons/wifi-none.png" "WiFi" "Disconnected"
        ;;
    "Forget")
        eval "${current_script_dir}/forget.sh"
        ;;
esac
