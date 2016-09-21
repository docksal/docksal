#!/usr/bin/env bats

load dsh_script

@test "Checking dsh status" {
	dsh status
}

@test "Checking dsh st" {
	dsh st
}

@test "Checking dsh ps" {
	dsh ps
}

@test "Checking dsh status -a" {
	dsh status -a
}

@test "Checking dsh status" {
	dsh status -all
}

@test "Checking dsh status output" {
	run dsh status

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "druded7testing" ]]
}

@test "Checking dsh st output" {
	run dsh st

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "druded7testing" ]]
}

@test "Checking dsh ps output" {
	run dsh ps

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Name" ]]
	[[ ${lines[1]} =~ "---" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "druded7testing" ]]
}

@test "Checking dsh status -a output" {
	run dsh status -a

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "IMAGE" ]]
	[[ ${lines[1]} =~ "blinkreaction" ]]
	[[ ${lines[2]} =~ "blinkreaction" ]]
	[[ ${lines[3]} =~ "blinkreaction" ]]
}
