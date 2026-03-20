#!/usr/bin/env bash

pkill rofi || true

cliphist list | eval rofi -dmenu -display-columns 2 -p "clipboard" | cliphist decode | wl-copy
