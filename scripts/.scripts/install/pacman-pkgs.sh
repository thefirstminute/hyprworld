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
hyprshot
hyprpicker
kitty
lazygit
luarocks
neovim
nodejs
npm
nwg-look
pywal-git
rofi
swappy
thorium-browser-bin
thunar
ttf-hack
ttf-hack-nerd
tumbler
ueberzugpp
unzip
vifm
waybar
wl-clipboard
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
