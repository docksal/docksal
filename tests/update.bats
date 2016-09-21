#!/usr/bin/env bats

load fin_script

@test "Checking fin update" {
	fin update
}

@test "Checking fin update output" {
	run fin update

	[ $status -eq 0 ]
	[[ $output =~ "Use fin update" ]]
	[[ $output =~ "prerequisites" ]]
	[[ $output =~ "boot2docker" ]]
	[[ $output =~ "images" ]]
	[[ $output =~ "dsh" ]]
}