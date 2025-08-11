#!/bin/bash

# Get list of available networks
NETWORKS=$(nmcli --fields SSID,SECURITY device wifi list | sed '1d' | sed 's/  */ /g' | sort -u)

# Show network selection menu with rofi (no search bar)
SELECTED=$(echo "$NETWORKS" | rofi -dmenu -i -p "Select Wi-Fi network" \
    -theme-str 'window { width: 15%; }' \
    -theme-str 'mainbox { children: [listview]; }' \
    -theme-str 'listview { lines: 4; }' \
    -theme-str 'element { padding: 8px; }' \
    -theme-str 'element selected { background-color: #5E81AC; }')

# Connect to selected network
if [ -n "$SELECTED" ]; then
    SSID=$(echo "$SELECTED" | awk '{print $1}')
    SECURITY=$(echo "$SELECTED" | awk '{print $2}')
    
    if [ "$SECURITY" == "--" ]; then
        # Open network
        nmcli device wifi connect "$SSID"
    else
        # Secure network, ask for password
        PASS=$(rofi -dmenu -p "Enter password for $SSID" -password \
            -theme-str 'window { width: 20%; }' \
            -theme-str 'mainbox { children: [inputbar]; }' \
            -theme-str 'inputbar { padding: 8px; }')
        nmcli device wifi connect "$SSID" password "$PASS"
    fi
fi
