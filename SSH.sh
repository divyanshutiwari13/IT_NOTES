#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update -y

# Install OpenSSH server
echo "Installing OpenSSH server..."
sudo apt install -y openssh-server

# Enable and start SSH service
echo "Enabling and starting SSH service..."
sudo systemctl enable --now ssh

# Allow SSH through the firewall
echo "Allowing SSH through UFW firewall..."
sudo ufw allow ssh

# Generate SSH key pair automatically
echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -f /home/ubuntu/.ssh/id_rsa -N ""

# Backup the SSH configuration
echo "Backing up the SSH configuration file..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.initial

# Modify SSH configuration for security
echo "Configuring SSH settings..."
sudo tee /etc/ssh/sshd_config <<EOF
Port 2222  # Change this port if you prefer another one
PermitRootLogin no
PubkeyAuthentication yes
EOF

# Restart SSH service to apply changes
echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "SSH setup completed successfully!"
