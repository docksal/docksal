#!/usr/bin/env bats

@test "Start project1" {
	mkdir -p 'project1/.docksal'
	cd 'project1'
	fin start
	run fin projects
	echo "$output" | grep 'project1'
}

# create project name conflict
@test "Try starting project1 duplicate" {
	mkdir -p 'duplicate/project1/.docksal'
	cd 'duplicate/project1'
	run fin start
	[ ! $status -eq 0 ]
}

# create VIRTUAL_HOST conflict
@test "Try starting project1 VIRTUAL_HOST conflict" {
	mkdir -p 'project2/.docksal'
	echo 'VIRTUAL_HOST=project1.docksal' > 'project2/.docksal/docksal.env'
	cd 'project2'
	run fin start
	[ ! $status -eq 0 ]
}
