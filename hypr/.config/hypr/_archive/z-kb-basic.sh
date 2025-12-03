#!/usr/bin/env bash

# Collect all bindd lines
binds=$(grep -h "^bindd" ~/.config/hypr/keys/*.conf)

# Format: bindd = $mod, W, Web Browser, exec, firefox
# Output: "SUPER+W | Web Browser | firefox"

formatted=$(echo "$binds" | sed -E 's/^bindd = ([^,]+), ([^,]+), ([^,]+), exec, (.*)$/\1+\2 | \3 | \4/')

# Add optional hidden keywords (meta tags)
# Example: append "|| spreadsheet" but don’t show in display
# Format: "SUPER+W | Web Browser | firefox || spreadsheet"

# Use fzf for fuzzy search, case-insensitive
selection=$(echo "$formatted" | fzf --ignore-case --delimiter="|" --with-nth=1,2,3)

# Extract command (field 3)
cmd=$(echo "$selection" | awk -F'|' '{print $3}' | xargs)

# Execute
eval "$cmd"
