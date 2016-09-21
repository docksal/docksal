#!/usr/bin/env bats

load dsh_script

@test "Checking dsh reset -f" {
	dsh reset -f
}

@test "Checking output of dsh reset -f" {
	run dsh reset -f

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Removing containers..." ]]
	[[ ${lines[1]} =~ "Killing druded7testing" ]]
	[[ ${lines[2]} =~ "Killing druded7testing" ]]
	[[ ${lines[3]} =~ "Killing druded7testing" ]]
	[[ ${lines[4]} =~ "Removing druded7testing" ]]
	[[ ${lines[5]} =~ "Removing druded7testing" ]]
	[[ ${lines[6]} =~ "Removing druded7testing" ]]
}

@test "Checking output of dsh reset cli" {
	run dsh reset cli

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking output of dsh reset db" {
	run dsh reset db

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking output of dsh reset web" {
	run dsh reset web

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Killing druded7testing" ]]
	[[ ${lines[1]} =~ "Removing druded7testing" ]]
}

@test "Checking dsh remove function" {
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
	dsh up > /dev/null
}

