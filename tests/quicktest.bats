#!/usr/bin/env bats

@test "fin quicktest" {
	cd ../test-init
	run fin init
	echo "$output" | grep "http://testinit.docksal"
	unset output

	# Check if site is available and its name is correct
	run curl -sL http://testinit.docksal
	echo "$output" | grep "<title>phpinfo"
	unset output
}
