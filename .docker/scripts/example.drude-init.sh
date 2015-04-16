#!/bin/bash

# Set to the appropriate site directory
SITE_DIRECTORY='project.drude'
# Set to the appropriate site alias for the DB source
SOURCE_ALIAS='@project.prod'

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

# Get project root directory
GIT_ROOT=$(git rev-parse --show-toplevel)
if [[ -z $GIT_ROOT  ]]; then exit -1; fi

# Set repo root as working directory.
cd $GIT_ROOT

# Yes/no confirmation dialog with an optional message
# @param $1 confirmation message
_confirm ()
{
	while true; do
		read -p "$1 Continue? [y/n]: " answer
		case $answer in
			[Yy]|[Yy][Ee][Ss] )
				echo "Working..."
				break
				;;
			[Nn]|[Nn][Oo] )
				echo 'Ok, whatever.'
				exit
				;;
			* )
				echo 'Please answer yes or no.'
		esac
	done
}

# Copy settings files
init_settings ()
{
  cd $GIT_ROOT
  if [[ ! -f 'docker-compose.yml' ]]; then
    echo -e "${green}Copying docker-compose.yml${NC}"
    cp docker-compose.yml.dist docker-compose.yml
  else
    echo -e "${yellow}docker-compose.yml already in place${NC}"
  fi

  if [[ ! -f "docroot/sites/${SITE_DIRECTORY}/settings.local.php" ]]; then
    echo -e "${green}Copying docroot/sites/${SITE_DIRECTORY}/settings.local.php${NC}"
    cp docroot/sites/${SITE_DIRECTORY}/example.settings.local.php docroot/sites/${SITE_DIRECTORY}/settings.local.php
  else
    echo -e "${yellow}docroot/sites/${SITE_DIRECTORY}/settings.local.php already in place${NC}"
  fi
}

# Import database from the source site alias
db_import ()
{
  _confirm "Do you want to import DB from ${SOURCE_ALIAS}?"

  cd $GIT_ROOT
  cd docroot
  dsh drush -l ${SITE_DIRECTORY} sql-sync ${SOURCE_ALIAS} @self -y
}

# Local adjustments
local_settings ()
{
  cd $GIT_ROOT
  echo -e "${yellow}Applying local settings${NC}"
  cd docroot
  set -x

  dsh drush -l ${SITE_DIRECTORY} en stage_file_proxy -y

  set +x
}

init_settings
dsh up
db_import
local_settings

echo -e "${green}All done!${NC}"
echo -e "${green}Add ${SITE_DIRECTORY} to your hosts file (/etc/hosts), e.g.:${NC}"
echo -e "192.168.10.10  ${SITE_DIRECTORY}"
echo -e "${green}Open http://${SITE_DIRECTORY} in your browser to verify the setup.${NC}"
