#!/usr/bin/env bash

# Switch to next layout
hyprctl switchxkblayout current next

# Get current layout name
# We look for the first keyboard that has 'main' set to true, or just the first keyboard's layout
layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -n1)

# If main keyboard not found, just get the first one
if [ -z "$layout" ] || [ "$layout" == "null" ]; then
  layout=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap')
fi

~/.config/hypr/scripts/osd.sh "Keyboard Layout" "$layout"
