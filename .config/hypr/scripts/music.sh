#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

_require_player() {
  if ! pgrep -x "$PLAYER" >/dev/null; then
    "$SCRIPT_DIR"/osd.sh "Music" "Player not running"
    exit 1
  fi
}

_pl() {
  playerctl -p "$PLAYER" "$@" 2>/dev/null
}

get_status() {
  _require_player
  _pl status
}
get_now_playing() {
  _require_player
  _pl metadata --format "{{ title }}"
}
get_volume() {
  _require_player
  _pl volume
}
send_command() {
  _require_player
  _pl "$@"
}
set_volume() {
  _require_player
  _pl volume "$1"
}

case $1 in
next)
  send_command next
  sleep 0.2
  "$SCRIPT_DIR"/osd.sh "Next Track" "$(get_now_playing)"
  ;;

playpause)
  send_command play-pause
  sleep 0.2
  if [ "$(get_status)" = "Playing" ]; then
    "$SCRIPT_DIR"/osd.sh "Music" "$(get_now_playing)"
  else
    "$SCRIPT_DIR"/osd.sh "Music" "Paused"
  fi
  ;;

previous)
  send_command previous
  sleep 0.2
  "$SCRIPT_DIR"/osd.sh "Previous Track" "$(get_now_playing)"
  ;;

volup)
  _require_player
  _pl volume 0.05+
  "$SCRIPT_DIR"/osd.sh --bar "$(_pl volume | awk '{printf "%d", $1 * 100}')" "Music Volume"
  ;;

voldown)
  _require_player
  _pl volume 0.05-
  "$SCRIPT_DIR"/osd.sh --bar "$(_pl volume | awk '{printf "%d", $1 * 100}')" "Music Volume"
  ;;
esac
