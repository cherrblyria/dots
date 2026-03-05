#!/usr/bin/env bash

if [[ "$1" == "--bar" ]]; then
  value="$2"
  title="$3"
  notify-send -a "osd" -h "int:value:$value" -h "string:x-canonical-private-synchronous:osd" "$title" ": $value%"
else
  title="$1"
  body="$2"
  notify-send -a "osd" -h "string:x-canonical-private-synchronous:osd" "$title" ": $body"
fi
