#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

function yc() {
  tmp=$(mktemp -t "yazi-chooser.XXXXXX")
  yazi "$@" --chooser-file="$tmp"
  if [ -s "$tmp" ]; then
    cat "$tmp"
    rm -f -- "$tmp"
  fi
}

SYMLINK="$HOME/.cache/wallpaper"

if [[ -n $1 ]]; then
  if [ "$1" == "random" ]; then
    CURRENT="$(readlink -f "${SYMLINK}" 2>/dev/null)"
    SELECTED="$(find -L "${WALLPAPER_PATH}" -type f | sort -R | head -n 1)"
    COUNT=$(find -L "${WALLPAPER_PATH}" -type f | wc -l)
    i=0
    while [ "$(readlink -f "${SELECTED}")" = "${CURRENT}" ] && [ $i -lt "$COUNT" ]; do
      SELECTED="$(find -L "${WALLPAPER_PATH}" -type f | sort -R | head -n 1)"
      i=$((i + 1))
    done
    echo Selected random wallpaper: "${SELECTED}"
  else
    SELECTED=$1
    echo Selected wallpaper: "${SELECTED}"
  fi
else
  SELECTED="$(yc "${WALLPAPER_PATH}")"
  echo Selected wallpaper: "${SELECTED}"
fi

RESOLVED="$(readlink -f "${SELECTED}")"

notify-send -h string:x-canonical-private-synchronous:wallpaper "Setting wallpaper..." "${RESOLVED}"
ln -sf "${RESOLVED}" "${SYMLINK}"
awww img "${RESOLVED}" --transition-type center --transition-duration 1 --transition-fps 48 --transition-step 90
notify-send -t 1000 -h string:x-canonical-private-synchronous:wallpaper "Wallpaper set" "${RESOLVED}"
