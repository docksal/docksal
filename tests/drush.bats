#!/usr/bin/env bats

load fin_script

@test "Checking fin drush --version" {
	fin drush --version
}

@test "Checking output of fin drush --version" {
	run fin drush --version

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Drush Version   :  8.1.3" ]]
}

@test "Checking output of fin drush st (Drupal version)" {
	cd ./docroot
	run fin drush st

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Drupal version         :  7.34" ]]

	cd ..
}