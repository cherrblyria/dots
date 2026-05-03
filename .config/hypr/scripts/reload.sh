#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source ~/.config/hypr/_config.sh

pkill -SIGUSR1 kitty
pkill -SIGUSR2 waybar
makoctl reload
hyprctl reload

hyprctl setcursor $CURSOR_THEME $CURSOR_SIZE

chmod +x ~/.config/hypr/scripts/*
