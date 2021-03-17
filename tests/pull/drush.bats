#!/usr/bin/env bats

setup () {
	cd ${GITHUB_WORKSPACE}/../test-pull
}

# Debugging
teardown() {
	# Remove Projects
	fin stop

	echo "Status: $status"
	echo "Output:"
	echo "================================================================"
	for line in "${lines[@]}"; do
		echo $line
	done
	echo "================================================================"
}

#############
### Drush
#############

@test "fin pull init: drush" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --hosting-platform=drush --hosting-site="remote" --hosting-env="dev" drush-test ${BUILD_DRUSH_GIT}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output
}

@test "fin pull code: drush" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R drush-test drush-pull-code
	cd drush-pull-code
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output
}

@test "fin pull db: drush" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R drush-test drush-pull-db
	cd drush-pull-db
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull files: drush" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R drush-test drush-pull-files
	cd drush-pull-files
	fin start

	# Test Pull DB
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Downloading Files from" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull all: drush" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R drush-test drush-pull-all
	cd drush-pull-all
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}
