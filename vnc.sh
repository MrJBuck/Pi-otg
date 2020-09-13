#!/bin/bash

function alert {
        osascript -e "display notification \"$1\" with title \"Starting VNC Session\" sound name \"Hero\""
}

#Set default values
prev_eth_status="Off"
eth_status="Off"

#Get adapter name
eth_name=`networksetup -listnetworkserviceorder | grep "(Hardware Port: RNDIS" | cut -f6 -d' ' | sed 's/.$//'`


# Determine previous ethernet status
# If file prev_eth_on exists, ethernet was active last time we checked
if [ -f "/var/tmp/prev_eth_on" ]; then
    prev_eth_status="On"
fi

# Check actual current ethernet status
    if ([ "`ifconfig $eth_name | grep "status: active"`" != "" ]); then
        eth_status="On"
    fi

# Determine whether ethernet status changed
if [ "$prev_eth_status" != "$eth_status" ]; then

    if [ "$eth_status" = "On" ]; then
        sleep 5
        alert "Happy Programming."
        /Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer 192.168.150.1:1
    else
        alert "Failed"
    fi
fi

# Update ethernet status
if [ "$eth_status" == "On" ]; then
    touch /var/tmp/prev_eth_on
else
    if [ -f "/var/tmp/prev_eth_on" ]; then
        rm /var/tmp/prev_eth_on
    fi
fi

exit 0
