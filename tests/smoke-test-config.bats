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
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ $output =~ "stack-default.yml" ]] && \
	[[ ! $output =~ "docksal.yml" ]]
}

@test "fin config: zero configuration + stack option" {
	[[ $SKIP == 1 ]] && skip

	# Define which stack we want to use
	echo 'DOCKSAL_STACK=acquia' > .docksal/docksal.env

	run fin config env
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ $output =~ "stack-acquia.yml" ]] && \
	[[ ! $output =~ "docksal.yml" ]] && \
	[[ $output =~ "docksal.env" ]]
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
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ $output =~ "stack-acquia.yml" ]] && \
	[[ $output =~ "docksal.yml" ]] && \
	[[ $output =~ "docksal.env" ]] && \
	[[ $output =~ "TEST_VAR: test_val" ]]
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
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ ! $output =~ "stack-default.yml" ]] && \
	[[ $output =~ "docksal.yml" ]] && \
	[[ ! $output =~ "docksal.env" ]] && \
	[[ $output =~ "TEST_VAR: test_val_default" ]]
}

@test "fin config: docksal.yml + docksal.env" {
	[[ $SKIP == 1 ]] && skip

	# Override TEST_VAR
	echo 'TEST_VAR=my_val' > .docksal/docksal.env

	run fin config
	[[ $status == 0 ]] && \
	[[ $output =~ "docksal.env" ]] && \
	# Test our override is in place
	[[ $output =~ "TEST_VAR: my_val" ]]
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
	[[ $status == 0 ]] && \
	[[ $output =~ "docksal-local.yml" ]] && \
	[[ ! $output =~ "docksal-local.env" ]] && \
	[[ $output =~ "TEST_VAR_LOCAL: test_val_default" ]]
}

@test "fin config: docksal-local.yml + docksal-local.env" {
	[[ $SKIP == 1 ]] && skip

	# Override TEST_VAR_LOCAL
	echo 'TEST_VAR_LOCAL=my_val_local' > .docksal/docksal-local.env

	run fin config
	[[ $status == 0 ]] && \
	[[ $output =~ "docksal-local.yml" ]] && \
	[[ $output =~ "docksal-local.env" ]] && \
	# Test our override is in place
	[[ $output =~ "TEST_VAR_LOCAL: my_val" ]]
}

@test "fin config generate: empty project" {
	[[ $SKIP == 1 ]] && skip

	# cleanup here
	rm -rf .docksal
	fin config generate

	run fin config env
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ ! $output =~ "stack-default.yml" ]] && \
	[[ $output =~ "docksal.yml" ]] && \
	[[ $output =~ "docksal.env" ]]
}

@test "fin config generate: existing project" {
	[[ $SKIP == 1 ]] && skip

	# Define which stack we want to use. This is supposed to be eventually removed by the "fin config generate" run below
	echo 'DOCKSAL_STACK=acquia' > .docksal/docksal.env
	# TODO: need a --force option to be able to use this in a non-interactive environment like CI/bats tests
	fin config generate

	run fin config env
	[[ $status == 0 ]] && \
	[[ $output =~ "volumes-bind.yml" ]] && \
	[[ ! $output =~ "stack-default.yml" ]] && \
	[[ ! $output =~ "stack-acquia.yml" ]] && \
	[[ $output =~ "docksal.yml" ]] && \
	[[ $output =~ "docksal.env" ]]
}
