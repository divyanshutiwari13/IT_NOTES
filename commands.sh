#!/bin/bash

# Install i7z and run it
apt update && apt install -y i7z

i7z

# Set CPU scaling governor to performance
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Solve 'system detected problem' issues
apt autoremove -y

# Remove crash reports
rm -f /var/crash/*

# Disable apport (error reporting service)
sed -i 's/enabled=1/enabled=0/' /etc/default/apport

# Clear caches
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches

# Restart swap
swapoff -a
swapon -a

# Final reboot
reboot
