#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Drude repo
DRUDE_REPO='https://github.com/blinkreaction/drude.git'
DRUDE_REPO_RAW='https://raw.githubusercontent.com/blinkreaction/drude/master'

# Determine if we have sudo
SUDO='sudo'
if [[ -z $(which $SUDO) ]]; then SUDO=''; fi
# Detemine where we can install (/usb/local/bin or /bin)
BIN='/usr/local/bin'
$SUDO touch "$BIN/dsh" 2> /dev/null || BIN="/bin"
$SUDO touch "$BIN/dsh" 2> /dev/null || { echo -e "${yellow}Warning: Not able to install dsh.${NC}"; }
# Install/update dsh tool wrapper
echo -e "${green}Installing/updating dsh (Drude Shell) tool wrapper to $BIN/dsh${NC}"
curl -s "$DRUDE_REPO_RAW/scripts/dsh-wrapper.sh" | $SUDO tee 1>/dev/null "$BIN/dsh"
$SUDO chmod +x "$BIN/dsh"
