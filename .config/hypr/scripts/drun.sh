#!/usr/bin/env bash

pkill wmenu || true

shopt -s nullglob

APPS=$(awk -F= '
    FNR == 1 {
        n = split(FILENAME, path, "/")
        base = path[n] # ดึงมาแค่ชื่อไฟล์ เช่น nvim.desktop

        if (seen[base]) { skip = 1; next }

        skip = 0; seen[base] = 1; ignore = 0
        got_name = 0; got_exec = 0; got_term = 0
    }

    skip { next }

    /^\[Desktop Entry\]/ { ignore=0; next }
    /^\[.*\]/ { ignore=1; next }

    ignore == 0 && /^Name=/ && !got_name { name[base]=$2; got_name=1 }
    ignore == 0 && /^Exec=/ && !got_exec {
        cmd=$2; sub(/ %[a-zA-Z]/, "", cmd); exec[base]=cmd; got_exec=1
    }
    ignore == 0 && /^Terminal=/ && !got_term { term[base]=tolower($2); got_term=1 }
    ignore == 0 && /^NoDisplay=true/ { hide[base]=1 }

    END {
        for (b in name) {
            if (name[b] != "" && exec[b] != "" && hide[b] != 1) {
                t = (term[b] == "true") ? "true" : "false"
                print name[b] ":::" exec[b] ":::" t
            }
        }
    }
' /dev/null ~/.local/share/applications/*.desktop /usr/share/applications/*.desktop 2>/dev/null)

CHOICE=$(echo "$APPS" | awk -F':::' '{print $1}' | sort -u | eval wmenu "$(cat "$HOME"/.config/wmenu)" -p "Apps")

[ -z "$CHOICE" ] && exit 0

MATCH=$(echo "$APPS" | awk -F':::' -v name="$CHOICE" '$1 == name {print $0; exit}')
CMD=$(echo "$MATCH" | awk -F':::' '{print $2}')
IS_TERM=$(echo "$MATCH" | awk -F':::' '{print $3}')

TERM_EMU=${TERMINAL:-foot}

if [ "$IS_TERM" = "true" ]; then
  eval "$TERM_EMU -e $CMD" >/dev/null 2>&1 &
  disown
else
  eval "$CMD" >/dev/null 2>&1 &
  disown
fi
