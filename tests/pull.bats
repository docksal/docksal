#!/usr/bin/env bats

setup () {
	cd ${TRAVIS_BUILD_DIR}/../test-pull
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

@test "fin pull init: acquia" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-test
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
	run fin pull db --REMOTE_DB=test
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
	run fin pull db --REMOTE_DB=test --DBNAME=test
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

	## Test Acquia Pull with --FORCE flag
	run fin pull db --FORCE
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
	run fin pull --REMOTE_DB="${BUILD_ACQUIA_SITE}"
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull init: pantheon" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-test
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

@test "fin pull init: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-test
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output
}

@test "fin pull code: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R platformsh-test platformsh-pull-code
	cd platformsh-pull-code
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output
}

@test "fin pull db: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R platformsh-test platformsh-pull-db
	cd platformsh-pull-db
	fin start

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output
}

@test "fin pull files: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R platformsh-test platformsh-pull-files
	cd platformsh-pull-files
	fin start

	# Test Pull DB
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Downloading Files from" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull all: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	cp -R platformsh-test platformsh-pull-all
	cd platformsh-pull-all
	fin start

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Complete" ]]
	unset output
}

@test "fin pull init: drush" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=drush --HOSTING_SITE="remote" --HOSTING_ENV="dev" drush-test ${BUILD_DRUSH_GIT}
	[[ "$status" == 0 ]]
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
