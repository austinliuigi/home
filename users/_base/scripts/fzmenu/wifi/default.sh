#!/usr/bin/env bash

option="$(echo -e "Connect\nDisconnect\nForget" | fzf --no-clear)"

if [ -z $option ]; then
    exit 0
fi

case "$option" in
    "Connect")
        eval "${HOME}/scripts/fzmenu/wifi/connect_async.sh"
        ;;
    "Disconnect")
        iwctl station wlan0 disconnect
        notify-send --urgency=normal --icon="$HOME/.cache/txn/icons/wifi-none.png" "WiFi" "Disconnected"
        ;;
    "Forget")
        eval "${HOME}/scripts/fzmenu/wifi/forget.sh"
        ;;
esac
