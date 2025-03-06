#!/bin/bash

# Update and upgrade system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Apache
echo "Installing Apache..."
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Install MySQL
echo "Installing MySQL..."
sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql

# Secure MySQL installation (automated)
echo "Securing MySQL..."
sudo mysql_secure_installation <<EOF

y
admin@123
admin@123
y
y
y
y
EOF

# Create MySQL Admin User
echo "Creating MySQL admin user..."
sudo mysql --execute="CREATE USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin@123';"
sudo mysql --execute="GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;"
sudo mysql --execute="FLUSH PRIVILEGES;"

# Install PHP 8.2
echo "Installing PHP 8.2..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.2 libapache2-mod-php8.2 php8.2-mysql php8.2-cli php8.2-curl php8.2-zip php8.2-gd php8.2-mbstring php8.2-xml php8.2-pear php8.2-bcmath unzip

# Restart Apache
echo "Reloading Apache..."
sudo systemctl reload apache2

# Install phpMyAdmin Securely
echo "Installing phpMyAdmin..."
sudo apt install -y phpmyadmin

# Configure Apache for phpMyAdmin
echo "Configuring Apache for phpMyAdmin..."
if [ ! -L "/var/www/html/phpmyadmin" ]; then
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
fi
sudo systemctl reload apache2

# Set Correct Permissions
echo "Setting file permissions..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Configure Apache for Universal DocumentRoot
echo "Configuring Apache DocumentRoot..."
sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL'

# Enable mod_rewrite
echo "Enabling mod_rewrite..."
sudo a2enmod rewrite
sudo systemctl reload apache2

# Verify Installation
echo "Verifying installation..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Prompt to delete phpinfo file (security measure)
read -p "PHP Info file created at /var/www/html/info.php. Do you want to delete it now? (y/n): " delete_info
if [[ "$delete_info" == "y" || "$delete_info" == "Y" ]]; then
    sudo rm -f /var/www/html/info.php
    echo "PHP Info file deleted for security."
else
    echo "Remember to delete /var/www/html/info.php manually for security."
fi

# Installation complete
echo "✅ LAMP Server setup is complete!"
echo "Visit http://your-server-ip/ to check Apache."
echo "Visit http://your-server-ip/phpmyadmin/ to access phpMyAdmin."
