#!/usr/bin/env bash

case "$1" in
up)
  brightnessctl set 10%+
  ;;
down)
  brightnessctl set 10%-
  ;;
lup)
  brightnessctl set 1%+
  ;;
ldown)
  brightnessctl set 1%-
  ;;
esac

# Get current brightness percentage
brightness=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
~/.config/hypr/scripts/osd.sh --bar "$brightness" "Brightness"
