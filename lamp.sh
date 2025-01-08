#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update -y

# Install essential packages
echo "Installing essential packages..."
sudo apt install -y curl wget unzip vim apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-xml php-mbstring php-curl php-zip php-gd php-bcmath php-json php-imagick

# Start and enable Apache2 service
echo "Starting Apache2 service..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Install and configure MySQL
echo "Configuring MySQL..."
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ntf12345';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Create PHP info file to check PHP configuration
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Install phpMyAdmin and configure Apache2 to serve it
echo "Installing phpMyAdmin..."
sudo apt install -y phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Configure Apache2 to allow .htaccess files
echo "Configuring Apache2..."
sudo nano /etc/apache2/apache2.conf <<EOF
<Directory /var/www/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF

# Set appropriate ownership and permissions
echo "Setting permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo find /var/www/html -type f -exec chmod 644 {} \;

# Modify Apache2 default site configuration to allow .htaccess
echo "Modifying Apache2 site configuration..."
sudo nano /etc/apache2/sites-available/000-default.conf <<EOF
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF

# Enable the Apache2 site and rewrite module
echo "Enabling site and rewrite module..."
sudo a2ensite 000-default.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Install Composer
echo "Installing Composer..."
sudo apt install -y curl php-cli php-mbstring unzip
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Check Composer version
echo "Composer version:"
composer --version

echo "Setup completed successfully!"
