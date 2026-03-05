#!/usr/bin/env bash

notify-send "Active Window" "\
<b>    title:</b> $(hyprctl -j activewindow | jq .title | sed 's/"//g')
<b>    class:</b> $(hyprctl -j activewindow | jq .class | sed 's/"//g')
<b>initTitle:</b> $(hyprctl -j activewindow | jq .initialTitle | sed 's/"//g')
<b>initClass:</b> $(hyprctl -j activewindow | jq .initialClass | sed 's/"//g')
<b> xwayland:</b> $(hyprctl -j activewindow | jq .xwayland | sed 's/"//g')\
"

wl-copy "$(hyprctl -j activewindow | jq .class | sed 's/"//g')"
