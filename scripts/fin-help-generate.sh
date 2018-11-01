#!/usr/bin/env bash

# Generates $OUTFILE as a result

OUTFILE="docs/content/fin/fin-help.md"

# Tell fin to remove colors
export TERM="dumb"

# $1 - header text
headergen ()
{
	echo -e "## $1 {#$1}\n" >> "$(pwd)/$OUTFILE"
}

# $1 commmand
helpgen ()
{
	fin help "$1" | sed "s/^/	/" >> "$(pwd)/$OUTFILE"
	echo >> "$(pwd)/$OUTFILE"
}

[[ -f "$OUTFILE" ]] && rm "$OUTFILE" # not -f to see error just in case

echo "Generating help..."
echo "Output: $(pwd)/$OUTFILE"

# Markdown header
cat <<EOF >> "$(pwd)/$OUTFILE"
---
title: "fin help"
weight: 2
aliases:
  - /en/master/fin/fin-help/
---

EOF

headergen "fin"
helpgen

echo " - project"
headergen "project"
helpgen project

echo " - db"
headergen "db"
helpgen db

echo " - system"
headergen "system"
helpgen system

echo " - config"
headergen "config"
helpgen config

echo " - addon"
headergen "addon"
helpgen addon

echo " - run-cli"
headergen "run-cli"
helpgen run-cli

echo " - hosts"
headergen "hosts"
helpgen hosts

echo " - alias"
headergen "alias"
helpgen alias

echo " - ssh-add"
headergen "ssh-add"
helpgen ssh-add

echo " - logs"
headergen "logs"
helpgen logs

echo " - image"
headergen "image"
helpgen image
