#!/usr/bin/env bats

load dsh_script

@test "Checking dsh drush --version" {
	dsh drush --version
}

@test "Checking output of dsh drush --version" {
	run dsh drush --version

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Drush Version   :  8.1.3" ]]
}

@test "Checking output of dsh drush st (Drupal version)" {
	cd ./docroot
	run dsh drush st

	[ $status -eq 0 ]
	[[ ${lines[0]} =~ "Drupal version         :  7.34" ]]

	cd ..
}