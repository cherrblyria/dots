#!/usr/bin/env bash

makoctl reload && ~/.config/hypr/scripts/osd.sh "Reloaded" "mako"
hyprctl reload && ~/.config/hypr/scripts/osd.sh "Reloaded" "hyprland"
pkill hyprpaper || true && hyprpaper && ~/.config/hypr/scripts/osd.sh "Reloaded" "hyprpaper"
chmod +x ~/.config/hypr/scripts/*
