#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "--- Installing Apache, MariaDB, PHP, and phpMyAdmin ---"
pacman -S --noconfirm apache mariadb php php-fpm phpmyadmin

# 1. MariaDB Setup
echo "--- Configuring MariaDB ---"
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl enable --now mariadb

echo "RUNNING mariadb-secure-installation..."
echo "Follow the prompts to set a root password and remove test data."
mariadb-secure-installation

# 2. PHP / PHP-FPM Setup
echo "--- Configuring PHP-FPM ---"
sed -i 's/;extension=bz2/extension=bz2/' /etc/php/php.ini
sed -i 's/;extension=iconv/extension=iconv/' /etc/php/php.ini
sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
systemctl enable --now php-fpm

# 3. Apache Configuration
echo "--- Hardening Apache ---"
HTTPD_CONF="/etc/httpd/conf/httpd.conf"

# Listen on localhost only
sed -i 's/^Listen 80/Listen 127.0.0.1:80/' $HTTPD_CONF

# Load required modules for PHP-FPM
sed -i 's/#LoadModule proxy_module/LoadModule proxy_module/' $HTTPD_CONF
sed -i 's/#LoadModule proxy_fcgi_module/LoadModule proxy_fcgi_module/' $HTTPD_CONF

# Hide Server Info
echo "ServerTokens Prod" >> $HTTPD_CONF
echo "ServerSignature Off" >> $HTTPD_CONF

# Link PHP-FPM to Apache
cat <<EOF > /etc/httpd/conf/extra/php-fpm.conf
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"
</FilesMatch>
EOF
echo "Include conf/extra/php-fpm.conf" >> $HTTPD_CONF

# 4. phpMyAdmin Setup
echo "--- Configuring phpMyAdmin ---"
BLOWFISH=$(openssl rand -base64 24)
sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = '$BLOWFISH';/" /etc/webapps/phpmyadmin/config.inc.php

cat <<EOF > /etc/httpd/conf/extra/phpmyadmin.conf
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require local
</Directory>
EOF
echo "Include conf/extra/phpmyadmin.conf" >> $HTTPD_CONF

# Restart Apache
systemctl enable --now httpd
systemctl restart httpd

echo "--------------------------------------------------"
echo "Setup Complete!"
echo "Apache: http://localhost"
echo "phpMyAdmin: http://localhost/phpmyadmin"
echo "Note: MariaDB root login via phpMyAdmin may require a dedicated admin user."
