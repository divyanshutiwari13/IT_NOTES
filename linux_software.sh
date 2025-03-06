#!/bin/bash

set -e  # Agar koi command fail ho to script yahin ruk jaye

# Update package lists
echo "Updating package lists..."
sudo apt update -y && sudo apt upgrade -y

# Install curl, wget, vim, gedit
echo "Installing curl, wget, vim, and gedit..."
sudo apt install -y curl wget vim gedit

# Install VS Code (latest version)
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Install MongoDB 7
echo "Installing MongoDB 7..."
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.gpg] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable --now mongod

# Install MongoDB Compass
echo "Installing MongoDB Compass..."
wget https://downloads.mongodb.com/compass/mongodb-compass_1.42.3_amd64.deb -O mongodb-compass.deb
sudo dpkg -i mongodb-compass.deb || sudo apt --fix-broken install -y
rm -f mongodb-compass.deb

# Install Slack
echo "Installing Slack..."
wget https://downloads.slack-edge.com/releases/linux/4.36.100/prod/x64/slack-desktop-4.36.100-amd64.deb -O slack.deb
sudo dpkg -i slack.deb || sudo apt --fix-broken install -y
rm -f slack.deb

# Install IPTux
echo "Installing IPTux..."
sudo apt install -y iptux

# Auto-Start IPTux on system boot
echo "Setting IPTux to start automatically on system boot..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/iptux.desktop
[Desktop Entry]
Type=Application
Exec=iptux --hidden &
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=IPTux
Comment=Start IPTux on system boot
EOF

# Install NVM and Node.js 22
echo "Installing NVM and Node.js 22..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

export NVM_DIR="$HOME/.nvm"
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
source "$NVM_DIR/nvm.sh"

# Install and use Node.js 22
bash -c "source $HOME/.nvm/nvm.sh && nvm install 22 && nvm use 22 && nvm alias default 22"

# Install FileZilla
echo "Installing FileZilla..."
sudo apt install -y filezilla

# Configure FileZilla to open files in VS Code
echo "Configuring FileZilla to use VS Code..."
mkdir -p ~/.config/filezilla
cat <<EOF > ~/.config/filezilla/filezilla.xml
<?xml version="1.0" encoding="UTF-8"?>
<FileZilla3>
    <Settings>
        <Setting name="Default editor">0</Setting>
        <Setting name="Use system's default editor">0</Setting>
        <Setting name="Custom editor">code</Setting>
    </Settings>
</FileZilla3>
EOF

echo "All installations and configurations are complete!"
