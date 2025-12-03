#!/usr/bin/env bash

PARSE_SCRIPT="$HOME/.config/hypr/scripts/_parse_binds.sh"
VARS="$HOME/.config/hypr/vars.conf"

# import colours
while IFS="=" read -r k v; do
    k=$(echo "$k" | tr -d ' $')
    v=$(echo "$v" | tr -d '" ')
    [[ $k == col* ]] && export "$k=$v"
done < <(grep -E '^[$]col' "$VARS")

: "${colInfo:=rgba(33ccffee)}"

# get parsed binds
menu="$($PARSE_SCRIPT)"

# use wofi
choice=$(echo "$menu" | awk -F '\t' '{print $2 " — " $3 " — " $4 "\t" $4}' \
    | wofi --dmenu --allow-markup --prompt "Search binds")

[[ -z "$choice" ]] && exit 0

cmd=$(echo "$choice" | awk -F '\t' '{print $2}')

hyprctl dispatch exec "$cmd"

hyprctl notify -1 2000 "$colInfo" "Launched" "$cmd"

