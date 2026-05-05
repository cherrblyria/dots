rofi_menu() {
  local prompt="$1"
  local width="${2:-19%}" # default 19% if not passed
  shift 2
  local options=("$@")
  local line_count=${#options[@]}
  printf '%s\n' "${options[@]}" | rofi -dmenu \
    -theme-str "listview { lines: ${line_count}; } window { width: ${width}; }" \
    -p "$prompt"
}

rofi_theme() {
  local lines="${1:-10}"
  local width="${2:-19%}"
  echo "listview { lines: ${lines}; } window { width: ${width}; }"
}
