#!/usr/bin/env bash

deldir() {
    [ -d "$1" ] && sudo rm -rf "$1"
}


PACKAGES=(
  "apache"
  "mariadb"
  "mariadb-clients"
  "mariadb-libs"
  "php"
)

# Check for existing installation
INSTALLED=()
EXISTING=false
for pkg in ${PACKAGES[@]}; do
    if pacman -Qi "$pkg" &> /dev/null; then
        INSTALLED+=("$pkg")
        EXISTING=true
        break
    fi
done


if $EXISTING; then

  sudo systemctl stop httpd mariadb php-fpm
  sudo systemctl disable httpd mariadb php-fpm

  deldir /etc/apache2
  deldir /etc/httpd
  deldir /etc/mariadb
  deldir /etc/php*
  deldir /etc/webapps
  deldir /usr/share/webapps/phpMyAdmin
  deldir /var/lib/mariadb
  deldir /var/lib/mysql

  if [ -d /srv/http ]; then
    read -p "DELETE /srv/http (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
      echo "Deleting /srv/http ..."
      sudo rm -rf /srv/http
      sleep 1
    fi
  fi

  sudo pacman -Rnsc --noconfirm php

  sudo pacman -Rnsc --noconfirm "${INSTALLED[@]}"

fi



