#!/usr/bin/env bash

pkill wmenu || true

cliphist list | eval wmenu "$(cat "$HOME"/.config/wmenu)" -p "Clipboard" | cliphist decode | wl-copy
