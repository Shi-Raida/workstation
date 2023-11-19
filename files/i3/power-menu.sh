#!/bin/bash

MAP="  Lock screen,i3lock-fancy
  Log out,i3-msg exit
⏾  Suspend,i3lock-fancy & systemctl suspend
  Hibernate,i3lock-fancy & systemctl hibernate
  Reboot,systemctl reboot
  Shut down,systemctl poweroff -i"

selection=$(echo "$MAP" \
    | cut -d ',' -f 1 \
    | rofi -dmenu -p "Power menu " -l 6 -no-custom -i -m -1 -theme-str 'window {width: env(WIDTH, 60ch);}' \
    | head -n 1)

if [ -n "$selection" ]; then
    echo "$MAP" \
        | grep "$selection" \
        | cut -d ',' -f 2 \
        | head -n 1 \
        | xargs -i --no-run-if-empty /bin/bash -c "{}"
fi

exit 0
