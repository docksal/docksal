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

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.bak"
	# Test command can run with --global
	run fin config set --global TEST_VAR=12345
	[[ $status == 0 ]] &&
	[[ $output =~ "Added value for TEST_VAR into ${HOME}/.docksal/docksal.env" ]]
	source "${HOME}/.docksal/docksal.env"
	# Testing what value is
	[[ "$TEST_VAR" == "12345" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.bak" "${HOME}/.docksal/docksal.env"
}

@test "fin config replace: global file" {
	[[ $SKIP == 1 ]] && skip

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.bak"
	echo "TEST_VAR=1" >> "${HOME}/.docksal/docksal.env"
	run fin config set --global TEST_VAR=54321
	[[ $status == 0 ]] && [[ "$output" =~ "Replaced value for TEST_VAR in ${HOME}/.docksal/docksal.env" ]]

	source "${HOME}/.docksal/docksal.env"
	[[ "$TEST_VAR" == "54321" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.bak" "${HOME}/.docksal/docksal.env"
}

@test "fin config remove: global file" {
	[[ $SKIP == 1 ]] && skip

	cp "${HOME}/.docksal/docksal.env" "${HOME}/.docksal/docksal.env.bak"

	echo "TEST_VAR=123456" >> ${HOME}/.docksal/docksal.env
	run fin config remove --global TEST_VAR
	[[ $status == 0 ]] && [[ "$output" =~ "Removing TEST_VAR from ${HOME}/.docksal/docksal.env" ]]

	source "${HOME}/.docksal/docksal.env"
	[[ -z "$TEST_VAR" ]]
	unset output

	mv "${HOME}/.docksal/docksal.env.bak" "${HOME}/.docksal/docksal.env"
}

@test "fin config remove: global file variable does not exist" {
	[[ $SKIP == 1 ]] && skip

	run fin config remove --global TEST_VAR
	[[ $status == 0 ]] &&
	[[ $output =~ "Could not find TEST_VAR in ${HOME}/.docksal/docksal.env" ]]

	unset output
}