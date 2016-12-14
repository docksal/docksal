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

@test "Proxy container is up and using the \"${IMAGE_VHOST_PROXY}\" image" {
	[[ $SKIP == 1 ]] && skip

	run fin docker ps --filter "name=docksal-vhost-proxy" --format "{{ .Image }}"
	[[ $output =~ "${IMAGE_VHOST_PROXY}" ]]
}

@test "Proxy returns 404 for a non-existing virtual-host" {
	[[ $SKIP == 1 ]] && skip

	run curl -I http://test.docksal/
	[[ $output =~ "HTTP/1.1 404 Not Found" ]]
}

@test "Proxy can start an existing stopped project" {
	[[ $SKIP == 1 ]] && skip

	# Stop if running.
	containers=$(fin docker ps -q --filter "label=com.docker.compose.project=drupal7")
	for container in $containers; do
		fin docker stop $container
	done
	if [[ "$(docker network ls -q --filter "name=drupal7_default")" != "" ]]; then
		fin docker network disconnect drupal7_default docksal-vhost-proxy
		fin docker network rm drupal7_default
	fi
	run curl http://drupal7.docksal/
	[[ $output =~ "Waking up the daemons..." ]]
}

@test "Proxy container started the project within 15 seconds" {
	[[ $SKIP == 1 ]] && skip

	# Wait for start
	sleep 15
	run curl http://drupal7.docksal/
	[[ $output =~ "My Drupal 7 Site" ]]
}
