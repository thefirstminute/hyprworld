#!/usr/bin/env bash
set -euo pipefail

echo "=== Arduino-CLI setup check / install ==="

# 1. Check if arduino-cli is installed
if ! command -v arduino-cli >/dev/null 2>&1; then
    echo "arduino-cli not found → installing latest..."
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
else
    echo "arduino-cli already installed ($(arduino-cli version --format=json | grep -o '"Version":"[^"]*"' | cut -d'"' -f4))"
fi

# 2. Ensure basic config exists (idempotent)
CONFIG_FILE="$(arduino-cli config dump --format json 2>/dev/null | grep -o '"ConfigFile":"[^"]*"' | cut -d'"' -f4 || true)"
if [ -z "$CONFIG_FILE" ] || [ ! -f "$CONFIG_FILE" ]; then
    echo "No config found → running arduino-cli config init"
    arduino-cli config init --overwrite --quiet || true
else
    echo "Config already exists at $CONFIG_FILE"
fi

# 3. Always safe to update indexes (very fast if already current)
echo "Updating core index..."
arduino-cli core update-index

# 4. Check/install common AVR core (Uno, Nano, Mega, etc.)
if arduino-cli core list | grep -q "^arduino:avr"; then
    echo "arduino:avr core already installed"
else
    echo "Installing arduino:avr core..."
    arduino-cli core install arduino:avr
fi

sudo pacman -S screen

echo
echo
echo
echo "Setup complete!"
echo
echo
echo
