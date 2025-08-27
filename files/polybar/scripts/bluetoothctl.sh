#!/bin/bash

bt_connected_icon=""
bt_noconnected_icon="?"
bt_disconnected_icon="x"

bt_is_on() {
    if [ "$(systemctl is-active bluetooth.service)" != "active" ]; then
        false; return
    elif bluetoothctl show | grep -q "Powered: no"; then
        false; return
    else
        true; return
    fi
}

bt_print() {
    bluetoothctl | grep --line-buffered "" | while read -r REPLY; do
        if bt_is_on; then
            devices_paired=$(bluetoothctl devices | grep Device | cut -d" " -f2)
            counter=0

            for device in $devices_paired; do
                device_info=$(bluetoothctl info "$device")

                if echo "$device_info" | grep -q "Connected: yes"; then
                    device_alias=$(echo "$device_info" | grep "Alias" | cut -d" " -f2-)
                    device_battery_percent=$(echo "$device_info" | grep "Battery Percentage" | awk -F'[()]' '{print $2}')
                    if [ -n "$device_battery_percent" ]; then
                        device_alias="$device_alias $device_battery_percent%"
                    fi
                    device_output="%{F#9C9C9C}$bt_connected_icon%{F-} $device_alias"
                    if [ $counter -gt 0 ]; then
                        printf " %s" "$device_output"
                    else
                        printf "%s" "$device_output"
                    fi
                    counter=$((counter + 1))
                fi
            done

            if [ $counter -eq 0 ]; then
                printf "%s" "%{F#FFB86C}$bt_noconnected_icon%{F-}"
            fi
        else
            printf "%s" "%{F#9C9C9C}$bt_disconnected_icon%{F-}"
        fi
        printf '\n'
    done
}

bt_connection() {
    devices_paired=$(bluetoothctl devices | grep Device | cut -d" " -f2)
    echo "$devices_paired" | while read -r line; do
        bluetoothctl "$1" "$line" >> /dev/null
    done
}

bt_select() {
    blueman-manager
}

bt_toggle() {
    if bt_is_on; then
        bt_connection disconnect
        bluetoothctl power off >> /dev/null
    else
        bluetoothctl power on >> /dev/null
        sleep 1
        bt_connection connect
    fi
}

case "$1" in
    --select)
        bt_select
        ;;
    --toggle)
        bt_toggle
        ;;
    *)
        bt_print
        ;;
esac
