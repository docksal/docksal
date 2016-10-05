#!/usr/bin/env bats

load fin_script

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

@test "Checking check_binary_found function. Case#1: existing binary" {
	run check_binary_found 'docker'

	[ $status -eq 0 ]
}

@test "Checking check_binary_found function. Case#2: fake binary" {
	run check_binary_found 'fake_binary'

	[ $status -eq 1 ]
}