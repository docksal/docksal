#!/usr/bin/env bats

load fin_script

@test "Checking fin start" {
	fin start
}

@test "Checking output of fin start" {
	run fin start

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "drupal7" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
}

@test "Checking output of fin up" {
	run fin up

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "drupal7" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
}

@test "Checking fin _start_containters function" {
	run _start_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "drupal7" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
}

