#!/bin/sh
STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
    playerctl metadata --format '󰎈 {{artist}} - {{title}}' 2>/dev/null
else
    echo ""
fi
