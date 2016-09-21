#!/usr/bin/env bats

load dsh_script

@test "Checking is_linux function." {
	# Value from preset variable.
	[[ "$OS" = "linux" ]] && linux=0 || linux=1

	run is_linux

	# <debug section>
	echo "==============================================================="
	echo "Is linux: $linux"
	echo "OS: $OS"
	# </debug section>

	[ $status -eq $linux ]
}

@test "Checking is_windows function." {
	# Value from preset variable.
	[[ "$OS" = "win" ]] && win=0 || win=1

	run is_windows

	# <debug section>
	echo "==============================================================="
	echo "Is win: $win"
	echo "OS: $OS"
	# </debug section>

	[ $status -eq $win ]
}

@test "Checking is_boot2docker function." {
	# Check if boot2docker console (@todo upd this test)
	run bash -c 'uname -a|grep "boot2docker"'
	boot2socker=$output
	is_boot2socker=$([[ ! "$boot2docker" = '' ]] && echo 0 || echo 1)

	run is_boot2docker

	# <debug section>
	echo "==============================================================="
	echo "Is boot2docker: $is_boot2socker"
	# </debug section>

	[ $status -eq $is_boot2socker ]
}

@test "Checking is_mac function." {
	# Value from preset variable.
	[[ "$OS" = "mac" ]] && mac=0 || mac=1

	run is_mac

	# <debug section>
	echo "==============================================================="
	echo "Is mac: $mac"
	echo "OS: $OS"
	# </debug section>

	[ $status -eq $mac ]
}

@test "Checking is_docker_beta function. Case#1 Not beta version" {
	DOCKER_BETA=0
	run is_docker_beta

	[ $status -eq 1 ]
}

@test "Checking is_docker_beta function. Case#2 Beta version" {
	DOCKER_BETA=1
	run is_docker_beta

	[ $status -eq 0 ]
}

@test "Checking is_binary_found function. Case#1: existing binary" {
	run is_binary_found 'docker'

	[ $status -eq 0 ]
}

@test "Checking is_binary_found function. Case#2: fake binary" {
	run is_binary_found 'fake_binary'

	[ $status -eq 1 ]
}

@test "Checking check_binary_found function. Case#1: existing binary" {
	run check_binary_found 'docker'

	[ $status -eq 0 ]
}

@test "Checking check_binary_found function. Case#2: fake binary" {
	run check_binary_found 'fake_binary'

	[ $status -eq 1 ]
}