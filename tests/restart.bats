#!/usr/bin/env bats

load fin_script

@test "Checking fin restart" {
	fin restart
}

@test "Checking output of fin restart" {
	run fin restart

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting druded7testing" ]]
	[[ ${lines[2]} =~ "Restarting druded7testing" ]]
	[[ ${lines[3]} =~ "Restarting druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking fin _restart_containers function" {
	run _restart_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting druded7testing" ]]
	[[ ${lines[2]} =~ "Restarting druded7testing" ]]
	[[ ${lines[3]} =~ "Restarting druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

