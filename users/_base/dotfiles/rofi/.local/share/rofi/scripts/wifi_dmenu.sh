#!/usr/bin/env bash

iwctl station wlan0 scan
known_networks="$(iwctl known-networks list)"


function exit_if_error() {
    if [ "$?" == 1 ]; then
        echo "$1"
        exit
    fi
}


scan="❮Scan❯"
refresh="❮Refresh❯"
function collect_networks() {
    network_dump="$(iwctl station wlan0 get-networks \
    | tail -n +5 \
    | sed -e "s:\[1;30m::g" \
          -e "s:\[0m::g" \
          -e "s:\*\x1b.*:\*:g" \
          -e "s:\x1b::g" \
          -e "s:\[1;90m>::g")"


    network_entries="$(\
        echo -n "$scan";\
        echo -n "\0icon\x1f<span color='white'></span>\n";\
        echo -n "$refresh";\
        echo -n "\0icon\x1f<span color='white'></span>\n";\
    )"
    while IFS= read -r line; do
        strength="$(echo "$line" | awk '{print $NF}' | grep -o "*" | wc -l)"
        security="$(echo "$line" | awk '{print $(NF-1)}')"
        network="$(echo "$line" | awk '{for (c=1; c<=NF-3; c++) printf "%s ", $c; printf "%s", $(NF-2)}')"

        if [ "$security" = "open" ] || [ "$(echo "$known_networks" | grep -c "$network")" -gt 0 ]; then
            icon=""
        else
            icon=""
        fi

        network_entry="$(\
            echo -n "$network";\
            # echo -n "\0display\x1f${strength} ${network}";\ # requires commit dbc1f8d
            echo -n "\0icon\x1f<span color='white'>${icon}</span>\n";\
        )"

        network_entries="${network_entries}${network_entry}"
    done <<< "$network_dump"
}


while [ true ]; do
    collect_networks

    network="$(echo -ne "$network_entries" | rofi -dmenu -show-icons -p "network")"
    exit_if_error "cancelled"

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


if [ "$(echo "$known_networks" | grep -c "$network")" -gt 0 ]; then
    iwctl station wlan0 connect "$network"
else
    iwctl station wlan0 connect "$network" --passphrase "$(rofi -dmenu -p "passphrase for network $network")"
fi
