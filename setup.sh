#!/bin/bash
set -e

GREEN='\033[0;32m'
NO_COLOR='\033[0m'

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  echo -n " "
  while kill -0 $pid 2>/dev/null; do
    for (( i=0; i<${#spinstr}; i++ )); do
      printf "\b${spinstr:i:1}"
      sleep $delay
    done
  done
  printf "\b"
}

echo -e "${GREEN}Updating package lists...${NO_COLOR}"
sudo apt update & spinner $!

echo -e "${GREEN}Installing system dependencies...${NO_COLOR}"
sudo apt install -y python3 python3-venv python3-pip & spinner $!

echo -e "${GREEN}Creating Python virtual environment...${NO_COLOR}"
python3 -m venv venv

echo -e "${GREEN}Activating virtual environment and upgrading pip...${NO_COLOR}"
source venv/bin/activate
pip install --upgrade pip & spinner $!

echo -e "${GREEN}Installing Python dependencies in virtual environment...${NO_COLOR}"
pip install pygame & spinner $!

echo -e "${GREEN}Setup complete. To activate the virtual environment, run:${NO_COLOR}"
echo -e "${GREEN}  source venv/bin/activate${NO_COLOR}"
