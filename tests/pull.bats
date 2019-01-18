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

@test "fin pull init: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull code: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull db: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	## Test Acquia Pull without db name
	run fin pull db
	[[ "$status" == 1 ]]
	[[ "${output}" =~ "Database name is required." ]]
	unset output

	## Test Acquia Pull with db name
	run fin pull db ${BUILD_ACQUIA_SITE}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	# Depending on when test is ran may get a backup in the last 24 hours.
	# May need to create one
	[[ "${output}" =~ "Creating new backup on Acquia" ]] ||
		[[ "${output}" =~ "Using latest backup from Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull db cached: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	## Test Acquia Pull with Cached Version
	run fin pull db ${BUILD_ACQUIA_SITE}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Cached DB file still valid found and using to import" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull db force flag: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	## Test Acquia Pull with --FORCE flag
	run fin pull db ${BUILD_ACQUIA_SITE} --FORCE
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	[[ "${output}" =~ "Creating new backup on Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull files: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	# Test Pull Files
	run fin pull files
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Downloading files from" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull all: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	fin start

	# Test Pull All
	run fin pull ${BUILD_ACQUIA_SITE}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf acquia-site
}

@test "fin pull init: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}

@test "fin pull code: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Pulling code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf pantheon-site
}

@test "fin pull db: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf pantheon-site
}

@test "fin pull files: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	fin start

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Downloading files from" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf pantheon-site
}

@test "fin pull all: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf pantheon-site
}

@test "fin pull init: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}

@test "fin pull code: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}

@test "fin pull db: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}

@test "fin pull files: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	fin start

	# Test Pull DB
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Downloading files from" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}

@test "fin pull all: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Clean up
	fin rm -f
	rm -rf platformsh-site
}
