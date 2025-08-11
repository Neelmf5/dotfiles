#!/bin/bash

# Power menu options
shutdown=" Shutdown"
reboot=" Reboot"
lock=" Lock"
logout=" Logout"

# Show power menu in rofi (no search bar)
selected_option=$(echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi -dmenu \
    -i \
    -p "Power Menu" \
    -theme-str 'window { width: 15%; }' \
    -theme-str 'mainbox { children: [listview]; }' \
    -theme-str 'listview { lines: 4; }' \
    -theme-str 'element { padding: 8px; }' \
    -theme-str 'element selected { background-color: #5E81AC; }')

# Execute selected option
case $selected_option in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        betterlockscreen -l
        ;;
    $logout)
        # Adjust this command according to your window manager
        bspc quit
        ;;
esac
