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

@test "Start project1" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p 'project1/.docksal'
	cd 'project1'
	fin start
	run fin project list
	echo "$output" | grep 'project1'
	unset output
}

# create project name conflict
@test "Try starting project1 duplicate" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p 'duplicate/project1/.docksal'
	cd 'duplicate/project1'
	run fin start
	[ ! $status -eq 0 ]
	unset output
}

# create VIRTUAL_HOST conflict
@test "Try starting project1 VIRTUAL_HOST conflict" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p 'project2/.docksal'
	echo 'VIRTUAL_HOST=project1.docksal.site' > 'project2/.docksal/docksal.env'
	cd 'project2'
	run fin start
	[ ! $status -eq 0 ]
	unset output
}
