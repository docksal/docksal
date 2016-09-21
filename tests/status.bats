#!/usr/bin/env bats

load fin_script

@test "Checking fin status" {
	fin status
}

@test "Checking fin st" {
	fin st
}

@test "Checking fin ps" {
	fin ps
}

@test "Checking fin status -a" {
	fin status -a
}

@test "Checking fin status" {
	fin status -all
}

@test "Checking fin status output" {
	run fin status

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
	[[ ${lines[4]} =~ "drupal7" ]]
}

@test "Checking fin st output" {
	run fin st

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
	[[ ${lines[4]} =~ "drupal7" ]]
}

@test "Checking fin ps output" {
	run fin ps

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "drupal7" ]]
	[[ ${lines[3]} =~ "drupal7" ]]
	[[ ${lines[4]} =~ "drupal7" ]]
}

@test "Checking fin status -a output" {
	run fin status -a

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "IMAGE" ]]
	[[ ${lines[1]} =~ "blinkreaction" ]]
	[[ ${lines[2]} =~ "blinkreaction" ]]
	[[ ${lines[3]} =~ "blinkreaction" ]]
}
