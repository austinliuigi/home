#!/usr/bin/env bash

iwctl station wlan0 scan

option="$(echo -e "Connect\nDisconnect\nForget" | rofi -dmenu -p "option")"
exit_if_error "cancelled"

case "$option" in
    "Connect")
        eval "${HOME}/.local/share/rofi/scripts/wifi/connect.sh"
        ;;
    "Disconnect")
        iwctl station wlan0 disconnect
        notify-send --urgency=normal --icon="$HOME/.cache/tin/icons/wifi-none.png" "WiFi" "Disconnected"
        ;;
    "Forget")
        eval "${HOME}/.local/share/rofi/scripts/wifi/forget.sh"
        ;;
esac
