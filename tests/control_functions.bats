#!/usr/bin/env bats

load dsh_script

@test "Checking check_yml function. Case#1 Linux docker-compose exists." {
	if [[ "$OS" = "linux"  || $(is_docker_beta) -ne 0 ]]; then
		run check_yml

		[ $status -eq 0 ]
	fi
}

@test "Checking check_yml function. Case#1 Linux docker-compose not exists." {
	if [[ "$OS" = "linux"  ]]; then
		cd ..
		run check_yml

		[ $status -eq 1 ]
	fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant exists." {
	if [[ "$OS" != "linux"  ]]; then
		run check_yml

		[ $status -eq 0 ]
	fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant not exists." {
	if [[ "$OS" != "linux"  ]]; then
		cd ..
		run check_yml

		[ $status -eq 1 ]
	fi
}

@test "Checking check_drush_path function. Case#1 - inside docroot." {
	cd docroot/sites
	run check_drush_path

	[ $status -eq 0 ]
}

@test "Checking check_drush_path function. Case#2 - outside docroot." {
	run check_drush_path

	[ $status -eq 1 ]
	[[ $output =~ "dsh: This command must be run inside Drupal's document root" ]]
}