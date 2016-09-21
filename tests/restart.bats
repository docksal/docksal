#!/usr/bin/env bats

load dsh_script

@test "Checking dsh restart" {
	dsh restart
}

@test "Checking output of dsh restart" {
	run dsh restart

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting druded7testing" ]]
	[[ ${lines[2]} =~ "Restarting druded7testing" ]]
	[[ ${lines[3]} =~ "Restarting druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

@test "Checking dsh _restart_containers function" {
	run _restart_containers

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Restarting services..." ]]
	[[ ${lines[1]} =~ "Restarting druded7testing" ]]
	[[ ${lines[2]} =~ "Restarting druded7testing" ]]
	[[ ${lines[3]} =~ "Restarting druded7testing" ]]
	[[ ${lines[4]} =~ "Connecting vhost-proxy to networks..." ]]
	[[ ${lines[5]} =~ "Container and host" ]]
}

