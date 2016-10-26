#!/usr/bin/env bats

load fin_script

# Check if all necessary lines in the output.
check_start_output() {
	[[ $output == *"Starting services..."* ]]
	[[ $output == *"Starting drupal7_cli"* ]]
	[[ $output == *"Starting drupal7_db"* ]]
	[[ $output == *"Starting drupal7_web"* ]]
}

@test "Checking fin start" {
	# Stop containers (result of this command will be skipped).
	fin stop || echo ''

	# Check if containers are not running.
	docker_check_not_runnign

	# Run command.
	fin start

	# Check if containers are running.
	docker_check_runnign
}

@test "Checking output of fin start" {
	# Stop containers (result of this command will be skipped).
	fin stop || echo ''

	# Check if containers are not running.
	docker_check_not_runnign

	# Run command.
	run fin start

	# Check if run is success.
	[ $status -eq 0 ]

	# Check if all necessary lines in the output.
	check_start_output

	# Check if containers are running.
	docker_check_runnign
}

@test "Checking output of fin up" {
	# Stop containers (result of this command will be skipped).
	fin stop || echo ''

	# Check if containers are not running.
	docker_check_not_runnign

	# Run command.
	run fin up

	# Check if run is success.
	[ $status -eq 0 ]

	# Check if all necessary lines in the output.
	check_start_output

	# Check if containers are running.
	docker_check_runnign
}

@test "Checking fin _start_containters function" {
	# Stop containers (result of this command will be skipped).
	fin stop || echo ''

	# Check if containers are not running.
	docker_check_not_runnign

	# Run command.
	run _start_containers

	# Check if run is success.
	[ $status -eq 0 ]

	# Check if all necessary lines in the output.
	check_start_output

	# Check if containers are running.
	docker_check_runnign
}

