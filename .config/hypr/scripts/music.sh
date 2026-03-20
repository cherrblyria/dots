#!/usr/bin/env bash

PLAYERS_PRIORITY=("spotify" "mpd" "chromium" "brave")

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

send_command() {
  if [ -n "$TARGET_PLAYER" ]; then
    playerctl -p "$TARGET_PLAYER" "$1"
  else
    playerctl "$1"
  fi
}

case $1 in
next) send_command "next" ;;
playpause) send_command "play-pause" ;;
previous) send_command "previous" ;;
esac
