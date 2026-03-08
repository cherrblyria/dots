#!/usr/bin/env bash

pkill wmenu || true

eval wmenu-run "$(cat "$HOME"/.config/wmenu)" -p Command
