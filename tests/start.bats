#!/usr/bin/env bats

load dsh_script

@test "Checking dsh start" {
	dsh start
}

@test "Checking output of dsh start" {
	run dsh start

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking output of dsh up" {
	run dsh up

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking dsh _start_containters function" {
	run _start_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Starting services..." ]]
	[[ ${lines[1]} =~ "druded7testing" ]]
	[[ ${lines[2]} =~ "druded7testing" ]]
	[[ ${lines[3]} =~ "druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

