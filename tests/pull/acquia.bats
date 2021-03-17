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
### Acquia
#############

@test "fin pull init: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --hosting-platform=acquia --hosting-site=${BUILD_ACQUIA_SITE} --hosting-env=${BUILD_ACQUIA_ENV} acquia-test
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output
}

@test "fin pull code: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R acquia-test acquia-test-pull-code
	cd acquia-test-pull-code
	fin start

	# Test Pull Code
	run fin pull code
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output
}

@test "fin pull db: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R acquia-test acquia-test-pull-db
	cd acquia-test-pull-db
	fin start

	## Test Acquia Pull DB
	run fin pull db
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	# Depending on when test is ran may get a backup in the last 24 hours.
	# May need to create one
	[[ "${output}" =~ "Creating new backup on Acquia" ]] ||
		[[ "${output}" =~ "Using latest backup from Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull db cached: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cd acquia-test-pull-db
	fin start

	## Test Acquia Pull with Cached Version
	run fin pull db
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Cached DB file still valid found and using to import" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull db by name: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cd acquia-test-pull-db
	fin reset -f

	## Test Acquia Pull with Cached Version
	run fin pull db --remote-db=test
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	# Depending on when test is ran may get a backup in the last 24 hours.
	# May need to create one
	[[ "${output}" =~ "Creating new backup on Acquia" ]] ||
		[[ "${output}" =~ "Using latest backup from Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull db by name import to different db: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cd acquia-test-pull-db
	fin reset -f

	# Create new DB in local.
	fin db create test

	## Test Acquia Pull DB By Name
	run fin pull db --remote-db=test --db-name=test
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	# Depending on when test is ran may get a backup in the last 24 hours.
	# May need to create one
	[[ "${output}" =~ "Creating new backup on Acquia" ]] ||
		[[ "${output}" =~ "Using latest backup from Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull db force flag: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cd acquia-test-pull-db
	fin start

	## Test Acquia Pull with --force flag
	run fin pull db --force
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	[[ "${output}" =~ "Creating new backup on Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull files: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R acquia-test acquia-test-pull-files
	cd acquia-test-pull-files
	fin start

	# Test Pull Files
	run fin pull files
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Downloading Files from" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull all: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R acquia-test acquia-test-pull-all
	cd acquia-test-pull-all
	fin start

	# Test Pull All
	run fin pull --remote-db="${BUILD_ACQUIA_SITE}"
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}
