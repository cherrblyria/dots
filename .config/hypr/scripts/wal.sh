#!/usr/bin/env bash

function yc() {
  tmp=$(mktemp -t "yazi-chooser.XXXXXX")
  yazi "$@" --chooser-file="$tmp"
  if [ -s "$tmp" ]; then
    cat "$tmp"
    rm -f -- "$tmp"
  fi
}

LINK_PATH="$HOME"/.config/hypr/wal
WAL_PATH="$HOME/Pictures/Wallpapers"

if [[ -n $1 ]]; then
  if [ "$1" == "random" ]; then
    SELECTED="$(find "${WAL_PATH}" -type f | shuf -n 1)"
  fi
else
  SELECTED="$(yc "${WAL_PATH}")"
fi

if [ "$(readlink -f "$LINK_PATH")" != "$(readlink -f "$SELECTED")" ] && [[ -n "$SELECTED" ]]; then
  ln -sf "${SELECTED}" "${LINK_PATH}"
  hyprctl hyprpaper wallpaper ,"${LINK_PATH}"
  exit 0
else
  exit 1
fi
