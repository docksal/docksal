#!/usr/bin/env bash

# Generates $OUTFILE as a result

OUTFILE="../docs/content/fin/fin-help.md"

# List of help sections to include
sections="
	fin
	addon
	alias
	db
	hosts
	project
	ssh-key
	system
	vm

	config
	exec-url
	init
	image
	logs
	pull
	run-cli
	share
	share-v2

	cleanup
	update
"

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
	printf \
'```text
%s
```\n\n' \
	"$(../bin/fin help "$1")" >> "$(pwd)/$OUTFILE"
}

# --------------------------------- RUNTIME ------------------------------------

# This script directory
__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$__DIR__"
[[ -f "$OUTFILE" ]] && rm "$OUTFILE" # not -f to see error just in case

echo "Generating help..."

# Markdown header
cat << EOF >> "$(pwd)/$OUTFILE"
---
title: "fin help"
weight: 2
aliases:
  - /en/master/fin/fin-help/
---

EOF

# Generate help for all help sections
for section in ${sections}; do
	echo " - ${section}"
	headergen ${section}
	helpgen ${section}
done
