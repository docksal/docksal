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

# Add project_key to SSH Agent.
[[ "$TRAVIS" == "true" ]] && fin ssh-key add project_key

# Test interacting with Providers
@test "fin pull: acquia" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin config set --global "SECRET_ACAPI_EMAIL=${BUILD_ACAPI_EMAIL}"
	fin config set --global "SECRET_ACAPI_KEY=${BUILD_ACAPI_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} acquia-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd acquia-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling code" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	unset output

	# Test Pull DB

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

	## Test Acquia Pull with Cached Version
	run fin pull db ${BUILD_ACQUIA_SITE}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Cached DB file still valid found and using to import" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	## Test Acquia Pull with --FORCE flag
	run fin pull db ${BUILD_ACQUIA_SITE} --FORCE
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Pulling new database file..." ]]
	[[ "${output}" =~ "Creating new backup on Acquia" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	unset output

	# Test Pull Files
	run fin pull files
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Downloading files from" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Test Pull All
	run fin pull ${BUILD_ACQUIA_SITE}
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting provider pull for acquia" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Cleanup
	fin rm -f
	cd ${TRAVIS_BUILD_DIR}/../test-pull
}

@test "fin pull: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin config set --global "SECRET_TERMINUS_TOKEN=${BUILD_TERMINUS_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pantheon-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pantheon-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	unset output

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	unset output

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	unset output

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for pantheon" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Cleanup
	fin rm -f
}

@test "fin pull: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull
	fin config set --global "SECRET_PLATFORMSH_CLI_TOKEN=${BUILD_PLATFORMSH_CLI_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} platformsh-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd platformsh-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	unset output

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	unset output

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	unset output

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for platformsh" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Cleanup
	fin rm -f
}

@test "fin pull: drush" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull

	# Test Initialize Project into existing directory
	mkdir test-drush-site
	run fin pull init --HOSTING_PLATFORM=drush --HOSTING_SITE=dev test-drush-site https://github.com/docksal/drupal8.git
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Project Directory test-drush-site already exists." ]]
	unset output

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=drush --HOSTING_SITE=dev drush-site https://github.com/docksal/drupal8.git
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd drush-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	unset output

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	unset output

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	unset output

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for drush" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]
	unset output

	# Cleanup
	fin rm -f
}

@test "fin pull: wp" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	cd ${TRAVIS_BUILD_DIR}/../test-pull

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=wp --HOSTING_SITE=test wp-site https://github.com/docksal/wordpress.git
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd wp-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "Pulling Code" ]]
	unset output

	# Test Pull DB
	run fin pull db
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	unset output

	# Test Pull Files
	run fin pull files
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	unset output

	# Test Pull All
	run fin pull
	[[ $status == 0 ]]
	[[ "${output}" =~ "Starting provider pull for wp" ]]
	[[ "${output}" =~ "Code Pull Successful" ]]
	[[ "${output}" =~ "DB Pull Successful" ]]
	[[ "${output}" =~ "File Pull Successful" ]]

	# Cleanup
	fin rm -f
}
