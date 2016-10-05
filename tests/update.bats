#!/usr/bin/env bats

load fin_script

@test "Checking fin update" {
	fin update
}

@test "Checking fin update output" {
	run fin update

	[ $status -eq 0 ]
	[[ $output =~ "fin update - Automated update of Docksal system components" ]]
	[[ $output =~ "fin update tools" ]]
	[[ $output =~ "fin update images" ]]
	[[ $output =~ "fin update self" ]]
}