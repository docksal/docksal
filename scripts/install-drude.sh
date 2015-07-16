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
	echo -e "${red}[install-drude] testing mode: environment = \"${BRANCH}\"$NC"
fi

# Drude repo
DRUDE_REPO="https://github.com/blinkreaction/drude.git"
DRUDE_REPO_RAW="https://raw.githubusercontent.com/blinkreaction/drude/$BRANCH"

# Check whether shell is interactive (otherwise we are running in a non-interactive script environment)
is_tty ()
{
	[[ "$(/usr/bin/tty || true)" != "not a tty" ]]
}

# Yes/no confirmation dialog with an optional message
# @param $1 confirmation message
# _confirm ()
# {
# 	# Skip checks if not a tty
# 	if ! is_tty ; then return 0; fi
	
# 	while true; do
# 		read -p "$1 [y/n]: " answer
# 		case $answer in
# 			[Yy]|[Yy][Ee][Ss] )
# 				break
# 				;;
# 			[Nn]|[Nn][Oo] )
# 				exit 1
# 				;;
# 			* )
# 				echo 'Please answer yes or no.'
# 		esac
# 	done
}

# Install/update dsh tool wrapper
# dsh_install_script=$(curl -fsS "$DRUDE_REPO_RAW/install-dsh.sh")
# if [ $? -eq 0 ]; then
# 	# calling bash interactively
# 	bash <(echo "$dsh_install_script")
# 	if [ ! $? -eq 0 ]; then
# 		_confirm "Do you want to continue with drude update regardless?"
# 	fi
# else
# 	echo -e "${red}Could not get install-dsh script.${NC}"
# 	_confirm "Do you want to continue with drude update regardless?"
# fi

echo -e "${green}Installing Drude update...${NC}"
# Check that git binary is available
type git > /dev/null 2>&1 || { echo -e >&2 "${red}No git? Srsly? \n${yellow}Please install git then come back. Aborting...${NC}"; exit 1; }

# Check if current directory is a Git repository
# if [[ -z $(git rev-parse --git-dir 2>/dev/null) ]]; then
# 	# If there is no git repo - initialize one and commit everything before we proceed
# 	echo -e "${yellow}No git repository! We'll create one to proceed with the install.${NC}"
# 	echo -e "${green}Going to initialize a git repo and commit everything.${NC}"
# 	_confirm "Do you want to initialize new git repo in $(pwd)?"
# 	git init -q && git add -A && git commit -q -m 'Initial commit'
# fi

# # Make sure we are in the root of a git repository
# if [[ $(git rev-parse --git-dir) != '.git' ]]; then
# 	GIT_ROOT=$(git rev-parse --show-toplevel)
# 	echo "Switching to git repo root: $GIT_ROOT"
# 	cd $GIT_ROOT
# fi

# # Check if the working tree and index are clean
# if [[ -n $(git status .docker docker-compose.yml -s) ]]; then
# 	echo -e "${yellow}You have uncommitted changes in following files:${NC}"
# 	git status .docker docker-compose.yml -s
# 	echo -e "${yellow}Before proceeding with the update it is recommended to commit any pending changes in files above.$NC"
# 	_confirm "Proceeding will overwrite your changes. Continue?"
# fi

# # Checking out the most recent Drude build
# git remote add drude $DRUDE_REPO
# git remote update drude 1>/dev/null
# git checkout --theirs drude/build .
# git remote rm drude

# if [[ -n $(git status .docker docker-compose.yml -s) ]]; then
# 	echo -e "${green}Installed/updated Drude to version $(cat .docker/VERSION)${NC}"
# 	echo -e "${yellow}Please review the changes and commit them into your repo!${NC}"
# else
# 	echo -e "${yellow}You already have the most recent build of Drude${NC}"
# fi

# Downloading the most recent version of Drude
docker_compose=$(curl -kfsS "$DRUDE_REPO_RAW/docker-compose.yml")
if [ ! $? -eq 0 ]; then
	echo -e "${red}Could not get latest docker-compose.yml version.${NC}"
	exit 1
else
	echo "$docker_compose" | tee "docker-compose.yml" >/dev/null
	echo -e "${green}docker-compose.yml updated to the latest version.${NC}"
fi
