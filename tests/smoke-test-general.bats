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

@test "fin init" {
	[[ $SKIP == 1 ]] && skip

	run fin init
	echo "$output" | grep "Initializing local project configuration"
	echo "$output" | grep "Recreating services"
	echo "$output" | grep "Installing site"
	echo "$output" | grep "Congratulations, you installed Drupal!"

	# Check if site is available and it's name is correct
	curl -sL drupal8.docksal | grep "My Drupal 8 Site"
}

@test "fin mysql-dump" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Create backup
	run fin mysql-dump ../dump.sql --db-user=user --db-password=user --db-name=default

	echo "$output" | grep "Looking for database..."
	echo "$output" | grep "Exporting..."
	echo "$output" | grep "Done"

	# Update sitename
	fin drush config-set system.site name 'My Drupal Fin updated 8 Site' -y

	# Check if site is available and it's name is correct
	curl -sL drupal8.docksal | grep "My Drupal Fin updated 8 Site"

	cd ..
}

@test "fin mysql-import" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-import ../dump.sql -y
	echo "$output" | grep "Importing dump.sql into the database..."
	echo "$output" | grep "mysql-import finished"
	# Check if site is available and it's name is correct
	curl -sL drupal8.docksal | grep "My Drupal 8 Site"

	cd ..
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
