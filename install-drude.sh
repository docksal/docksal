#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Drude repo
DRUDE_REPO='https://github.com/blinkreaction/drude.git'
DRUDE_REPO_RAW='https://raw.githubusercontent.com/blinkreaction/drude/master'

# Yes/no confirmation dialog with an optional message
# @param $1 confirmation message
_confirm ()
{
	while true; do
		read -p "$1Continue? [y/n]: " answer
		case $answer in
			[Yy]|[Yy][Ee][Ss] )
				echo "Working..."
				break
				;;
			[Nn]|[Nn][Oo] )
				echo 'Ok, whatever.'
				exit 1
				;;
			* )
				echo 'Please answer yes or no.'
		esac
	done
}

echo "Updating dsh"
# Install/update dsh tool wrapper
curl -s "$DRUDE_REPO_RAW/install-dsh.sh" | bash

# Check that git binary is available
type git > /dev/null 2>&1 || { echo -e >&2 "${red}No git? Srsly? \n${yellow}Please install git then come back. Aborting...${NC}"; exit 1; }

# Check if current directory is a Git repository
if [[ -z $(git rev-parse --git-dir 2>/dev/null) ]]; then
	# If there is no git repo - initialize one and commit everything before we proceed
	echo -e "${yellow}No git repository! We'll create one to proceed with the install.${NC}"
	echo -e "${green}Going to initialize a git repo and commit everything.${NC}"
	_confirm "Initializing new git repo in $(pwd). "
	git init -q && git add -A && git commit -q -m 'Initial commit'
fi

# Make sure we are in the root of a git repository
if [[ $(git rev-parse --git-dir) != '.git' ]]; then
	GIT_ROOT=$(git rev-parse --show-toplevel)
	echo -e "${yellow}This script must be run from the git repo root. Switching to $GIT_ROOT.${NC}"
	cd $GIT_ROOT
fi

# Check if the working tree and index are clean
if [[ -n $(git status .docker docker-compose.yml -s) ]]; then
	echo -e "${red}Your git working tree or index is not clean."
	echo -e "It is recommended to commit any pending changes before proceeding with the update.${NC}"
	_confirm "Going to overwrite changes to .docker/ and docker-compose.yml. "
fi

# Checking out the most recent Drude build
git remote add drude $DRUDE_REPO
git remote update drude
git checkout drude/build .
git remote rm drude

if [[ -n $(git status .docker docker-compose.yml -s) ]]; then
	echo -e "${green}Installed/updated Drude to version $(cat .docker/VERSION)${NC}"
	echo -e "${yellow}Please review the changes and commit them into your repo!${NC}"
else
	echo -e "${yellow}You already have the most recent build of Drude${NC}"
fi
