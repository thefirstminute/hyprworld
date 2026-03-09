#!/bin/bash

PACKAGES="
arandr
awesome
feh
inotify-tools
libnotify
lxappearance
lxsession
notify-send
pacman-contrib
picom
rofi
xdotool
xorg-server
xorg-xinit
xorg-xrandr
xorg-xsetroot
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg"
  else
    echo "$pkg is already installed."
  fi
done
