#!/usr/bin/env bats

load fin_script

@test "Checking fin restart" {
	fin restart
}

@test "Checking output of fin restart" {
	run fin restart

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting drupal7" ]]
	[[ ${lines[2]} =~ "Restarting drupal7" ]]
	[[ ${lines[3]} =~ "Restarting drupal7" ]]
}

@test "Checking fin _restart_containers function" {
	run _restart_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting drupal7" ]]
	[[ ${lines[2]} =~ "Restarting drupal7" ]]
	[[ ${lines[3]} =~ "Restarting drupal7" ]]
}

