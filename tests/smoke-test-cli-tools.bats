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

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

@test "fin drush" {
	[[ $SKIP == 1 ]] && skip

	# Default drush (8)
	run fin drush --version
	echo "$output" | egrep "Drush Version   :  8\..+"
	unset output

	# Drush 6
	run fin exec drush6 --version
	echo "$output" | egrep "Drush Version   :  6\..+"
	unset output

	# Drush 7
	run fin exec drush7 --version
	echo "$output" | egrep "Drush Version   :  7\..+"
	unset output
}

@test "fin drupal" {
	[[ $SKIP == 1 ]] && skip

	run fin drupal --version
	echo "$output" | egrep "Drupal Console Launcher version 1\..+"
	unset output
}
