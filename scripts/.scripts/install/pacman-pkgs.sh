#!/bin/bash
PACKAGES="
brave-bin
curl
filezilla
fortune-mod
freecad
freetube
galculator
git
lazygit
luarocks
neovim
nodejs
npm
nwg-look
pywal-git
rofi
thunar
thorium-browser-bin
ttf-hack
ttf-hack-nerd
tumbler
unzip
vifm
waybar
zsh-autosuggestions
zsh-completions
zsh-syntax-highlighting
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo pacman -S --needed --noconfirm "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done
