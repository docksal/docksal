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
### WordPress
#############

@test "fin pull init: wp" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --hosting-platform=wp --hosting-site="remote" wp-test ${BUILD_WP_GIT}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output
}

@test "fin pull code: wp" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R wp-test wp-pull-code
	cd wp-pull-code
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output
}

@test "fin pull db: wp" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R wp-test wp-pull-db
	cd wp-pull-db
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull files: wp" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R wp-test wp-pull-files
	cd wp-pull-files
	fin start

	# Test Pull DB
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "File Pull for WordPress is currently not supported." ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull all: wp" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R wp-test wp-pull-all
	cd wp-pull-all
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}
