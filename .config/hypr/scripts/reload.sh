#!/usr/bin/env bash

makoctl reload
hyprctl reload
pkill hyprpaper || true && hyprpaper

pidof hypridle || hypridle &
pidof hyprpolkitagent || /usr/lib/hyprpolkitagent/hyprpolkitagent &

chmod +x ~/.config/hypr/scripts/*
