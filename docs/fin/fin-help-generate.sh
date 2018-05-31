#!/usr/bin/env bash

# Generates $OUTFILE as a result

OUTFILE="fin.help.md"

# Tell fin to remove colors
export TERM="dumb"

# $1 - header text
headergen ()
{
	echo -e "## $1\n" >> "$(pwd)/$OUTFILE"
}

# $1 commmand
helpgen ()
{
	if [[ "$1" != "" ]]; then
		echo "<a name=\"fin-help-$1\"></a>" >> "$(pwd)/$OUTFILE"
	fi
	fin help "$1" | sed "s/^/	/" >> "$(pwd)/$OUTFILE"
	echo >> "$(pwd)/$OUTFILE"
}

[[ -f "$OUTFILE" ]] && rm "$OUTFILE" # not -f to see error just in case

echo "Generating help..."
echo "Output: $(pwd)/$OUTFILE"
headergen "Fin"
helpgen

echo " - project"
headergen "Project"
helpgen project

echo " - db"
headergen "Database"
helpgen db

echo " - system"
headergen "System"
helpgen system

echo " - config"
headergen "Config"
helpgen config

echo " - addon"
headergen "Addons"
helpgen config

echo " - run-cli"
headergen "Run-cli"
helpgen run-cli

echo " - hosts"
headergen "Hosts"
helpgen hosts

echo " - alias"
headergen "Alias"
helpgen alias

echo " - ssh-add"
headergen "Ssh-Add"
helpgen ssh-add

echo " - logs"
headergen "Logs"
helpgen logs

echo " - image"
headergen "Image"
helpgen image
