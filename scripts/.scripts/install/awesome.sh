#!/usr/bin/env bash

PACKAGES="
arandr
awesome
bluetui
feh
inotify-tools
libnotify
lxappearance
lxsession
nemo
notify-send
pacman-contrib
picom
pulsemixer
pamixer
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
