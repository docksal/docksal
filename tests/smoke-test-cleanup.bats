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

@test "fin cleanup" {
  run fin cleanup

  [[ $status == 0 ]] && \
  [[ $output =~ "Removing dangling images..." ]] && \
  [[ $output =~ "Removing dangling volumes..." ]] && \
  [[ $output =~ "Checking for orphaned containers..." ]] && \
  [[ $output =~ "Directory for project \"drupal8\" does not exist. Removing containers..." ]]
}
