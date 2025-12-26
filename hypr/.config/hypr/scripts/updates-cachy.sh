#!/usr/bin/env bash

# Count available updates
COUNT=$(checkupdates 2>/dev/null | wc -l)

# Optional: detect security/urgent updates
URGENT=$(checkupdates 2>/dev/null | grep -Ei 'linux|kernel|security' | wc -l)

# Output JSON for Waybar
if [ "$COUNT" -eq 0 ]; then
    echo "{\"text\": \"\", \"tooltip\": \"System up to date\"}"
else
    if [ "$URGENT" -gt 0 ]; then
        echo "{\"text\": \" $COUNT\", \"class\": \"urgent\", \"tooltip\": \"$URGENT urgent updates\"}"
    else
        echo "{\"text\": \" $COUNT\", \"tooltip\": \"$COUNT updates available\"}"
    fi
fi

