#!/usr/bin/env bash

case "$1" in
up)
  brightnessctl set 10%+
  ;;
down)
  brightnessctl set 10%-
  ;;
esac

# Get current brightness percentage
brightness=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
~/.config/hypr/scripts/osd.sh --bar "$brightness" "Brightness"
