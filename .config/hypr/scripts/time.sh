#!/usr/bin/env bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

CURRENT_TIME=$(date +"%H:%M")

notify-send -a "clock" -h "string:x-canonical-private-synchronous:osd" -t 5000 "It's $CURRENT_TIME now!"
