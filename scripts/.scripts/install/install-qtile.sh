#!/usr/bin/env bash

sudo pacman -S --needed \
    qtile \
    wayland-protocols \
    python-pywayland \
    python-pywlroots \
    python-xkbcommon \
    kitty \
    rofi-wayland \
    swaybg

mkdir -p ~/.config/qtile

# 3. Generate a fresh default config if one doesn't exist
if [ ! -f ~/.config/qtile/config.py ]; then
    cp /usr/share/doc/qtile/default_config.py ~/.config/qtile/config.py
    echo "Default config copied to ~/.config/qtile/config.py"
fi

echo "Installation complete. To start, run: qtile start -b wayland"
