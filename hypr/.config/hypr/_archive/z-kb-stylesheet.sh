#!/usr/bin/env bash

# Config
PAD=19                                   # column where descriptions start
STYLE="${HOME}/.config/wofi/search.css"   # optional; ensures monospace
KEYDIR="${HOME}/.config/hypr/keys"       # where your bindd confs live
VARS="${HOME}/.config/hypr/vars.conf"

# Load Hypr vars into a map
declare -A VARS_MAP
while IFS='=' read -r key val; do
  # keep original key (e.g., $sysMod), strip spaces, quotes in value
  key="$(echo "$key" | sed 's/[[:space:]]//g')"
  val="$(echo "$val" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/"//g')"
  [[ -n "$key" && -n "$val" ]] && VARS_MAP["$key"]="$val"
done < "$VARS"

# Collect bindd lines
mapfile -t BINDLINES < <(grep -hE '^bindd[[:space:]]*=' "$KEYDIR"/*.conf 2>/dev/null)

# Build display lines with hidden searchable metadata via Pango markup
for line in "${BINDLINES[@]}"; do
  # Expected: bindd = $mod, W, Description | meta1 | meta2, exec, command...
  mod="$(echo "$line" | cut -d',' -f1 | sed 's/^bindd[[:space:]]*=[[:space:]]*//; s/[[:space:]]//g')"
  key="$(echo "$line" | cut -d',' -f2 | xargs)"
  desc_raw="$(echo "$line" | cut -d',' -f3 | xargs)"
  cmd_raw="$(echo "$line" | cut -d',' -f4- | sed 's/^[[:space:]]*exec[[:space:]]*//')"

  # Expand modifiers from vars (e.g., $sysMod -> CTRL ALT)
  mods="${VARS_MAP[$mod]}"
  [[ -z "$mods" ]] && mods="$mod"

  # Visible description (strip after first pipe)
  desc_vis="$(echo "$desc_raw" | cut -d'|' -f1)"
  metas="$(echo "$desc_raw" | cut -d'|' -f2-)"   # may be empty

  # Pretty binding forms
  bind_pretty="${mods}+${key}"           # e.g., SUPER ALT+H
  bind_spaced="$(echo "$mods $key")"     # e.g., SUPER ALT H

  # Normalize tokens for matching (lowercase, space and plus variants)
  norm_bind_pretty="$(echo "$bind_pretty" | tr '[:upper:]' '[:lower:]')"
  norm_bind_spaced="$(echo "$bind_spaced" | tr '[:upper:]' '[:lower:]')"
  norm_mods="$(echo "$mods" | tr '[:upper:]' '[:lower:]')"
  norm_key="$(echo "$key" | tr '[:upper:]' '[:lower:]')"

  # Pad binding to fixed column start
  bind_len=${#bind_pretty}
  pad=$(( PAD - bind_len ))
  [[ $pad -lt 1 ]] && pad=1
  spaces="$(printf '%*s' "$pad")"

  # Combine metas and hidden tokens into one string
  # Include: metas, command, multiple binding variants, tokens
  hidden_tokens="$metas $cmd_raw $bind_pretty $bind_spaced $norm_bind_pretty $norm_bind_spaced $norm_mods $norm_key"

  # Final line: visible two columns, with hidden searchable tokens in a zero-size span
  # Note: requires wofi --allow-markup
# Final line: visible two columns, with hidden searchable tokens in a zero-size span
  echo "${bind_pretty}${spaces}${desc_vis}<span size='0'> ${hidden_tokens} </span>"
  done | wofi --show dmenu --insensitive --allow-markup ${STYLE:+--style "$STYLE"} | {
    IFS= read -r selection || exit 0
    vis="$selection"
    # …match vis back to your bindd lines and run the command…
  }


  # Split binding part to reconstruct mods+key
  binding="$(echo "$vis" | awk '{print $1}')"
  # binding is like SUPERALT+H or SUPER+H depending on mods spacing; we only need to find the matching line.

  # Find matching bindd line by binding and description
  # Build a simple grep key: binding's left token (before spaces)
  bind_left="$(echo "$vis" | awk '{print $1}')"
  desc_left="$(echo "$vis" | sed "s/^$bind_left[[:space:]]*//")"

  # Search original bindd lines for the same description and key; then run its command
  for line in "${BINDLINES[@]}"; do
    mod="$(echo "$line" | cut -d',' -f1 | sed 's/^bindd[[:space:]]*=[[:space:]]*//; s/[[:space:]]//g')"
    key="$(echo "$line" | cut -d',' -f2 | xargs)"
    desc_raw="$(echo "$line" | cut -d',' -f3 | xargs)"
    cmd_raw="$(echo "$line" | cut -d',' -f4- | sed 's/^[[:space:]]*exec[[:space:]]*//')"

    mods="${VARS_MAP[$mod]}"
    [[ -z "$mods" ]] && mods="$mod"
    current_bind="${mods}+${key}"
    current_desc="$(echo "$desc_raw" | cut -d'|' -f1)"

    if [[ "$current_bind" == "$bind_left" && "$current_desc" == "$desc_left" ]]; then
      eval "$cmd_raw"
      # use colInfo if defined, else fallback
      col="${VARS_MAP[\$colInfo]}"
      [[ -z "$col" ]] && col="rgba(33ccffee)"
      hyprctl notify -1 3000 "$col" "Keybind" "Launched: $current_bind — $current_desc"
      exit 0
    fi
  done

  # If no match found, do nothing
  exit 0
}

