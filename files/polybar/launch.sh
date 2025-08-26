#!/usr/bin/env bash

# Terminate already running bar instances
killall -p polybar

# Run top bar on all monitors
echo "---" | tee -a /tmp/polybar_top_*.log
if type "xrandr"; then
  monitors=$(xrandr --query | grep " connected" | cut -d" " -f1);
  primary_index=$(xrandr --query | grep " connected" | cut -d" " -f3 | grep -n "primary" | cut -d":" -f1);
  primary_monitor=$(echo $monitors | cut -d" " -f${primary_index});
  for m in $monitors; do
    if [ "$m" = "$primary_monitor" ]; then
      MONITOR=$m polybar top-full 2>&1 | tee -a /tmp/polybar_top_${m}.log & disown
    else
      MONITOR=$m polybar top-light 2>&1 | tee -a /tmp/polybar_top_${m}.log & disown
    fi
  done
else
  polybar top-full 2>&1 | tee -a /tmp/polybar_top_${m}.log & disown
fi

echo "Bars launched..."
