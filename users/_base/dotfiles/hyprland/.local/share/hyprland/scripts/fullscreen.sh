#!/usr/bin/env bash

if [ "$(hyprctl activeworkspace | grep -oP '(?<=windows: )\d')" -gt 1 ]; then
    hyprctl dispatch fullscreen 1
fi
