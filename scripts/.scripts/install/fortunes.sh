#!/bin/sh

# aur packages:
PACKAGES="
clairvoyant-git
adv
rfortune
sprog-fortune
fortune-mod-parks-and-recreation
fortune-mod-oblique-strategies
fortune-mod-cybersuntzu
fortune-mod-canada-nctr
fortune-mod-leftism-git
fortune-mod-lemons-git
fortune-mod-question-answer-jokes
fortune-mod-anti-jokes-git
fortune-mod-hyakunin-isshu
fortune-mod-wisdom-fr
fortune-mod-dhammapada
fortune-mod-hitchhiker
fortune-mod-irk-git
fortune-mod-anarchism
fotd
fortune-mod-yiddish
fortune-mod-limericks
fortune-mod-futurama
fortune-mod-confucius
fortune-mod-calvin
fortune-mod-vimtips
fortunate
"

for pkg in $PACKAGES; do
  if ! pacman -Qi "$pkg" &> /dev/null; then
    echo "Installing $pkg..."
    sudo yay -S --noconfirm "$pkg"
  else 
    echo "$pkg is already installed."
  fi
done
