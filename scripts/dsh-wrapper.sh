#!/bin/bash

# dsh (Drude Shell) wrapper script.
# Finds dsh in the path within a git repo.

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Check that git binary is available
type git > /dev/null 2>&1 || { echo -e >&2 "${red}Error: no git. \n${yellow}Srsly? Please install git then come back. Aborting...${NC}"; exit 1; }

# Check if current directory is a Git repository
if [[ -z $(git rev-parse --git-dir) ]]; then
	echo -e "${red}Error: this script must be run within you project's git repo.${NC}"
	exit 1
fi

GIT_ROOT=$(git rev-parse --show-toplevel)
DOT_DOCKER="$GIT_ROOT/.docker"

exec "$DOT_DOCKER/bin/dsh" "$@"
