#!/usr/bin/env bash

# Load variable mappings from vars.conf
declare -A VARS
while IFS='=' read -r key val; do
    key=$(echo "$key" | sed 's/[[:space:]]//g')
    val=$(echo "$val" | sed 's/[[:space:]]//g; s/"//g')
    [[ -n "$key" && -n "$val" ]] && VARS["$key"]="$val"
done < ~/.config/hypr/vars.conf

# Collect all bindd lines
binds=$(grep -h "^bindd" ~/.config/hypr/keys/*.conf)

formatted=""
while IFS= read -r line; do
    # Example: bindd = $sysMod, Q, Quit Hyprland | meta, exec, exit
    mod=$(echo "$line" | cut -d',' -f1 | sed 's/^bindd = //; s/[[:space:]]//g')
    key=$(echo "$line" | cut -d',' -f2 | xargs)
    desc=$(echo "$line" | cut -d',' -f3 | xargs)
    cmd=$(echo "$line" | cut -d',' -f4- | sed 's/^exec[[:space:]]*//')

    # Expand variable if present
    expanded=${VARS[$mod]}
    [[ -z "$expanded" ]] && expanded="$mod"

    # Cut off meta tags (anything after first pipe in description)
    visible_desc=$(echo "$desc" | cut -d'|' -f1)
    metas=$(echo "$desc" | cut -d'|' -f2-)

    # Build line: "SUPER ALT+Q    Quit Hyprland"
    # Append hidden search fields (command + metas) after a delimiter
    formatted+="$expanded+$key    $visible_desc    || $cmd $metas"$'\n'
done <<< "$binds"

# Strip hidden fields for display, align columns
display=$(echo "$formatted" | sed 's/||.*//' | column -t)

# Launch wofi search (case-insensitive)
selection=$(echo "$display" | wofi --show dmenu --insensitive)

# Recover command by matching selection against full formatted list
cmd=$(echo "$formatted" | grep -F "$selection" | sed 's/.*|| //' | xargs)

if [[ -n "$cmd" ]]; then
    eval "$cmd"
    hyprctl notify -1 3000 "${VARS[$colInfo]:-rgba(33ccffee)}" "Keybind" "Launched: $selection"
fi

