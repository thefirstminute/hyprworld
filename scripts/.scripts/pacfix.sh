sudo pkill -f pacman

sudo rm /var/lib/pacman/db.lck


df -h

sudo rm -rf /var/cache/pacman/pkg
sudo rm -rf /tmp/*
sudo rm -rf /var/log/*

df -h


sudo pacman -Syy


echo "Do You Want To Update?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) sudo pacman -Syu; break;;
    No ) break;;
  esac
done

