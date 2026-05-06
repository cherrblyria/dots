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
HISTORY_FILE="$HOME/.cache/wallpaper_history"

function pick_random() {
  # Get all wallpapers, resolve symlinks so paths are consistent
  mapfile -t ALL < <(find -L "${WALLPAPER_PATH}" -type f | sort)

  # Read history (resolved paths)
  mapfile -t HISTORY < <(cat "${HISTORY_FILE}" 2>/dev/null)

  # Filter out wallpapers in history
  CANDIDATES=()
  for w in "${ALL[@]}"; do
    resolved="$(readlink -f "$w")"
    skip=0
    for h in "${HISTORY[@]}"; do
      [[ "$resolved" == "$h" ]] && skip=1 && break
    done
    [[ $skip -eq 0 ]] && CANDIDATES+=("$resolved")
  done

  # If all wallpapers are exhausted (history too big / small library), reset history
  if [[ ${#CANDIDATES[@]} -eq 0 ]]; then
    echo "History exhausted, resetting..." >&2
    >"${HISTORY_FILE}"
    CANDIDATES=("${ALL[@]}")
  fi

  # Pick one randomly
  SELECTED="${CANDIDATES[RANDOM % ${#CANDIDATES[@]}]}"

  # Append to history, keep only last $HISTORY_SIZE entries
  echo "${SELECTED}" >>"${HISTORY_FILE}"
  tail -n "${WALLPAPER_HISTORY_SIZE}" "${HISTORY_FILE}" >"${HISTORY_FILE}.tmp" && mv "${HISTORY_FILE}.tmp" "${HISTORY_FILE}"

  echo "${SELECTED}"
}

if [[ -n $1 ]]; then
  if [ "$1" == "random" ]; then
    SELECTED="$(pick_random)"
    echo "Selected random wallpaper: ${SELECTED}"
  else
    SELECTED=$1
    echo "Selected wallpaper: ${SELECTED}"
  fi
else
  SELECTED="$(yc "${WALLPAPER_PATH}")"

  if [ -z "${SELECTED}" ] || [ ! -f "${SELECTED}" ]; then
    echo "No wallpaper selected or file does not exist."
    exit 0
  fi

  echo "Selected wallpaper: ${SELECTED}"
fi

RESOLVED="$(readlink -f "${SELECTED}")"

notify-send -h string:x-canonical-private-synchronous:wallpaper "Setting wallpaper..." "${RESOLVED}"
ln -sf "${RESOLVED}" "${SYMLINK}"
awww img "${RESOLVED}" --transition-type center --transition-duration 1 --transition-fps 48 --transition-step 90
notify-send -t 1000 -h string:x-canonical-private-synchronous:wallpaper "Wallpaper set" "${RESOLVED}"
