#!/usr/bin/env bash

CURRENT_TIME=$(date +"%H:%M")

notify-send -a "clock" -h "string:x-canonical-private-synchronous:osd" -t 5000 "It's $CURRENT_TIME now!"
