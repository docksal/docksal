#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# For testing
BRANCH='master'
if [ ! $DRUDE_TEST_ENVIRONMENT == "" ]; then
	BRANCH=$DRUDE_TEST_ENVIRONMENT
	echo -e "${red}[install-dsh] testing mode: environment = \"${BRANCH}\"$NC"
fi

# Drude repo
DRUDE_REPO="https://github.com/blinkreaction/drude.git"
DRUDE_REPO_RAW="https://raw.githubusercontent.com/blinkreaction/drude/$BRANCH"

echo -e "${green}Installing/updating dsh tool wrapper. Admin access required${NC}"
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
	return 1;
	exit 1;
}

# Install/update dsh tool wrapper
curl -fsS "$DRUDE_REPO_RAW/scripts/dsh-wrapper.sh" -o "$BIN/dsh-new"
if [ ! $? -eq 0 ]; then
	rm "$BIN/dsh-new" 2>dev/null
	echo -e "${red}Could not get latest dsh wrapper version.${NC}"
	return 1
	exit 1
else
	$SUDO mv "$BIN/dsh-new" "$BIN/dsh"
	$SUDO chmod +x "$BIN/dsh"
	echo -e "${green}dsh wrapper was installed as${NC}${yellow} $BIN/dsh${NC}"
fi
