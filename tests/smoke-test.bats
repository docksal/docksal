#!/usr/bin/env bats

@test "Proxy container is up" {
	run docker ps -a --filter "name=docksal-vhost-proxy" --format "{{ .Status }}"
	[ $status -eq 0 ]
	[[ $output =~ "Up" ]]
}

@test "Proxy returns 404 for a non-existing virtual-host" {
	run curl -I http://test.docksal/
	[ $status -eq 0 ]
	[[ $output =~ "HTTP/1.1 404 Not Found" ]]
}

@test "Proxy can start an existing stopped project" {
	# Stop if running.
	containers=$(docker ps -q --filter "label=com.docker.compose.project=drupal7")
	for container in $containers; do
		docker stop $container
	done
	if [[ "$(docker network ls -q --filter "name=drupal7_default")" != "" ]]; then
		docker network disconnect drupal7_default docksal-vhost-proxy
		docker network rm drupal7_default
	fi
	run curl http://drupal7.docksal/
	[ $status -eq 0 ]
	[[ $output =~ "Waking up the daemons..." ]]
}

@test "Proxy container started the project within 15 seconds" {
	# Wait for start.
	sleep 15
	run curl http://drupal7.docksal/
	[ $status -eq 0 ]
	[[ $output =~ "My Drupal 7 Site" ]]
}
