#!/bin/bash

crt=$(setxkbmap -query | grep layout | cut -d":" -f2 | xargs)
if [ "$crt" = "us" ]; then
    setxkbmap fr;
else
    setxkbmap us;
fi
