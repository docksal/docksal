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

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

# Cannot do cleanup outside of a test case as bats will evaluate/run that code before every single test case.
@test "uber cleanup" {
	[[ $SKIP == 1 ]] && skip

	rm -rf .docksal
	return 0
}

@test "fin config: empty project" {
	[[ $SKIP == 1 ]] && skip

	run fin config env
	# Should through an error with an empty project
	[[ $status != 0 ]]
}

@test "fin config: zero configuration" {
	[[ $SKIP == 1 ]] && skip

	# Create .docksal folder necessary for the zero-config setup
	mkdir .docksal

	run fin config env
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] &&
	[[ $output =~ "stack-default.yml" ]] &&
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]]
	unset output
}

@test "fin config: zero configuration + stack option" {
	[[ $SKIP == 1 ]] && skip

	# Define which stack we want to use
	echo 'DOCKSAL_STACK=acquia' > .docksal/docksal.env

	run fin config env
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] && 
	[[ $output =~ "stack-acquia.yml" ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]]
	unset output
}

@test "fin config: zero configuration + stack option + docksal.yml" {
	[[ $SKIP == 1 ]] && skip

	# Add a stack override via docksal.yml
	yml="
version: '2.1'

services:
  web:
	environment:
	  - TEST_VAR=test_val"

	echo "$yml" > .docksal/docksal.yml

	run fin config
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] && 
	[[ $output =~ "stack-acquia.yml" ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]] && 
	[[ $output =~ "TEST_VAR: test_val" ]]
	unset output
}

@test "fin config: docksal.yml" {
	[[ $SKIP == 1 ]] && skip

	# cleanup here
	rm -rf .docksal
	mkdir .docksal

	# Add a stack override via docksal.yml
	yml="
version: '2.1'

services:
  web:
	image: nginx
	environment:
	  - TEST_VAR="'${TEST_VAR:-test_val_default}'

	echo "$yml" > .docksal/docksal.yml

	run fin config
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] && 
	[[ ! $output =~ "stack-default.yml" ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]] &&
	[[ $output =~ "TEST_VAR: test_val_default" ]]
	unset output
}

@test "fin config: docksal.yml + docksal.env" {
	[[ $SKIP == 1 ]] && skip

	# Override TEST_VAR
	echo 'TEST_VAR=my_val' > .docksal/docksal.env

	run fin config
	[[ $status == 0 ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]] &&
	# Test our override is in place
	[[ $output =~ "TEST_VAR: my_val" ]]
	unset output
}

@test "fin config: docksal-local.yml" {
	[[ $SKIP == 1 ]] && skip

	# Add a stack override via docksal.yml
	yml="
version: '2.1'

services:
  web:
	image: nginx
	environment:
	  - TEST_VAR_LOCAL="'${TEST_VAR_LOCAL:-test_val_default}'

	echo "$yml" > .docksal/docksal-local.yml

	run fin config
	[[ $status == 0 ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]] &&
	[[ $output =~ "docksal-local.yml" ]] &&
	[[ ! $output =~ "docksal-local.env" ]] && 
	[[ $output =~ "TEST_VAR_LOCAL: test_val_default" ]]
	unset output
}

@test "fin config: docksal-local.yml + docksal-local.env" {
	[[ $SKIP == 1 ]] && skip

	# Override TEST_VAR_LOCAL
	echo 'TEST_VAR_LOCAL=my_val_local' > .docksal/docksal-local.env

	run fin config
	[[ $status == 0 ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]] &&
	[[ $output =~ "docksal-local.yml" ]] &&
	[[ $output =~ "docksal-local.env" ]] && 
	# Test our override is in place
	[[ $output =~ "TEST_VAR_LOCAL: my_val" ]]
	unset output
}

@test "fin config generate: empty project" {
	[[ $SKIP == 1 ]] && skip

	# cleanup here
	rm -rf .docksal
	fin config generate

	run fin config env
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] && 
	[[ $output =~ "stack-default.yml" ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]]
	unset output
}

@test "fin config generate: existing project" {
	[[ $SKIP == 1 ]] && skip

	echo "fin config generate" | bash

	run fin config env
	[[ $status == 0 ]] && 
	[[ $output =~ "volumes-bind.yml" ]] && 
	[[ $output =~ "stack-default.yml" ]] && 
	# fin will automatically create docksal.yml and docksal.env if they do not exist
	[[ $output =~ "docksal.yml" ]] &&
	[[ $output =~ "docksal.env" ]]
	unset output
}

# Global

@test "fin config set: global file" {
	[[ $SKIP == 1 ]] && skip

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.orig"
	# Test command can run with --global
	run fin config set --global TEST_VAR=12345
	[[ $status == 0 ]] &&
	[[ $output =~ "Added value for TEST_VAR into ${HOME}/.docksal/docksal.env" ]]
	source "${HOME}/.docksal/docksal.env"
	# Testing what value is
	[[ "$TEST_VAR" == "12345" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.orig" "${HOME}/.docksal/docksal.env"
}

@test "fin config replace: global file" {
	[[ $SKIP == 1 ]] && skip

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.orig"
	echo "TEST_VAR=1" >> "${HOME}/.docksal/docksal.env"
	run fin config set --global TEST_VAR=54321
	[[ $status == 0 ]] && [[ "$output" =~ "Replaced value for TEST_VAR in ${HOME}/.docksal/docksal.env" ]]

	source "${HOME}/.docksal/docksal.env"
	[[ "$TEST_VAR" == "54321" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.orig" "${HOME}/.docksal/docksal.env"
}

@test "fin config remove: global file" {
	[[ $SKIP == 1 ]] && skip

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.orig"

	echo "TEST_VAR=123456" >> ${HOME}/.docksal/docksal.env
	run fin config remove --global TEST_VAR
	[[ $status == 0 ]] && [[ "$output" =~ "Removing TEST_VAR from ${HOME}/.docksal/docksal.env" ]]

	source "${HOME}/.docksal/docksal.env"
	[[ -z "$TEST_VAR" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.orig" "${HOME}/.docksal/docksal.env"
}

@test "fin config remove: global file variable does not exist" {
	[[ $SKIP == 1 ]] && skip

	run fin config remove --global TEST_VAR
	[[ $status == 0 ]] &&
	[[ $output =~ "Could not find TEST_VAR in ${HOME}/.docksal/docksal.env" ]]

	unset output
}

# Project

@test "fin config set: project docksal.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	run fin config set TEST=23456
	local project=$(pwd)
	[[ $status == 0 ]] &&
	[[ $output =~ "Added value for TEST into ${project}/.docksal/docksal.env" ]]

	source "${project}/.docksal/docksal.env"
	[[ "$TEST" == "23456" ]]
	unset output

	# cleanup
}

@test "fin config replace: project docksal.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	local project=$(pwd)
	echo "TEST=1" >> "${project}/.docksal/docksal.env"
	run fin config set TEST=65432
	[[ $status == 0 ]] && [[ "$output" =~ "Replaced value for TEST in ${project}/.docksal/docksal.env" ]]

	source "${project}/.docksal/docksal.env"
	[[ "$TEST" == "65432" ]]
	unset output
}

@test "fin config remove: project docksal.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	echo "TEST=126534" >> .docksal/docksal.env

	run fin config remove TEST
	local project=$(pwd)
	[[ $status == 0 ]] && [[ "$output" =~ "Removing TEST from ${project}/.docksal/docksal.env" ]]

	source "${project}/.docksal/docksal.env"
	[[ -z "$TEST" ]]
	unset output
}

@test "fin config remove: project file variable does not exist" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	local project=$(pwd)
	run fin config remove TEST
	[[ $status == 0 ]] &&
	[[ $output =~ "Could not find TEST in ${project}/.docksal/docksal.env" ]]
	unset output
}

# Project Local

@test "fin config set: project docksal-ENV.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	run fin config set --env=local TEST=34567
	local project=$(pwd)
	[[ $status == 0 ]] &&
	[[ $output =~ "Added value for TEST into ${project}/.docksal/docksal-local.env" ]]

	source "${project}/.docksal/docksal-local.env"
	[[ "$TEST" == "34567" ]]
	unset output
}

@test "fin config replace: project docksal-ENV.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	local project=$(pwd)
	echo "TEST=1" >> "${project}/.docksal/docksal-local.env"
	run fin config set --env=local TEST=76543
	[[ $status == 0 ]] &&
	[[ "$output" =~ "Replaced value for TEST in ${project}/.docksal/docksal-local.env" ]]

	source "${project}/.docksal/docksal-local.env"
	[[ "$TEST" == "76543" ]]
	unset output
}

@test "fin config remove: project docksal-ENV.env file" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	echo "TEST=126534" >> .docksal/docksal-local.env

	run fin config remove --env=local TEST
	local project=$(pwd)
	[[ $status == 0 ]] &&
	[[ $output =~ "Removing TEST from ${project}/.docksal/docksal-local.env" ]]

	source "${project}/.docksal/docksal-local.env"
	[[ -z "$TEST" ]]
	unset output
}

@test "fin config remove: project env file variable does not exist" {
	[[ $SKIP == 1 ]] && skip

	# cleanup
	rm -rf .docksal
	mkdir .docksal

	local project=$(pwd)
	run fin config remove --env=local TEST
	[[ $status == 0 ]] &&
	[[ $output =~ "Could not find TEST in ${project}/.docksal/docksal-local.env" ]]
	unset output
}