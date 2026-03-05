#!/usr/bin/env bash

makoctl reload && ~/.config/hypr/scripts/osd.sh "Reloaded" "mako"
hyprctl reload && ~/.config/hypr/scripts/osd.sh "Reloaded" "hyprland"
chmod +x ~/.config/hypr/scripts/*
