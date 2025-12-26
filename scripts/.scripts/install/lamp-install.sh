#!/bin/bash
clear

set -e  # Exit on error -- is this actually helpful?
MODE=$1

echo
echo "LAMP Stack Installer..."
echo

# List of packages to install/remove
PACKAGES=("apache" "mariadb" "php" "php-apache" "phpmyadmin")

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
    echo
    echo
    echo '---------------------------------------------'
    echo '---------------------------------------------'
    echo "Existing LAMP/phpMyAdmin components detected."
    echo
    echo "WARNING: This will permanently delete data."
    echo "Back up /var/lib/mysql if needed!"
    echo "This will STOP services, UNINSTALL packages"
    echo '---------------------------------------------'
    echo '---------------------------------------------'
    echo
    read -p "Wipe and reinstall? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo "Exiting without changes."
        exit 0
    fi

    sudo systemctl stop httpd mariadb --now
    sudo pacman -Rsc --noconfirm "${INSTALLED[@]}"

    # sudo rm -rf /etc/httpd /etc/php /etc/webapps /var/lib/mysql /usr/share/webapps/phpMyAdmin
    RM_DIRS="/etc/httpd /etc/php /etc/webapps /var/lib/mysql /usr/share/webapps/phpMyAdmin"
    for dir in $RM_DIRS; do
        if [ -d "$dir" ]; then
            echo "Removing $dir..."
            sudo rm -rf "$dir"
        fi
    done

fi

read -p "DELETE /srv/http (y/N): " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
  echo "Deleting /srv/http ..."
  sudo rm -rf /srv/http
  sleep 1
fi
sudo mkdir -p /srv/http

# Make http editable by user:
sudo chown -R "${USER}:http" /srv/http
sudo chmod -R 775 /srv/http

if [ "$MODE" == "uninstall" ]; then
  exit 0
fi


# Update system and install packages
echo "Updating your system and installing required packages..."
sudo pacman -S --noconfirm "${PACKAGES[@]}"

# Initialize MariaDB
echo "Initializing MariaDB database..."
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Start and enable MariaDB
sudo systemctl enable --now mariadb
echo "MariaDB started successfully."

# Secure MariaDB installation (automated equivalent of mysql_secure_installation)
echo "Now, we'll secure your MariaDB installation."
echo "For local development, we'll remove anonymous users, disallow remote root login, remove test database, and set a root password."
read -s -p "Enter a secure password for the MySQL root user: " rootpass
echo
read -s -p "Confirm password: " rootpass_confirm
echo
if [ "$rootpass" != "$rootpass_confirm" ]; then
    echo "Passwords do not match. Aborting."
    exit 1
fi

# Apply security settings
sudo /usr/bin/mariadb -u root <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$rootpass');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

echo "MariaDB secured successfully."

# Configure PHP
echo "Configuring PHP..."
sudo sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
# Add more extensions if needed for phpMyAdmin (e.g., mbstring, gd are usually enabled by deps)

# Configure Apache for PHP
echo "Configuring Apache to work with PHP..."
# Switch to mpm_prefork (required for php-apache)
sudo sed -i 's/^LoadModule mpm_event_module/#LoadModule mpm_event_module/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/^#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/' /etc/httpd/conf/httpd.conf

# Add PHP module if not present
if ! grep -q "LoadModule php_module" /etc/httpd/conf/httpd.conf; then
    echo "LoadModule php_module modules/libphp.so" | sudo tee -a /etc/httpd/conf/httpd.conf
fi
if ! grep -q "AddHandler php-script .php" /etc/httpd/conf/httpd.conf; then
    echo "AddHandler php-script .php" | sudo tee -a /etc/httpd/conf/httpd.conf
fi
if ! grep -q "Include conf/extra/php_module.conf" /etc/httpd/conf/httpd.conf; then
    echo "Include conf/extra/php_module.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# Update DirectoryIndex
sudo sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/httpd/conf/httpd.conf

# Configure phpMyAdmin in Apache
echo "Configuring phpMyAdmin..."
if [ ! -f /etc/httpd/conf/extra/phpmyadmin.conf ]; then
    cat <<EOF | sudo tee /etc/httpd/conf/extra/phpmyadmin.conf
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
EOF
fi
if ! grep -q "Include conf/extra/phpmyadmin.conf" /etc/httpd/conf/httpd.conf; then
    echo "Include conf/extra/phpmyadmin.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# Start and enable Apache
sudo systemctl enable --now httpd
echo "Apache started successfully."

# Create index.php with phpinfo()
echo "Creating a test index.php file with phpinfo()..."
echo "<?php phpinfo(); ?>" | sudo tee /srv/http/index.php

# Final instructions
echo
echo "LAMP installation complete!"
echo "Your local web server is now set up for development."
echo " - Visit http://localhost/ in your browser to see the PHP info page."
echo " - Visit http://localhost/phpmyadmin/ to access phpMyAdmin."
echo "   (Login with username: root and the password you set earlier.)"
echo
echo "If you encounter any issues, check the logs:"
echo " - Apache: sudo journalctl -u httpd"
echo " - MariaDB: sudo journalctl -u mariadb"
echo "For web development, place your projects in /srv/http/"
echo "Happy coding!"
