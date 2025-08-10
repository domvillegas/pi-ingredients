#!/bin/bash
set -e  # exit if any command fails

echo "Updating package lists..."
sudo apt update

echo "Installing system dependencies..."
sudo apt install -y python3 python3-venv python3-pip

echo "Creating Python virtual environment..."
python3 -m venv venv

echo "Activating virtual environment and upgrading pip..."
source venv/bin/activate
pip install --upgrade pip

echo "Installing Python dependencies in virtual environment..."
pip install pygame

echo "Setup complete. To activate the virtual environment, run:"
echo "  source venv/bin/activate"