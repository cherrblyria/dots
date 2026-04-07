#!/usr/bin/env bash

makoctl reload
hyprctl reload
pkill -SIGUSR1 kitty
pkill hyprpaper || true && hyprpaper

hyprctl setcursor "$(cat "$HOME"/.config/hypr/configs/_config.conf | grep \$cursor | sed -e "s/^\$cursor = //")"

pidof hypridle || hypridle &
pidof hyprpolkitagent || /usr/lib/hyprpolkitagent/hyprpolkitagent &

chmod +x ~/.config/hypr/scripts/*
