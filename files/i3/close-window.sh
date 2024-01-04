#!/bin/bash

MAP=" Yes,i3-msg kill
 No,"

selection=$(echo "$MAP" \
    | cut -d ',' -f 1 \
    | rofi -dmenu -p "Close the window " -l 2 -no-custom -i -m -2 -theme-str 'window {width: env(WIDTH, 25ch);}' \
    | head -n 1)

if [ -n "$selection" ]; then
    echo "$MAP" \
        | grep "$selection" \
        | cut -d ',' -f 2 \
        | head -n 1 \
        | xargs -i --no-run-if-empty /bin/bash -c "{}"
fi

exit 0
