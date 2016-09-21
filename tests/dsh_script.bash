#!/usr/bin/env bats

# Include dsh script for usign internal dsh function.
setup() {
	. /usr/local/bin/dsh > /dev/null

	# If you check your update in dsh.
	#. ../drude/bin/dsh > /dev/null

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