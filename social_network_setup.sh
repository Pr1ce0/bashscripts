#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Update and upgrade
apt update && apt upgrade -y

# Install necessary dependencies
apt install -y apache2 git

# Check if Node.js and npm are installed
if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
  echo "Node.js or npm is not installed. Installing Node.js and npm..."

  # Install Node.js using NVM (Node Version Manager)
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  source ~/.bashrc

  # Install the latest LTS version of Node.js
  nvm install --lts

  # Set the LTS version as the default
  nvm alias default 'lts/*'
fi

# Clone the Git repository
echo "Loading the code from Git repo"
CODE_DIR="/var/www/social-network"

if [ -d "$CODE_DIR" ]; then
  echo "Git repository already cloned."
else
  mkdir -p "$CODE_DIR"
  git clone https://github.com/viktoriia-lapytska/social-network.git "$CODE_DIR"
fi

# Install application dependencies
cd "$CODE_DIR"
npm install

# Start the application
npm start &
