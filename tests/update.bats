#!/usr/bin/env bats

load dsh_script

@test "Checking dsh update" {
	dsh update
}

@test "Checking dsh update output" {
	run dsh update

	[ $status -eq 0 ]
	[[ $output =~ "Use dsh update" ]]
	[[ $output =~ "prerequisites" ]]
	[[ $output =~ "boot2docker" ]]
	[[ $output =~ "images" ]]
	[[ $output =~ "dsh" ]]
}