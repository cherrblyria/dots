#!/usr/bin/env bash

makoctl reload
hyprctl reload
pkill -SIGUSR1 kitty
pkill hyprpaper || true && hyprpaper

pidof hypridle || hypridle &
pidof hyprpolkitagent || /usr/lib/hyprpolkitagent/hyprpolkitagent &

chmod +x ~/.config/hypr/scripts/*
