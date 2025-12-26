#!/bin/sh

# aur packages:
PACKAGES="
mangowc-git
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    yay -S --noconfirm --needed "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done




PACKAGES="
glibc
wayland
wayland-protocols
libinput
libdrm
libxkbcommon
pixman
git
meson
ninja
libdisplay-info
libliftoff
hwdata
seatd
pcre2
xorg-xwayland
libxcb
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done
