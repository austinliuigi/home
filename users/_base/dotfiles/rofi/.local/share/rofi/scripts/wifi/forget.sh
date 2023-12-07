#!/usr/bin/env bash

iwctl station wlan0 scan
known_networks="$(iwctl known-networks list)"


function exit_if_error() {
    if [ "$?" == 1 ]; then
        echo "$1"
        exit
    fi
}


known_networks_dump="$(iwctl known-networks list \
    | tail -n +5 \
    | sed -e "s:\[1;30m::g" \
          -e "s:\[0m::g" \
          -e "s:\*\x1b.*:\*:g" \
          -e "s:\x1b::g" \
          -e "s:\[1;90m>::g")"

known_networks=""
while IFS= read -r line; do
    network="$(echo "$line" | awk '{for (c=1; c<=NF-6; c++) printf "%s ", $c; printf "%s\\n", $(NF-5)}')"
    known_networks="$(echo "${known_networks}${network}")"
done <<< "$known_networks_dump"

network="$(echo -e $known_networks | rofi -dmenu -i -p "network")"
exit_if_error "cancelled"

iwctl known-networks "$network" forget
notify-send --urgency=normal --icon="$HOME/.cache/tin/icons/wifi-none.png" "WiFi" "Successfully forgot $network"
