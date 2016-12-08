#!/usr/bin/env bats

load fin_script

# Check if all necessary lines in the output.
check_stop_output() {
	[[ $output == *"Stopping services..."* ]]
	[[ $output == *"Stopping drupal7_cli"* ]]
	[[ $output == *"Stopping drupal7_db"* ]]
	[[ $output == *"Stopping drupal7_web"* ]]
}

@test "Checking fin stop" {
	# Start containers (result of this command will be skipped).
	fin start || echo ''

	# Check if containers are running.
	docker_check_running

	# Run command.
	fin stop

	# Check if containers are not running.
	docker_check_not_running
}

@test "Checking output of fin stop" {
	# Start containers (result of this command will be skipped).
	fin start || echo ''

	# Check if containers are running.
	docker_check_running

	# Run command.
	run fin stop

	# Check if run is success.
	[ $status -eq 0 ]

	# Check if all necessary lines in the output.
	check_stop_output

	# Check if containers are not running.
	docker_check_not_running
}

@test "Checking fin _stop_containers function" {
	# Start containers (result of this command will be skipped).
	fin start || echo ''

	# Check if containers are running.
	docker_check_running

	# Run command.
	run _stop_containers

	# Check if run is success.
	[ $status -eq 0 ]

	# Check if all necessary lines in the output.
	check_stop_output

	# Check if containers are not running.
	docker_check_not_running
}
