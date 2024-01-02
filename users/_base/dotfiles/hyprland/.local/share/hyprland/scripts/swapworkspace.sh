#!/usr/bin/env bash

# Swaps the active workspace with another workspace
# $1 => the workspace param of the target workspace

# early exit
if [ $# -ne 1 ]; then
  echo "Usage: $0 <workspace_param>"
  exit 1
fi



# get current workspace id
CURRENT_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"

# get target workspace id based on cli arg
hyprctl dispatch workspace "$1"  # switch to target workspace
TARGET_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"

# if didn't switch workspaces
if [ "$TARGET_WS_ID" == "$CURRENT_WS_ID" ]; then
  echo "Invalid workspace parameter"
  exit 1
fi



# save all windows in current workspace
CURRENT_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$CURRENT_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')

# save all windows in target workspace
TARGET_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$TARGET_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')



# move all windows initially from target workspace to current workspace
echo "$TARGET_WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$CURRENT_WS_ID",address:{}

# move all windows from current workspace to target workspace
echo "$CURRENT_WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$TARGET_WS_ID",address:{}
