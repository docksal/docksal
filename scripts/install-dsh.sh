#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# For testing
if [ ! $DRUDE_BRANCH == "" ]; then
	echo -e "${red}[install-dsh] testing mode: environment = \"${DRUDE_BRANCH}\"$NC"
else
	DRUDE_BRANCH='master'
fi

# Drude repo
DRUDE_REPO="https://github.com/blinkreaction/drude.git"
DRUDE_REPO_RAW="https://raw.githubusercontent.com/blinkreaction/drude/$DRUDE_BRANCH"

echo -e "${green}Installing/updating dsh (Drude Shell). Admin access required${NC}"
# Determine if we have sudo
SUDO='sudo'
if [[ -z $(which $SUDO) ]]; then SUDO=''; fi

# Detemine where we can install (/usb/local/bin or /bin)
BIN='/usr/local/bin'

$SUDO touch "$BIN/dsh" 2> /dev/null || {
	echo -e "${yellow}Could not write to $BIN/dsh.${NC}";
	BIN="/bin";
}

$SUDO touch "$BIN/dsh" 2> /dev/null || {
	echo -e "${yellow}Could not write to $BIN/dsh.${NC}";
	echo -e "${red}Could not install dsh wrapper tool${NC}";
	exit 1;
}

# Install/update dsh
dsh_script=$(curl -kfsS "$DRUDE_REPO_RAW/bin/dsh")
if [ ! $? -eq 0 ]; then
	echo -e "${red}Could not get latest dsh version.${NC}"
	exit 1
else
	echo "$dsh_script" | $SUDO tee "$BIN/dsh" >/dev/null
	$SUDO chmod a+x "$BIN/dsh"
	echo -e "${green}dsh wrapper was installed as${NC}${yellow} $BIN/dsh${NC}"
fi
