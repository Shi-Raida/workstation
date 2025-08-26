#!/bin/bash

kb_print() {
    setxkbmap -query | grep layout | cut -d":" -f2 | xargs
}


kb_toggle() {
    crt=$(setxkbmap -query | grep layout | cut -d":" -f2 | xargs)
    if [ "$crt" = "us" ]; then
        setxkbmap fr;
    else
        setxkbmap us;
    fi
}


case "$1" in
    --toggle)
        kb_toggle
        ;;
    *)
        kb_print
        ;;
esac
