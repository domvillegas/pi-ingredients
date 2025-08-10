#!/bin/bash
set -e  # exit if any command fails

echo "Updating package lists..."
sudo apt update

echo "Installing dependencies..."
sudo apt install -y python3-pygame

echo "Setup complete."