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
	fin config set --global "SECRET_ACAPI_EMAIL=${BUILD_ACAPI_EMAIL}"
	fin config set --global "SECRET_ACAPI_KEY=${BUILD_ACAPI_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=acquia --HOSTING_SITE=${BUILD_ACQUIA_SITE} --HOSTING_ENV=${BUILD_ACQUIA_ENV} pull-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pull-site
	fin start

	# Test Pull Code
	run fin pull code
	unset output

	# Test Pull DB
	run fin pull db ${BUILD_ACQUIA_ENV}
	unset output

	# Test Pull Files
	run fin pull files
	unset output

	# Test Pull All
	run fin pull
	unset output

	# Cleanup
	fin rm -f
	cd ..
	rm -rf pull-site
}

@test "fin pull: pantheon" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	fin config set --global "SECRET_TERMINUS_TOKEN=${BUILD_TERMINUS_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=pantheon --HOSTING_SITE=${BUILD_PANTHEON_SITE} --HOSTING_ENV=${BUILD_PANTHEON_ENV} pull-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pull-site
	fin start

	# Test Pull Code
	run fin pull code
	[[ "${output}" =~ "Pulling Code" ]]
	unset output

	# Test Pull DB
	run fin pull db
	unset output

	# Test Pull Files
	run fin pull files
	unset output

	# Test Pull All
	run fin pull
	unset output

	# Cleanup
	fin rm -f
	cd ..
	rm -rf pull-site
}

@test "fin pull: platform.sh" {
	#[[ $SKIP == 1 ]] && skip

	# Setup
	fin config set --global "SECRET_PLATFORMSH_CLI_TOKEN=${BUILD_PLATFORMSH_CLI_TOKEN}"

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=platformsh --HOSTING_SITE=${BUILD_PLATFORMSH_SITE} --HOSTING_ENV=${BUILD_PLATFORMSH_ENV} pull-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pull-site
	fin start

	# Test Pull Code
	run fin pull code
	unset output

	# Test Pull DB
	run fin pull db
	unset output

	# Test Pull Files
	run fin pull files
	unset output

	# Test Pull All
	run fin pull
	unset output

	# Cleanup
	fin rm -f
	cd ..
	rm -rf pull-site
}

@test "fin pull: drush" {
	#[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=drush --HOSTING_SITE=dev https://github.com/docksal/drupal8.git pull-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pull-site
	fin start

	# Test Pull Code
	run fin pull code
	unset output

	# Test Pull DB
	run fin pull db

	# Test Pull Files
	run fin pull files

	# Test Pull All
	run fin pull

	# Cleanup
	fin rm -f
	cd ..
	rm -rf pull-site
}

@test "fin pull: wp" {
	#[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --HOSTING_PLATFORM=wp --HOSTING_SITE=test https://github.com/docksal/wordpress.git pull-site
	[[ "$status" == 0 ]]
	[[ "${output}" =~ "Starting Pull Init Process" ]]
	[[ "${output}" =~ "Pulling code complete" ]]
	unset output

	cd pull-site
	fin start

	# Test Pull Code
	run fin pull code

	# Test Pull DB
	run fin pull db

	# Test Pull Files
	run fin pull files

	# Test Pull All
	run fin pull

	# Cleanup
	fin rm -f
	cd ..
	rm -rf pull-site
}
