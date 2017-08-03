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

# Cannot do cleanup outside of a test case as bats will evaluate/run that code before every single test case.
@test "uber cleanup" {
	[[ $SKIP == 1 ]] && skip

	fin rm -f
	return 0
}

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


@test "fin mysql-list" {
	[[ $SKIP == 1 ]] && skip

	run fin mysql-list
	echo "$output" | grep "mysql"
}

@test "fin mysql-dump with no params" {
	[[ $SKIP == 1 ]] && skip

	# Create backup
	rm -f dump.sql
	run fin mysql-dump dump.sql
    echo "$output" | grep "Exporting..."

	# Check that we've got a valid dump
	run grep "Database: default" dump.sql
    [ $status -eq 0 ]
}

@test "fin mysql-dump with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Create backup
    rm -f dump.sql
	run fin mysql-dump dump.sql --db-user="user" --db-password="user"
    echo "$output" | grep "Exporting..."

	# Check that we've got a valid dump
	run grep "Database: default" dump.sql
    [ $status -eq 0 ]
}

@test "fin mysql-import with no params" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
    run fin mysql-import dump.sql --force
    echo "$output" | grep "Truncating"
    echo "$output" | grep "Importing"

	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-import with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="user" --db-password="user" --force
    echo "$output" | grep "Truncating"
    echo "$output" | grep "Importing"

	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-import with the wrong user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="wrong-user" --db-password="wrong-password" --force
    echo "$output" | grep "Truncating"
    echo "$output" | grep "Importing"
    echo "$output" | grep "Import failed"
}

@test "fin mysql-import into different db" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="user" --db-password="user" --db="nondefault" --force
	echo "$output" | grep "Truncating" | grep "nondefault"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Import failed"
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
	
	# Test output in TTY vs no-TTY mode.
	[[ "$(fin exec echo)" != "$(fin exec -T echo)" ]]

	# Test the no-TTY output is a "clean" string (does not have extra control characters and can be compared)
	run fin exec -T pwd
	[[ "$output" == "/var/www" ]]

	# Test that switching directories on host carries over into cli
	cd docroot
	run fin exec -T pwd
	[[ "$output" == "/var/www/docroot" ]]

	# fin exec uses the docker user
	run fin exec -T id -un
	[[ "$output" == "docker" ]]

	# docker user uid/gid in cli matches the host user uid/gid
	run fin exec -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
}

@test "fin run-cli" {
	[[ $SKIP == 1 ]] && skip

	# Dummy command to pre-pull the image run-cli is using.
	fin rc uname

	# Test output in TTY vs no-TTY mode.
	[[ "$(fin rc echo)" != "$(fin rc -T echo)" ]]

	# fin rc uses the docker user
	run fin rc -T id -un
	[[ "$output" == "docker" ]]

	# docker user uid/gid in cli matches the host user uid/gid
	run fin rc -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
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
