#!/usr/bin/env bats

@test "fin quicktest" {
	ping 8.8.8.8 -c 5
	echo "Put your quick test here!"
}
