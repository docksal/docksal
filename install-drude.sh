#!/bin/bash

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Drude repo
DRUDE_REPO='https://github.com/blinkreaction/drude.git'
DRUDE_REPO_RAW='https://raw.githubusercontent.com/blinkreaction/drude/master'

# Install/update dsh tool wrapper
curl -s "$DRUDE_REPO_RAW/install.sh" | bash

# Check that git binary is available
type git > /dev/null 2>&1 || { echo -e >&2 "${red}No git? Srsly? \n${yellow}Please install git then come back. Aborting...${NC}"; exit 1; }

# Check if current directory is a Git repository
if [[ -z $(git rev-parse --git-dir 2>/dev/null) ]]; then
	# If there is no git repo - initialize one and commit everything before we proceed
	echo -e "${yellow}No git repository! We'll create one to proceed witht he install.${NC}"
	echo -e "${green}Initializing a git repo and commiting everything.${NC}"
	git init -q && git add -A && git commit -q -m 'Initial commit'
fi

# Make sure we are in the root of a git repository
if [[ $(git rev-parse --git-dir) != '.git' ]]; then
	GIT_ROOT=$(git rev-parse --show-toplevel)
	echo -e "${yellow}This script must be run from the git repo root. Switching to $GIT_ROOT.${NC}"
	cd $GIT_ROOT
fi

# Check if the working tree and index are clean
if [[ -n $(git status -s) ]]; then
	echo -e "${red}Your git working tree or index is not clean."
	echo -e "Please stage/stash and commit any pending changes before proceeding with the update.${NC}"
	exit 1
fi

# Checking out the most recent Drude build
git remote add drude $DRUDE_REPO
git remote update
git checkout drude/build .
git remote rm drude

if [[ -n $(git status -s) ]]; then
	echo -e "${green}Installed/updated Drude at version $(cat .docker/VERSION)${NC}"
	echo -e "${yellow}Please review tha changes and commit them into your repo!${NC}"
else
	echo -e "${yellow}You already have the most recent build of Drude!${NC}"
fi
