#!/bin/bash

# Function to get network info
get_network_info() {
    # Check if ethernet is connected
    if [[ $(cat /sys/class/net/enp2s0/operstate 2>/dev/null) == "up" ]]; then
        INTERFACE="enp2s0"
        ICON=""
        NAME="Ethernet"
    # Check if wifi is connected
    elif [[ $(cat /sys/class/net/wlp3s0/operstate 2>/dev/null) == "up" ]]; then
        INTERFACE="wlp3s0"
        ICON=""
        # Get SSID using nmcli (more reliable than iwgetid)
        NAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
        # Fallback if nmcli fails
        if [ -z "$NAME" ]; then
            NAME=$(iwgetid -r)
        fi
        # Final fallback
        if [ -z "$NAME" ]; then
            NAME="Connected"
        fi
    else
        echo "%{F#BF616A} Disconnected%{F-}"
        return
    fi
    
    # Get network stats
    RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    sleep 0.5
    RX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_BYTES_NEW=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    
    RX_RATE=$((($RX_BYTES_NEW - $RX_BYTES) / 1024))
    TX_RATE=$((($TX_BYTES_NEW - $TX_BYTES) / 1024))
    
    # Output with icon, SSID, and speeds
    echo "$ICON $NAME  ${TX_RATE}KB/s  ${RX_RATE}KB/s"
}

# Output network information
get_network_info
