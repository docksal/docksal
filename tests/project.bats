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

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

# Cannot do cleanup outside of a test case as bats will evaluate/run that code before every single test case.
@test "uber cleanup" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	fin project rm -f
	rm -rf .docksal docroot
	echo "fin config generate" | bash
}

@test "fin project start" {
	[[ $SKIP == 1 ]] && skip

	run fin project start
	echo "$output" | egrep "Creating network \".*_default\" with the default driver"
	echo "$output" | egrep "Creating volume \".*_project_root\" with local driver"
	echo "$output" | egrep "Creating .*_web_1"
	echo "$output" | egrep "Creating .*_db_1"
	echo "$output" | egrep "Creating .*_cli_1"

	echo "$output" | egrep "Connected vhost-proxy to \".*_default\" network"
	unset output

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
	unset output
}

@test "fin project stop" {
	[[ $SKIP == 1 ]] && skip

	run fin project stop
	echo "$output" | egrep "Stopping .*_web_1"
	echo "$output" | egrep "Stopping .*_db_1"
	echo "$output" | egrep "Stopping .*_cli_1"
	unset output

	# Check that containers are stopped
	run fin ps
	# Sometimes containers would not exit with code 0 (graceful stop), but 137 instead (when docker has to kill the process).
	echo "$output" | egrep ".*_web_1.* .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_db_1.* .* (Exit 0|Exit 137)"
	echo "$output" | egrep ".*_cli_1.* .* (Exit 0|Exit 137)"
	unset output

	# Start containers back
	fin start
}

@test "fin project restart" {
	[[ $SKIP == 1 ]] && skip

	run fin project restart
	echo "$output" | egrep "Stopping .*_web_1.*"
	echo "$output" | egrep "Stopping .*_db_1.*"
	echo "$output" | egrep "Stopping .*_cli_1.*"

	echo "$output" | egrep "Starting .*_web_1.*"
	echo "$output" | egrep "Starting .*_db_1.*"
	echo "$output" | egrep "Starting .*_cli_1.*"
	unset output

	# Check that containers are running
	run fin ps
	echo "$output" | grep "web_1" | grep "Up"
	echo "$output" | grep "db_1" | grep "Up"
	echo "$output" | grep "cli_1" | grep "Up"
	unset output
}

# TODO: this should be "fin project exec"
@test "fin exec" {
	[[ $SKIP == 1 ]] && skip

	run fin exec uname -a
	[[ "$output" =~ "Linux cli" ]]
	unset output

	# Test output in TTY vs no-TTY mode.
	# This test used to work in Travis CI, since Travis emulated a TTY environment.
	# It does not pass with Github Actions. Commented out.
	# [[ "$(fin exec echo)" != "$(fin exec -T echo)" ]]

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
	run fin exec -T --in=web cat /etc/hostname
	[[ "$output" == "web" ]]
	unset output
}

@test "fin project reset -f" {
	[[ $SKIP == 1 ]] && skip

	run fin project reset -f
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

@test "fin project remove -f" {
	[[ $SKIP == 1 ]] && skip

	# First run
	run fin project remove -f
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
	# Using "fin docker-compose ps" here to skip additional processing and output added by "fin ps"
	run fin docker-compose ps
	[[ "$(echo "$output" | tail -n +3)" == "" ]]
	unset output
}

@test "fin init (built-in)" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	rm -rf .docksal docroot
	vhost="test-project.${DOCKSAL_DNS_DOMAIN}"

	# Test
	# Run non-interactively to skip prompts
	run bash -c "echo 'fin init' | bash"
	echo "$output" | grep "Configuration was generated."
	echo "$output" | grep "http://${vhost}"
	unset output

	# Check if site is available and its name is correct
	run curl -sLI "http://${vhost}"
	echo "$output" | grep "X-Powered-By: PHP"
	unset output
}
