#!/usr/bin/env bash

# Only toggle fullscreen if workspace has more than one window
#   - avoids ambiguity of whether or not there are hidden windows
if [ "$(hyprctl activeworkspace | grep -oP '(?<=windows: )\d')" -gt 1 ]; then
    hyprctl dispatch fullscreen 1
fi
