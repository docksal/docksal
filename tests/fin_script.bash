#!/usr/bin/env bats

# Include fin script for usign internal fin function.
setup() {
	. /usr/local/bin/fin > /dev/null

	# If you check your update in dsh.
	#. ../drude/bin/fin > /dev/null

	# Current system variables.
	OS="${OS:-mac}"
}

teardown() {
	echo "+=============================================================="
	echo "< Current output >:"
	echo $output
	echo "< Current lines >:"
	for line in "${lines[@]}"; do
		echo $line
	done
	echo "+=============================================================="
}