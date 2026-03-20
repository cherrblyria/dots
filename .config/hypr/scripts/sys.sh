#!/usr/bin/env bash

pkill rofi || true

case "$(printf "kill\nkillall\nzzz\nreboot\nshutdown" | rofi -dmenu -config "$HOME"/.config/rofi/compact.rasi -p "system")" in
kill)
  ps -u "$USER" -o pid,comm,%cpu,%mem |
    eval wmenu "${FLAG}" -p "Kill" |
    awk '{print $1}' |
    xargs -r kill
  ;;
killall)
  ps -u "$USER" -o pid,comm,%cpu,%mem |
    eval wmenu "${FLAG}" -p "Kill" |
    awk '{print $2}' |
    xargs -r pkill
  ;;
zzz)
  systemctl suspend
  ;;
reboot)
  systemctl reboot
  ;;
shutdown)
  shutdown now
  ;;
esac
