#!/bin/bash

# Dependencies: inotify-tools, xdotool, notify-send
# Install with:
# sudo apt-get install inotify-tools xdotool libnotify-bin

WATCH_DIR=${1:-$(pwd)}  # Default to current directory
TIMEOUT=$((5 * 60 * 60))  # 5 hours in seconds
STOP_TIME=$(date -d "+5 hours" +"%I:%M %p")  # Calculate exact stop time

# Prompt user for subdirectories
read -p "Enter subdirectories to monitor (space-separated, or press enter for none): " -a USER_SUBFOLDERS

# Always watch the current directory
WATCH_PATHS=("$WATCH_DIR")

# Add valid subdirectories
for SUB in "${USER_SUBFOLDERS[@]}"; do
    if [ -d "$WATCH_DIR/$SUB" ]; then
        WATCH_PATHS+=("$WATCH_DIR/$SUB")
    else
        echo "Warning: $SUB is not a valid directory, skipping..."
    fi
done

echo "Monitoring: ${WATCH_PATHS[*]}"
echo "Refreshing until: $STOP_TIME"

# Exit if nothing is being watched (shouldn't happen)
if [ ${#WATCH_PATHS[@]} -eq 0 ]; then
    echo "No valid paths to monitor. Exiting."
    exit 1
fi

# Ensure Firefox is running
if ! pgrep "firefox" > /dev/null; then
    echo "Firefox is not running..."
    MOZ_DISABLE_TELEMETRY=1 firefox "localhost" &> /dev/null &
    sleep 3
    while ! pgrep "firefox" > /dev/null; do
        sleep 0.5
        echo "Waiting for Firefox to open..."
    done
fi

FIREFOX_WINDOW_TITLE="Mozilla Firefox"
echo "Refreshing Firefox on changes..."

START_TIME=$(date +%s)
LAST_REFRESH=0
DEBOUNCE_TIME=1  # Prevents rapid refresh spam

# Monitor files (without recursion)
inotifywait -m -e modify,create,delete,move "${WATCH_PATHS[@]}" --format '%w%f' | while read FILE; do
    CURRENT_TIME=$(date +%s)

    # Auto-exit at the exact stop time
    if (( CURRENT_TIME - START_TIME >= TIMEOUT )); then
        echo "Auto-stop: Reached $STOP_TIME."
        notify-send "Firefox Auto-Refresh" "Stopped monitoring at $STOP_TIME."
        exit 0
    fi

    # Prevent excessive refreshes
    if (( CURRENT_TIME - LAST_REFRESH < DEBOUNCE_TIME )); then
        continue
    fi

    echo "Change detected: $FILE"
    xdotool search --name "$FIREFOX_WINDOW_TITLE" key F5
    LAST_REFRESH=$CURRENT_TIME
done


#--------------------------------------------- 

# Tried to minimize impact excluding git and node etc...
# WATCH_DIR=${1:-$(pwd)}
# TIMEOUT=18000  # 5 hours in seconds
# START_TIME=$(date +%s)
# DEBOUNCE_TIME=1  # Seconds to wait before refreshing (prevents rapid F5 spam)
#
# EXCLUDE_PATTERN="(\.git|node_modules|log|cache|tmp|\.swp|\.~)$"
#
# # Check if Firefox is running
# if ! pgrep "firefox" > /dev/null; then
#   echo "Firefox is not running..."
#   LOCAL_HOST_PATH=$(echo "$WATCH_DIR" | sed 's|/var/www/html|localhost|')
#   echo "Opening Firefox to $LOCAL_HOST_PATH"
#   MOZ_DISABLE_TELEMETRY=1 firefox "$LOCAL_HOST_PATH" &> /dev/null &
#   sleep 3
#
#   while ! pgrep "firefox" > /dev/null; do
#     sleep 0.5
#     echo "Waiting for Firefox to open..."
#   done
# fi
#
# FIREFOX_WINDOW_TITLE="Mozilla Firefox"
# echo "Monitoring directory: $WATCH_DIR"
# echo "Refreshing Firefox on changes... (Will auto-stop after 5 hours)"
#
# LAST_REFRESH=0
#
# # Monitor for changes
# inotifywait -m -r -e modify,create,delete,move --exclude "$EXCLUDE_PATTERN" "$WATCH_DIR" --format '%w%f' | while read FILE; do
#     CURRENT_TIME=$(date +%s)
#
#     # Auto-exit after 5 hours
#     if (( CURRENT_TIME - START_TIME >= TIMEOUT )); then
#         echo "Auto-stop: Reached 5-hour limit."
#         notify-send "Firefox Auto-Refresh" "Stopped monitoring after 5 hours."
#         exit 0
#     fi
#
#     # Skip unnecessary refreshes
#     if (( CURRENT_TIME - LAST_REFRESH < DEBOUNCE_TIME )); then
#         continue
#     fi
#
#     echo "Change detected: $FILE"
#     xdotool search --name "$FIREFOX_WINDOW_TITLE" key F5
#     LAST_REFRESH=$CURRENT_TIME
# done

#--------------------------------------------- 

####  This was pretty good, but I think it was sending my computer into a death spiral
#
# # Directory to monitor (current directory by default)
# WATCH_DIR=${1:-$(pwd)}
#
# # check if Firefox is running
# if ! pgrep "firefox"
# then
#   echo "Firefox is not running..."
#   # make localhost path to this directory, if it starts with /var/www/html - and replace /var/www/home with localhost
#   LOCAL_HOST_PATH=$(echo $WATCH_DIR | sed 's|/var/www/html|localhost|')
#
#   echo "Opening Firefox to $LOCAL_HOST_PATH"
#   #error:  firefox $LOCAL_HOST_PATH
#   MOZ_DISABLEtelemetry=1 firefox "$LOCAL_HOST_PATH" &> /dev/null &
#   sleep 3
#
#   # wait for Firefox to open
#   while ! pgrep "firefox"
#   do
#     sleep 0.5
#     echo "Waiting for Firefox to open..."
#   done
#
# fi
#
# # Firefox's window title or partial match (adjust as needed)
# FIREFOX_WINDOW_TITLE="Mozilla Firefox"
#
# echo "Monitoring directory: $WATCH_DIR"
# echo "Refreshing Firefox on changes..."
#
# # Monitor for changes
# inotifywait -m -r -e modify,create,delete,move "$WATCH_DIR" --format '%w%f' | while read FILE
# do
#     echo "Change detected: $FILE"
#     # Refresh Firefox
#     xdotool search --name "$FIREFOX_WINDOW_TITLE" key F5
# done


#--------------------------------------------- 

# this works, but is too basic for my brain
# # Dependencies: inotify-tools, xdotool
# # Install them with:
# # sudo apt-get install inotify-tools xdotool
#
# # Directory to monitor (current directory by default)
# WATCH_DIR=${1:-$(pwd)}
#
# # Firefox's window title or partial match (adjust as needed)
# FIREFOX_WINDOW_TITLE="Mozilla Firefox"
#
# echo "Monitoring directory: $WATCH_DIR"
# echo "Refreshing Firefox on changes..."
#
# # Monitor for changes
# inotifywait -m -r -e modify,create,delete,move "$WATCH_DIR" --format '%w%f' | while read FILE
# do
#     echo "Change detected: $FILE"
#     # Refresh Firefox
#     xdotool search --name "$FIREFOX_WINDOW_TITLE" key F5
# done
