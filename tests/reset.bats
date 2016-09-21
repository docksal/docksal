#!/usr/bin/env bats

load fin_script

@test "Checking fin reset -f" {
	fin reset -f
}

@test "Checking output of fin reset -f" {
	run fin reset -f

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Removing containers..." ]]
	[[ ${lines[1]} =~ "Killing drupal7" ]]
	[[ ${lines[2]} =~ "Killing drupal7" ]]
	[[ ${lines[3]} =~ "Killing drupal7" ]]
	[[ ${lines[4]} =~ "Removing drupal7" ]]
	[[ ${lines[5]} =~ "Removing drupal7" ]]
	[[ ${lines[6]} =~ "Removing drupal7" ]]
}

@test "Checking output of fin reset cli" {
	run fin reset cli

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing drupal7" ]]
	[[ ${lines[1]} =~ "Removing drupal7" ]]
}

@test "Checking output of fin reset db" {
	run fin reset db

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing drupal7" ]]
	[[ ${lines[1]} =~ "Removing drupal7" ]]
}

@test "Checking output of fin reset web" {
	run fin reset web

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing drupal7" ]]
	[[ ${lines[1]} =~ "Removing drupal7" ]]
}

@test "Checking fin remove function" {
	run remove -f

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Removing containers..." ]]
	[[ ${lines[1]} =~ "Killing drupal7" ]]
	[[ ${lines[2]} =~ "Killing drupal7" ]]
	[[ ${lines[3]} =~ "Killing drupal7" ]]
	[[ ${lines[4]} =~ "Removing drupal7" ]]
	[[ ${lines[5]} =~ "Removing drupal7" ]]
	[[ ${lines[6]} =~ "Removing drupal7" ]]

	# Rerun containers after removing.
	fin up > /dev/null
}

