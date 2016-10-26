#!/usr/bin/env bats

# Include fin script for usign internal fin function.
setup() {
	. /usr/local/bin/fin > /dev/null

	# If you check your update in fin.
	#. ../docksal/bin/fin > /dev/null

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

# Helper functions.

# Check if containers are not running.
docker_check_not_runnign() {
	[[ $(docker ps) != *"drupal7_cli_"* ]]
	[[ $(docker ps) != *"drupal7_db_"* ]]
	[[ $(docker ps) != *"drupal7_web_"* ]]
}

# Check if containers are running.
docker_check_runnign() {
	[[ $(docker ps) == *"drupal7_cli_"* ]]
	[[ $(docker ps) == *"drupal7_db_"* ]]
	[[ $(docker ps) == *"drupal7_web_"* ]]
}