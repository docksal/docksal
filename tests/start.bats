#!/usr/bin/env bats

load fin_script

@test "Checking fin start" {
	fin start
}

@test "Checking output of fin start" {
	run fin start

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking output of fin up" {
	run fin up

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking fin _start_containters function" {
	run _start_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

