#!/usr/bin/env bash

pkill wmenu || true

FLAG=$(cat "$HOME"/.config/wmenu)

case "$(printf "kill\nkillall\nzzz\nreboot\nshutdown" | eval wmenu "${FLAG}" -l 5 -p "System")" in
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
