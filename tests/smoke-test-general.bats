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
	echo "$output" | egrep "Creating network \".*_default\" with the default driver"
	echo "$output" | egrep "Creating volume \".*_project_root\" with local driver"
	echo "$output" | egrep "Creating .*_web_1"
	echo "$output" | egrep "Creating .*_db_1"
	echo "$output" | egrep "Creating .*_cli_1"

	# uid change won't usually happen in Linux, as host uid 1000 matches container uid.
	#echo "$output" | grep "Changing user id in cli to \d* to match host user id"
	#echo "$output" | grep "Resetting permissions on /var/www"
	#echo "$output" | grep "Restarting php daemon"

	echo "$output" | egrep "Connected vhost-proxy to \".*_default\" network"

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
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-dump" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Create backup
	run fin mysql-dump default ../dump.sql --db-user=user --db-password=user

	echo "$output" | grep "Exporting..."
	echo "$output" | grep "OK"

	# Update sitename
	fin drush config-set system.site name 'My Drupal Fin updated 8 Site' -y

	# Check if site is available and it's name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal Fin updated 8 Site"

	cd ..
}

@test "fin mysql-import" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-import default ../dump.sql --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	echo "$output" | grep "OK"

	# Check if site is available and it's name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"

	cd ..
}

@test "fin stop" {
	[[ $SKIP == 1 ]] && skip
	
	run fin stop
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"

	# Check that containers are stopped
	run fin ps
	# Sometimes containers would not exit with code 0 (graceful stop), but 137 instead (when docker has to kill the process). 
	echo "$output" | egrep ".*_web_1 .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_db_1 .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_cli_1 .* (Exit 0|Exit 137)"
	
	# Start containers back
	fin start
}

@test "fin restart" {
	[[ $SKIP == 1 ]] && skip
	
	run fin restart
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"
	
	echo "$output" | egrep "Starting .*_web_1"
	echo "$output" | egrep "Starting .*_db_1"
	echo "$output" | egrep "Starting .*_cli_1"

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
}

@test "fin reset -f" {
	[[ $SKIP == 1 ]] && skip
	
	run fin reset -f
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"

	echo "$output" | egrep "Removing .*_web_1"
	echo "$output" | egrep "Removing .*_db_1"
	echo "$output" | egrep "Removing .*_cli_1"

	echo "$output" | egrep "Removing network .*_default"
	echo "$output" | egrep "Removing volume .*_project_root"
	echo "$output" | grep "Volume docksal_ssh_agent is external, skipping"

	echo "$output" | egrep "Creating .*_web_1"
	echo "$output" | egrep "Creating .*_db_1"
	echo "$output" | egrep "Creating .*_cli_1"

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
	echo "$output" | egrep "Drush Version   :  8.*"

	# Drush 6
	run fin exec drush6 --version
	echo "$output" | egrep "Drush Version   :  6.*"

	# Drush 7
	run fin exec drush7 --version
	echo "$output" | egrep "Drush Version   :  7.*"
}


@test "fin rm -f" {
	[[ $SKIP == 1 ]] && skip
	
	# First run
	run fin rm -f
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"

	echo "$output" | egrep "Removing .*_web_1"
	echo "$output" | egrep "Removing .*_db_1"
	echo "$output" | egrep "Removing .*_cli_1"

	echo "$output" | egrep "Removing network .*_default"
	echo "$output" | egrep "Removing volume .*_project_root"
	echo "$output" | grep "Volume docksal_ssh_agent is external, skipping"

	# Check that there are no containers
	run fin ps
	[[ "$(echo "$output" | tail -n +3)" == "" ]]
}

@test "fin config" {
	[[ $SKIP == 1 ]] && skip

	# Check default Drupal 8 config (check if environment variables are used in docksal.yml)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: drupal8.docksal"
	echo "$output" | egrep "MYSQL_DATABASE: default"
}

@test "fin config local env file" {
	[[ $SKIP == 1 ]] && skip

	# Preparation step - create local env file
	echo "VIRTUAL_HOST=testenv.docksal" > .docksal/docksal-local.env

	# Check config (check if local environment variables are used in docksal.yml)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: testenv.docksal"
}

@test "fin config local yml file" {
	[[ $SKIP == 1 ]] && skip

	# Preparation step - create local yml file (replace DB)
	yml="
version: '2.1'

services:
  db:
    environment:
      - MYSQL_ROOT_PASSWORD=testpass
  "

	echo "$yml" > .docksal/docksal-local.yml

	# Check config (check if local yml replaces db password in docksal.yml, and other parts are the same)
	run fin config
	echo "$output" | egrep "MYSQL_ROOT_PASSWORD: testpass"
	echo "$output" | egrep "VIRTUAL_HOST: testenv.docksal"
	echo "$output" | egrep "MYSQL_DATABASE: default"
}

@test "fin config local yml and local env files" {
	[[ $SKIP == 1 ]] && skip

	# Preparation step - create local yml and local env files
	yml="
version: '2.1'

services:
  web:
    environment:
      - VIRTUAL_HOST=$"
  yml="$yml{DOCKSAL_HOST}"

	echo "$yml" > .docksal/docksal-local.yml
	echo "DOCKSAL_HOST=newvariable.docksal" > .docksal/docksal-local.env

	# Check config (check if local yml replaces web virtual host and uses new local variable, old variables must work as previously)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: newvariable.docksal"
	echo "$output" | egrep "io.docksal.virtual-host: drupal8.docksal"
}
