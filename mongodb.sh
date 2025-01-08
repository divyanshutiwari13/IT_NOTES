#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update -y

# Install necessary tools
echo "Installing necessary tools..."
sudo apt install -y gnupg wget

# Add MongoDB GPG key
echo "Adding MongoDB GPG key..."
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Add MongoDB repository to APT sources list
echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update package list after adding MongoDB repository
echo "Updating package list..."
sudo apt update -y

# Install MongoDB (latest version)
echo "Installing MongoDB..."
sudo apt-get install -y mongodb-org

# Install specific MongoDB version (6.0.1)
echo "Installing specific MongoDB version 6.0.1..."
sudo apt-get install -y mongodb-org=6.0.1 mongodb-org-database=6.0.1 mongodb-org-server=6.0.1 mongodb-mongosh=6.0.1 mongodb-org-mongos=6.0.1 mongodb-org-tools=6.0.1

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod

# Enable MongoDB service to start on boot
echo "Enabling MongoDB to start on boot..."
sudo systemctl enable mongod

# Reload systemd and check MongoDB service status
echo "Reloading systemd and checking MongoDB service status..."
sudo systemctl daemon-reload
sudo systemctl status mongod

# Checking MongoDB's active ports
echo "Checking active ports..."
netstat -plntu

# Start MongoDB shell
echo "Starting MongoDB shell..."
mongosh

# Download MongoDB Compass (GUI tool)
echo "Downloading MongoDB Compass..."
wget https://downloads.mongodb.com/compass/mongodb-compass_1.28.4_amd64.deb

# Install MongoDB Compass
echo "Installing MongoDB Compass..."
sudo apt install -y ./mongodb-compass_1.28.4_amd64.deb

echo "MongoDB and MongoDB Compass setup completed successfully!"
