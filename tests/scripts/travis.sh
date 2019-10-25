#!/usr/bin/env bash

# Runs tests from file name $1 in dir $2
# $1 - name of the file with tests
# $2 - working directory to run in (tries to create it)
run_tests () {
	target="${2:-$TRAVIS_BUILD_DIR}"
	mkdir -p "$target"
	cd "$target" || return 1
	if [[ "$TRAVIS_COMMIT_MESSAGE" =~ "[quick-test]" && "$1" != "quicktest.bats" ]]; then
		return
	fi
	if [[ "$1" == "quicktest.bats" ]]; then
		I="-i";
	fi
	bats ${I} "$TRAVIS_BUILD_DIR/tests/$1";
}

# Triggers builds for boilerplate-* repos when master branch is tested
# $1 - repo name, e.g. docksal/boilerplate-drupal7
build_trigger() {
	if [[ "$TRAVIS_BRANCH" == "master" ]]; then
		cd "$TRAVIS_BUILD_DIR"
		travisci-build-trigger "$1"
	fi
}
