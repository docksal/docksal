#!/usr/bin/env bats

load fin_script

@test "Checking fin stop" {
	fin start
}

@test "Checking output of fin stop" {
	run fin stop

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

@test "Checking output of fin down" {
	run fin down

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

@test "Checking fin _stop_containers function" {
	run _stop_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

