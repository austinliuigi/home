#!/usr/bin/env bash

iwctl station wlan0 scan
known_networks="$(iwctl known-networks list)"


function exit_if_error() {
    if [ "$?" != 0 ]; then
        echo "$1"
        exit
    fi
}


scan="❮Scan❯"
refresh="❮Refresh❯"
sep="·"
function collect_networks() {
    network_dump="$(iwctl station wlan0 get-networks \
    | tail -n +5 \
    | sed -e "s:\[1;30m::g" \
          -e "s:\*\x1b.*:\*:g" \
          -e "s:\x1b::g" \
          -e "s:\[0m::g" \
          -e "s:\[1;90m>::g")"


    echo "$scan"
    echo "$refresh"

    network_entries=""
    while IFS= read -r line; do
        # strength="$(echo "$line" | awk '{print $NF}' | grep -o "*" | wc -l)"
        strength="$(echo "$line" | awk '{print $NF}')"
        security="$(echo "$line" | awk '{print $(NF-1)}')"
        network="$(echo "$line" | awk '{for (c=1; c<=NF-3; c++) printf "%s ", $c; printf "%s", $(NF-2)}')"

        if [ "$security" = "open" ] || [ "$(echo "$known_networks" | grep -c "$network")" -gt 0 ]; then
            icon=""
        else
            icon=""
        fi

        echo "$network $sep $strength $sep $icon"

        network_entry="$(echo "$network $sep $strength $sep $icon")"
        network_entries="${network_entries}${network_entry}\n"
    done <<< "$network_dump"
    # echo -e "$network_entries" | column --separator="$sep" --output-separator="$sep" -t
}

while [ true ]; do
    selection="$(collect_networks | fuzzel --dmenu --prompt="network: ")"
    exit_if_error "cancelled"

    network="$(echo $selection | awk -F " $sep " '{ print $1 }')"

    case "$network" in
        "$scan")
            iwctl station wlan0 scan
            ;;
        "$refresh")
            continue
            ;;
        *)
            break
            ;;
    esac
done

strength="$(echo "$network_dump" | grep "$network" | awk '{print $NF}' | grep -o "*" | wc -l)"

function notify() {
    if [ "$?" -eq 0 ]; then
        if [ "$strength" -ge 4 ]; then
            icon="$HOME/.cache/txn/icons/wifi-strong.png"
        elif [ "$strength" -ge 2 ]; then
            icon="$HOME/.cache/txn/icons/wifi-ok.png"
        else
            icon="$HOME/.cache/txn/icons/wifi-weak.png"
        fi
        notify-send --urgency=normal --icon="$icon" "WiFi" "Successfully connected to $network"
    else
        icon="$HOME/.cache/txn/icons/wifi-none.png"
        notify-send --urgency=normal --icon="$icon" "WiFi" "Failed to connect to $network"
    fi
}

if [ "$(echo "$known_networks" | grep -c "$network")" -gt 0 ]; then
    iwctl station wlan0 connect "$network" || true
    notify
else
    iwctl station wlan0 connect "$network" --passphrase "$(fuzzel --dmenu --prompt="passphrase: ")"
    notify
fi
