#!/usr/bin/env bats

load dsh_script

@test "Checking dsh exec pwd" {
	dsh exec pwd
}

@test "Checking output of dsh exec pwd" {
	run dsh exec pwd

	[ $status -eq 0 ]
	[[ $output =~ "/var/www" ]]
}

@test "Checking output of dsh exec uname -r" {
	run dsh exec uname -r

	[ $status -eq 0 ]
	[[ $output =~ "3.19.0-56-generic" ]]
}

@test "Checking dsh _run function - pwd test" {
	run _run pwd

	[ $status -eq 0 ]
	[[ $output =~ "/var/www" ]]
}

@test "Checking dsh _run function - uname test" {
	run _run uname -r

	[ $status -eq 0 ]
	[[ $output =~ "3.19.0-56-generic" ]]
}