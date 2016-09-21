#!/usr/bin/env bats

load fin_script

@test "Checking fin reset -f" {
	fin reset -f
}

@test "Checking output of fin reset -f" {
	run fin reset -f

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Removing containers..." ]]
	[[ ${lines[1]} =~ "Killing druded7testing" ]]
	[[ ${lines[2]} =~ "Killing druded7testing" ]]
	[[ ${lines[3]} =~ "Killing druded7testing" ]]
	[[ ${lines[4]} =~ "Removing druded7testing" ]]
	[[ ${lines[5]} =~ "Removing druded7testing" ]]
	[[ ${lines[6]} =~ "Removing druded7testing" ]]
}

@test "Checking output of fin reset cli" {
	run fin reset cli

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking output of fin reset db" {
	run fin reset db

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking output of fin reset web" {
	run fin reset web

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking fin remove function" {
	run remove -f

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Removing containers..." ]]
	[[ ${lines[1]} =~ "Killing druded7testing" ]]
	[[ ${lines[2]} =~ "Killing druded7testing" ]]
	[[ ${lines[3]} =~ "Killing druded7testing" ]]
	[[ ${lines[4]} =~ "Removing druded7testing" ]]
	[[ ${lines[5]} =~ "Removing druded7testing" ]]
	[[ ${lines[6]} =~ "Removing druded7testing" ]]

	# Rerun containers after removing.
	fin up > /dev/null
}

