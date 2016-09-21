#!/usr/bin/env bats

load fin_script

@test "Checking fin ssh-add -D" {
	fin ssh-add -D
}

@test "Checking fin ssh-add -l" {
	run fin ssh-add -l

	[ $status -eq 1 ]
}

@test "Checking fin ssh-add bats_rsa" {
	cp ../drude/tests/ssh-key/* ~/.ssh
	fin ssh-add bats_rsa
}

@test "Checking fin ssh-add: key doesn't exist" {
	run fin ssh-add doesnt_exist_rsa

	[ $status -eq 1 ]
	[[ $output =~ "/.ssh/doesnt_exist_rsa: No such file or directory" ]]
}

@test "Checking fin ssh-add -l (one key)" {
	run fin ssh-add -l

	[ $status -eq 0 ]
	[[ $output =~ "4096 SHA256" ]]
}

@test "Checking fin ssh-add -D" {
	run fin ssh-add -D

	[ $status -eq 0 ]
	[[ $output =~ "All identities removed." ]]
}

@test "Checking fin ssh-add -l (no keys)" {
	run fin ssh-add -l

	[ $status -eq 1 ]
	[[ $output =~ "The agent has no identities." ]]
}

@test "Checking fin ssh_add function" {
	run ssh_add bats_rsa

	[ $status -eq 0 ]
}