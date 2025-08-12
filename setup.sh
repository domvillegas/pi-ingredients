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

echo -e "${GREEN}Installing system dependencies (Python, build tools, curl)...${NO_COLOR}"
sudo apt install -y python3 python3-venv python3-pip curl build-essential & spinner $!

# --- Python setup ---
echo -e "${GREEN}Creating Python virtual environment...${NO_COLOR}"
python3 -m venv venv

echo -e "${GREEN}Activating virtual environment and upgrading pip...${NO_COLOR}"
source venv/bin/activate
pip install --upgrade pip & spinner $!

echo -e "${GREEN}Installing Python dependencies in virtual environment...${NO_COLOR}"
pip install pygame evdev & spinner $!

deactivate

# --- Node.js setup ---
echo -e "${GREEN}Checking for Node.js...${NO_COLOR}"
if ! command -v node &> /dev/null
then
    echo -e "${GREEN}Node.js not found, installing Node.js LTS...${NO_COLOR}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - & spinner $!
    sudo apt install -y nodejs & spinner $!
else
    echo -e "${GREEN}Node.js found: $(node -v)${NO_COLOR}"
fi


if [ ! -f package.json ]; then
    npm init -y & spinner $!
fi

echo -e "${GREEN}Installing Node.js dependencies (express)...${NO_COLOR}"
npm install express & spinner $!

# --- ngrok setup ---
echo -e "${GREEN}Checking ngrok version...${NO_COLOR}"
cd ~

if [ -f ngrok ]; then
    # Get current installed version
    INSTALLED_VERSION=$(./ngrok version | awk '{print $3}')
    MIN_VERSION="3.7.0"

    # Compare versions (using sort -V for version sorting)
    if [ "$(printf '%s\n%s' "$MIN_VERSION" "$INSTALLED_VERSION" | sort -V | head -n1)" = "$MIN_VERSION" ] && [ "$INSTALLED_VERSION" != "$MIN_VERSION" ]; then
        echo -e "${GREEN}ngrok version $INSTALLED_VERSION is older than $MIN_VERSION, updating...${NO_COLOR}"
        NEED_UPDATE=1
    else
        echo -e "${GREEN}ngrok version $INSTALLED_VERSION is up to date.${NO_COLOR}"
        NEED_UPDATE=0
    fi
else
    echo -e "${GREEN}ngrok not found, installing...${NO_COLOR}"
    NEED_UPDATE=1
fi

if [ "$NEED_UPDATE" -eq 1 ]; then
    wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip
    unzip -o ngrok-v3-stable-linux-arm.zip
    rm ngrok-v3-stable-linux-arm.zip
    chmod +x ngrok
fi

echo -e "${GREEN}Setup complete!${NO_COLOR}"
echo -e "${GREEN}To activate Python virtual environment, run:${NO_COLOR}"
echo -e "${GREEN}  source venv/bin/activate${NO_COLOR}"
echo -e "${GREEN}To start your Node.js webhook server, run:${NO_COLOR}"
echo -e "${GREEN}  node ~/webhook_listener/server.js${NO_COLOR}"
echo -e "${GREEN}To start ngrok tunnel manually, run:${NO_COLOR}"
echo -e "${GREEN}  ~/ngrok http 5000${NO_COLOR}"
