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
SKIP=1

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
	unset output

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
	unset output
}

@test "fin init" {
	[[ $SKIP == 1 ]] && skip

	run fin init
	# Do not do unset output to preserve logs from this command
	#unset output

	# Check if site is available and its name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
	unset output
}

@test "fin namespace/custom-command" {
	[[ $SKIP == 1 ]] && skip

	mkdir .docksal/commands/team
	cat <<EOF > .docksal/commands/team/test
'#!/bin/bash
echo "Test Command"
EOF
	chmod +x .docksal/commands/team/test

	run fin team/test
	[[ "${output}" == "Test Command" ]]
	unset output
}

@test "fin stop" {
	[[ $SKIP == 1 ]] && skip
	
	run fin stop
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"
	unset output

	# Check that containers are stopped
	run fin ps
	# Sometimes containers would not exit with code 0 (graceful stop), but 137 instead (when docker has to kill the process). 
	echo "$output" | egrep ".*_web_1 .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_db_1 .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_cli_1 .* (Exit 0|Exit 137)"
	unset output
	
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
	unset output

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
	unset output
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
	unset output

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
	unset output
}

@test "fin exec" {
	[[ $SKIP == 1 ]] && skip
	
	run fin exec uname -a
	[[ "$output" =~ "Linux cli" ]]
	unset output
	
	# Test output in TTY vs no-TTY mode.
	[[ "$(fin exec echo)" != "$(fin exec -T echo)" ]]

	# Test the no-TTY output is a "clean" string (does not have extra control characters and can be compared)
	run fin exec -T pwd
	[[ "$output" == "/var/www" ]]
	unset output

	# Test that switching directories on host carries over into cli
	cd docroot
	run fin exec -T pwd
	[[ "$output" == "/var/www/docroot" ]]
	unset output

	# fin exec uses the docker user
	run fin exec -T id -un
	[[ "$output" == "docker" ]]
	unset output

	# docker user uid/gid in cli matches the host user uid/gid
	run fin exec -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
	unset output

	# setting target container with --in
	run fin exec --in=web -T cat /etc/hostname
	[[ "$output" == "web" ]]
	unset output
}

@test "fin run-cli" {
	#[[ $SKIP == 1 ]] && skip

	# Dummy command to pre-pull the image run-cli is using.
	fin rc uname

	# Test output in TTY vs no-TTY mode.
	[[ "$(fin rc echo)" != "$(fin rc -T echo)" ]]

	# fin rc uses the docker user
	run fin rc -T id -un
	[[ "$output" == "docker" ]]
	unset output

	# docker user uid/gid in cli matches the host user uid/gid
	run fin rc -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
	unset output

	# check to make sure custom variables are passed into container
	run fin rc -T -e TEST_VAR="TEST VARIABLES" "echo \$TEST_VAR"
	[[ "$output" == "TEST VARIABLES" ]]
	unset output

	# check to make sure a global default variable (from $HOME/.docksal/docksal.env) is passed automatically.
	# These are SECRET_ and some other variables passed by default.
	echo "SECRET_SSH_PRIVATE_KEY=xyz" >> $HOME/.docksal/docksal.env
	run fin rc -T "echo \$SECRET_SSH_PRIVATE_KEY"
	[[ "$output" == "xyz" ]]
	unset output

	# Check to make sure a global default variable can be overridden
	run fin rc -T -e SECRET_SSH_PRIVATE_KEY="abc" "echo \$SECRET_SSH_PRIVATE_KEY"
	[[ "$output" == "abc" ]]
	unset output

	# check to make sure a global (non-default) variable can be passed if included in command
	echo "TEST=1234" >> $HOME/.docksal/docksal.env
	run fin rc -T -e TEST "echo \$TEST"
	[[ "$output" == "1234" ]]
	unset output

	# Check persistent volume
	fin rc touch /home/docker/test
	run fin rc -T ls /home/docker/test
	[[ "$output" == "/home/docker/test" ]]
	unset output

	# Check one-off volume --clean
	fin rc touch /home/docker/test
	run fin rc --clean -T ls /home/docker/test
	[[ "$output" == "ls: cannot access '/home/docker/test': No such file or directory" ]]
	unset output

	# Check --cleanup persistent volume
	fin rc touch /home/docker/test
	run fin rc --cleanup -T ls /home/docker/test
	[[ "$output" == "ls: cannot access '/home/docker/test': No such file or directory" ]]
	unset output
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
	unset output

	# Check that there are no containers
	run fin ps
	[[ "$(echo "$output" | tail -n +3)" == "" ]]
	unset output
}

@test "fin config" {
	[[ $SKIP == 1 ]] && skip

	# Check default Drupal 8 config (check if environment variables are used in docksal.yml)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: drupal8.docksal"
	echo "$output" | egrep "MYSQL_DATABASE: default"
	unset output
}

@test "fin config local env file" {
	[[ $SKIP == 1 ]] && skip

	# Preparation step - create local env file
	echo "VIRTUAL_HOST=testenv.docksal" > .docksal/docksal-local.env

	# Check config (check if local environment variables are used in docksal.yml)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: testenv.docksal"
	unset output
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
	unset output
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
	unset output
}

@test "fin virtual host with non standard hostname characters" {
	[[ $SKIP == 1 ]] && skip

	# Preparation step - create local env file
	echo "VIRTUAL_HOST=feaTures.Alpha-beta_zulu.docksal" > .docksal/docksal-local.env

	# Check config (check if local environment variables are used in docksal.yml)
	run fin config
	echo "$output" | egrep "VIRTUAL_HOST: features.alpha-beta-zulu.docksal"
	[[ $(echo "$output" | grep -c "feaTures.Alpha-beta_zulu.docksal") -eq 0 ]]
	[[ "${output}" =~ "The VIRTUAL_HOST has been modified from feaTures.Alpha-beta_zulu.docksal to features.alpha-beta-zulu.docksal to comply with browser standards." ]]
	unset output
}