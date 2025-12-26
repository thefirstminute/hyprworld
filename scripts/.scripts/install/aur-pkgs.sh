#!/bin/sh

# aur packages:
PACKAGES="
bambustudio-bin
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done
