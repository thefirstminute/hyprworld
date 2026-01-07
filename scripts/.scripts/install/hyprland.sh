#!/bin/bash

PACKAGES="
hyprland
hyprpaper
hyprlock
hypridle
kitty
waybar
rofi
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
qt5-wayland
qt6-wayland
wl-clipboard
grim
slurp
swappy
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg"
  else
    echo "$pkg is already installed."
  fi
done

