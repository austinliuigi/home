#!/usr/bin/env bash
#
# Insert an empty workspace next to the current workspace

ALL_WS_IDS_REVERSED="$(hyprctl workspaces -j | jq '(sort_by(.id) | reverse).[].id')"
CURRENT_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"

# move each workspace up one (order matters)
for WS_ID in $ALL_WS_IDS_REVERSED; do
    if [ "$WS_ID" -gt "$CURRENT_WS_ID" ]; then
        TARGET_WS_ID="$(($WS_ID + 1))"
        WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')
        echo "$WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$TARGET_WS_ID",address:{}
    fi
done
