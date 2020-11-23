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
### Pantheon
#############

@test "fin pull init: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --hosting-platform=pantheon --hosting-site=${BUILD_PANTHEON_SITE} --hosting-env=${BUILD_PANTHEON_ENV} pantheon-test
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output
}

@test "fin pull code: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R pantheon-test pantheon-pull-code
	cd pantheon-pull-code
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Pulling code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output
}

@test "fin pull db: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R pantheon-test pantheon-pull-db
	cd pantheon-pull-db
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull files: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R pantheon-test pantheon-pull-files
	cd pantheon-pull-files
	fin start

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Downloading Files from" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull all: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R pantheon-test pantheon-pull-all
	cd pantheon-pull-all
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}
