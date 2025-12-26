#!/usr/bin/env bash
PACKAGES="
  steam
  cachyos-gaming-meta
  protonup-qt

"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done

# disable conflicting services

