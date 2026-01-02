#!/bin/bash

# Setup script for network-monitor
# Installs required dependencies: iftop and tmux

set -e

echo "Installing network-monitor dependencies..."

# Detect package manager and install
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y iftop tmux
elif command -v dnf &> /dev/null; then
    sudo dnf install -y iftop tmux
elif command -v yum &> /dev/null; then
    sudo yum install -y iftop tmux
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm iftop tmux
else
    echo "Error: Could not detect package manager (apt/dnf/yum/pacman)"
    exit 1
fi

echo "Dependencies installed successfully!"
echo "Run ./network-monitor.sh with sudo to start monitoring."
