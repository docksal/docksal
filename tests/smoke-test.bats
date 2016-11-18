#!/usr/bin/env bats

# Debugging
teardown() {
	echo "Status: $status"
	echo "Output:"
	echo "================================================================"
	for line in "${lines[@]}"; do
		echo $line
	done
	echo "================================================================"
}

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

@test "fin start" {
	[[ $SKIP == 1 ]] && skip
	
	run fin start
	echo "$output" | grep "Creating network \".*_default\" with the default driver"
	echo "$output" | grep "Creating volume \".*_project_root\" with local driver"
	echo "$output" | grep "Creating .*_web_1"
	echo "$output" | grep "Creating .*_db_1"
	echo "$output" | grep "Creating .*_cli_1"

	# uid change won't usually happen in Linux, as host uid 1000 matches container uid.
	#echo "$output" | grep "Changing user id in cli to \d* to match host user id"
	#echo "$output" | grep "Resetting permissions on /var/www"
	#echo "$output" | grep "Restarting php daemon"

	echo "$output" | grep "Connected vhost-proxy to \".*_default\" network"

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
}

@test "fin ssh-add" {
	[[ $SKIP == 1 ]] && skip

  # Checking fin ssh-add -D
	run fin ssh-add -D
  echo "$output" | grep "All identities removed."

  # Checking fin ssh-add: key doesn't exist
  run fin ssh-add doesnt_exist_rsa
  echo "$output" | grep "doesnt_exist_rsa: No such file or directory"

  # Add test key
  cp ../docksal/tests/ssh-key/* ~/.ssh
  run fin ssh-add bats_rsa

  # Checking fin ssh-add -l (one key)
	run fin ssh-add -l
  echo "$output" | grep "4096 SHA256"

  # Checking fin ssh-add -D
	run fin ssh-add -D
  echo "$output" | grep "All identities removed."

  # Checking fin ssh-add -l (no keys)
	run fin ssh-add -l
  echo "$output" | grep "The agent has no identities."
}

@test "fin stop" {
	[[ $SKIP == 1 ]] && skip
	
	run fin stop
	echo "$output" | grep "Stopping .*_web_1"
	echo "$output" | grep "Stopping .*_db_1"
	echo "$output" | grep "Stopping .*_cli_1"

	# Check that containers are stopped
	run fin ps
	# Sometimes containers would not exit with code 0 (graceful stop), but 137 instead (when docker has to kill the process). 
	echo "$output" | grep "web_1" | grep "Exit 0\|Exit 137"
	echo "$output" | grep "db_1" | grep "Exit 0\|Exit 137"
	echo "$output" | grep "cli_1" | grep "Exit 0\|Exit 137"
	
	# Start containers back
	fin start || true
}

@test "fin restart" {
	[[ $SKIP == 1 ]] && skip
	
	run fin restart
	echo "$output" | grep "Stopping .*_web_1"
	echo "$output" | grep "Stopping .*_db_1"
	echo "$output" | grep "Stopping .*_cli_1"
	
	echo "$output" | grep "Starting .*_web_1"
	echo "$output" | grep "Starting .*_db_1"
	echo "$output" | grep "Starting .*_cli_1"

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
}

@test "fin reset -f" {
	[[ $SKIP == 1 ]] && skip
	
	run fin reset -f
	echo "$output" | grep "Stopping .*_web_1"
	echo "$output" | grep "Stopping .*_db_1"
	echo "$output" | grep "Stopping .*_cli_1"

	echo "$output" | grep "Removing .*_web_1"
	echo "$output" | grep "Removing .*_db_1"
	echo "$output" | grep "Removing .*_cli_1"

	echo "$output" | grep "Removing network .*_default"
	echo "$output" | grep "Removing volume .*_project_root"
	echo "$output" | grep "Volume docksal_ssh_agent is external, skipping"

	echo "$output" | grep "Creating .*_web_1"
	echo "$output" | grep "Creating .*_db_1"
	echo "$output" | grep "Creating .*_cli_1"

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
}

@test "fin exec" {
	[[ $SKIP == 1 ]] && skip
	
	run fin exec uname -a
	[[ "$output" =~ "Linux cli" ]]
	
	run fin exec pwd
	[[ "$(echo $output | tr -d '[:cntrl:]')" == "/var/www" ]]

	# Test that switching directories on host carries over into cli
	cd docroot
	run fin exec pwd
	[[ "$(echo $output | tr -d '[:cntrl:]')" == "/var/www/docroot" ]]
}

@test "fin drush" {
	[[ $SKIP == 1 ]] && skip
	
	# Default drush (8)
	run fin drush --version
	echo "$output" | grep "Drush Version   :  8."

	# Drush 6
	run fin exec drush6 --version
	echo "$output" | grep "Drush Version   :  6."

	# Drush 7
	run fin exec drush7 --version
	echo "$output" | grep "Drush Version   :  7."
}


@test "fin rm -f" {
	[[ $SKIP == 1 ]] && skip
	
	# First run
	run fin rm -f
	echo "$output" | grep "Stopping .*_web_1"
	echo "$output" | grep "Stopping .*_db_1"
	echo "$output" | grep "Stopping .*_cli_1"

	echo "$output" | grep "Removing .*_web_1"
	echo "$output" | grep "Removing .*_db_1"
	echo "$output" | grep "Removing .*_cli_1"

	echo "$output" | grep "Removing network .*_default"
	echo "$output" | grep "Removing volume .*_project_root"
	echo "$output" | grep "Volume docksal_ssh_agent is external, skipping"

	# Check that there are no containers
	run fin ps
	[[ "$(echo "$output" | tail -n +3)" == "" ]]
}
