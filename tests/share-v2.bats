#!/usr/bin/env bats

# Debugging
teardown() {
	echo "Status: $status"
	echo "Output:"
	echo "================================================================"
	for line in "${lines[@]}"; do
		echo $line
	done
	echo "================================================================"
}

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

@test "Start project stack" {
	[[ $SKIP == 1 ]] && skip

	fin start
	run fin project list
	echo "$output" | grep 'test-share-v2'
	unset output
}

@test "fin share-v2 start" {
	[[ $SKIP == 1 ]] && skip

	run fin share-v2 start 2>&1
	echo "$output" | grep '_cloudflared_1' | grep 'Started'
	echo "$output" | grep 'Public URL' | grep 'trycloudflare.com'
	unset output
}

@test "fin share-v2 status (Active)" {
	[[ $SKIP == 1 ]] && skip

	run fin share-v2 status
	echo "$output" | grep 'Status' | grep 'Active'
	echo "$output" | grep 'Public URL' | grep 'trycloudflare.com'
	unset output
}

@test "fin share-v2 stop" {
	[[ $SKIP == 1 ]] && skip

	run fin share-v2 stop 2>&1
	echo "$output" | grep '_cloudflared_1' | grep 'Removed'
	unset output
}

@test "fin share-v2 status (Inactive)" {
	[[ $SKIP == 1 ]] && skip

	run fin share-v2 status
	echo "$output" | grep 'Status' | grep 'Inactive'
	unset output
}
