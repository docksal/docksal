#!/usr/bin/env bats

load fin_script

@test "Checking fin exec pwd" {
	fin exec pwd
}

@test "Checking output of fin exec pwd" {
	run fin exec pwd

	[ $status -eq 0 ]
	[[ $output =~ "/var/www" ]]
}

@test "Checking output of fin exec uname -r" {
	run fin exec uname -r

	[ $status -eq 0 ]
	[[ $output =~ "3.19.0-56-generic" ]]
}

@test "Checking fin _run function - pwd test" {
	run _run pwd

	[ $status -eq 0 ]
	[[ $output =~ "/var/www" ]]
}

@test "Checking fin _run function - uname test" {
	run _run uname -r

	[ $status -eq 0 ]
	[[ $output =~ "3.19.0-56-generic" ]]
}