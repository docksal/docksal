#!/usr/bin/env bats

load dsh_script

@test "Checking dsh stop" {
	dsh start
}

@test "Checking output of dsh stop" {
	run dsh stop

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

@test "Checking output of dsh down" {
	run dsh down

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

@test "Checking dsh _stop_containers function" {
	run _stop_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Stopping services..." ]]
}

