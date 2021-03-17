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
### Platform.sh
#############

@test "fin pull init: platform.sh" {
	[[ $SKIP == 1 ]] && skip

	# Test Initialize Project
	run fin pull init --hosting-platform=platformsh --hosting-site=${BUILD_PLATFORMSH_SITE} --hosting-env=${BUILD_PLATFORMSH_ENV} platformsh-test
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
