#!/bin/bash

# Update the system
echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Install Slack
sudo snap install slack

# Install Iptux
sudo snap install iptux

# Install Upwork
echo "Installing Upwork..."
wget https://github.com/upwork/upwork-app/releases/download/v1.0.1/upwork-linux-x64-1.0.1.deb
sudo dpkg -i upwork-linux-x64-1.0.1.deb
sudo apt-get install -f -y  # This will fix any missing dependencies

# Install Visual Studio Code (VSCode)
echo "Installing Visual Studio Code..."
sudo apt update
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code -y

# Install FileZilla
echo "Installing FileZilla..."
sudo apt install filezilla -y

# Install Python 3
echo "Installing Python 3..."
sudo apt install python3 python3-pip -y

# Install OpenJDK 17
echo "Installing OpenJDK 17..."
sudo apt install openjdk-17-jdk -y

# Install Node.js version 22 (using NodeSource repository)
echo "Installing Node.js version 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install nodejs -y

# Enable Slack, Iptux, and Upwork to start automatically at boot

# Create autostart for Slack
echo "Creating autostart for Slack..."
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/slack.desktop
[Desktop Entry]
Name=Slack
Exec=slack
Type=Application
X-GNOME-Autostart-enabled=true
EOF

# Create autostart for Iptux
echo "Creating autostart for Iptux..."
cat <<EOF > ~/.config/autostart/iptux.desktop
[Desktop Entry]
Name=Iptux
Exec=iptux
Type=Application
X-GNOME-Autostart-enabled=true
EOF

# Create autostart for Upwork
echo "Creating autostart for Upwork..."
cat <<EOF > ~/.config/autostart/upwork.desktop
[Desktop Entry]
Name=Upwork
Exec=upwork
Type=Application
X-GNOME-Autostart-enabled=true
EOF

# Print completion message
echo "All software installed and autostart setup completed!"
echo "Slack, Iptux, and Upwork will now automatically start on boot."

