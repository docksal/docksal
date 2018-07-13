#!/usr/bin/env bats

@test "fin quicktest" {
	cd ../test-init
	run fin init
	echo "$output" | egrep "http://test-init.docksal"
	unset output

	# Check if site is available and its name is correct
	run curl -sL http://test-init.docksal
	echo "$output" | egrep "<title>phpinfo"
	unset output
}
