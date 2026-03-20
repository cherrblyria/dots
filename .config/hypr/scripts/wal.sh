#!/usr/bin/env bash

function yc() {
  tmp=$(mktemp -t "yazi-chooser.XXXXXX")
  yazi "$@" --chooser-file="$tmp"
  if [ -s "$tmp" ]; then
    cat "$tmp"
    rm -f -- "$tmp"
  fi
}

WAL_PATH="$HOME"/.config/hypr/wal
SELECTED="$(yc "$HOME"/Pictures/Wallpapers)"

ln -sf "${SELECTED}" "${WAL_PATH}"
hyprctl hyprpaper wallpaper ,"$HOME/.config/hypr/wal"
