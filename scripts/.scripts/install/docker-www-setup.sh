#!/usr/bin/env bash

sudo pacman -S docker docker-compose
sudo systemctl enable --now docker
# Add yourself to the docker group so you don't need 'sudo' every time
sudo usermod -aG docker $USER

# 1. Create directory structure
mkdir -p ~/dev/www/{public_html,mysql,php}
cd ~/dev/www

# 2. Create the custom PHP Dockerfile (with mysqli and pdo)
cat <<EOF > php/Dockerfile
FROM php:8.2-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli pdo_mysql
EOF

# 3. Create the Orchestration file
cat <<EOF > docker-compose.yml
services:
  web:
    build: ./php
    container_name: lamp_web
    ports:
      - "80:80"
    volumes:
      - ./public_html:/var/www/html
    restart: unless-stopped

  db:
    image: mariadb:latest
    container_name: lamp_db
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: dev_db
    volumes:
      - ./mysql:/var/lib/mysql
    restart: unless-stopped

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: lamp_pma
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
    depends_on:
      - db
EOF

# 4. Create a test file
echo "<?php phpinfo(); ?>" > public_html/info.php
echo "Environment ready in ~/dev/www"
