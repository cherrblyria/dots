#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

PLAYERS_PRIORITY=("spotify" "mpd" "chrome" "chromium" "brave")

get_active_player() {
  all_players=$(playerctl -l 2>/dev/null)

  for target in "${PLAYERS_PRIORITY[@]}"; do
    matched_player=$(echo "$all_players" | grep -i "$target" | head -n 1)

    if [ -n "$matched_player" ]; then
      echo "$matched_player"
      return 0
    fi
  done
}

TARGET_PLAYER=$(get_active_player)

get_now_playing() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" metadata --format "{{ title }}"
  else
    echo "No active player found"
  fi
}

send_command() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" "$1"
  else
    playerctl "$1"
  fi
}

get_volume() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" volume 2>/dev/null
  else
    playerctl volume 2>/dev/null
  fi
}

set_volume() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" volume "$1"
  else
    playerctl volume "$1"
  fi
}

get_status() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" status 2>/dev/null
  else
    playerctl status 2>/dev/null
  fi
}

case $1 in
next)
  send_command "next"
  sleep 0.2
  "$SCRIPT_DIR"/osd.sh "Next Track" "$(get_now_playing)"
  ;;

playpause)
  send_command "play-pause"
  sleep 0.2
  if [ "$(get_status)" = "Playing" ]; then
    "$SCRIPT_DIR"/osd.sh "Music" "$(get_now_playing)"
  else
    "$SCRIPT_DIR"/osd.sh "Music" "Paused"
  fi
  ;;

previous)
  send_command "previous"
  sleep 0.2
  "$SCRIPT_DIR"/osd.sh "Previous Track" "$(get_now_playing)"
  ;;

volup)
  current=$(get_volume)
  if [ -n "$current" ]; then
    new=$(awk "BEGIN { v = $current + 0.05; if (v > 1) v = 1; printf \"%.2f\", v }")
    set_volume "$new"
  fi
  "$SCRIPT_DIR"/osd.sh --bar "$(get_volume | awk '{printf "%d", $1 * 100}')" "Media Volume"
  ;;

voldown)
  current=$(get_volume)
  if [ -n "$current" ]; then
    new=$(awk "BEGIN { v = $current - 0.05; if (v < 0) v = 0; printf \"%.2f\", v }")
    set_volume "$new"
  fi
  "$SCRIPT_DIR"/osd.sh --bar "$(get_volume | awk '{printf "%d", $1 * 100}')" "Media Volume"
  ;;
esac
