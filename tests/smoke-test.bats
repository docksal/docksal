#!/usr/bin/env bats

# Debugging
# TODO: looks like this only outputs the first line instead of all lines.
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

	run curl -I http://test.docksal/robots.txt
	[[ $output =~ "HTTP/1.1 404 Not Found" ]]
}

@test "Proxy returns 200 for an existing virtual-host" {
	[[ $SKIP == 1 ]] && skip

	run curl -v http://drupal7.docksal/robots.txt
	[[ $output =~ "robots.txt" ]]

	run curl -v http://drupal8.docksal/robots.txt
	[[ $output =~ "robots.txt" ]]
}

@test "Proxy stopped project containers after \"${PROJECT_INACTIVITY_TIMEOUT}\" of inactivity" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

    sleep $PROJECT_INACTIVITY_TIMEOUT && sleep 1
    # Trigger proxyctl stop manually to skip the cron job wait.
    fin docker exec docksal-vhost-proxy proxyctl stop

    # Check project was stopped
    [[ $(fin docker ps -a --filter "name=drupal7_web_1" --format "{{ .Status }}") =~ "Exited (0)" ]]
	# Check project network was removed
	[[ $(fin docker network ls -q --filter "name=drupal7_default" | wc -l) =~ "0" ]]
}

@test "Proxy can start an existing stopped project" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

	run curl http://drupal7.docksal/robots.txt
	[[ $output =~ "Waking up the daemons..." ]]
}

@test "Proxy started the project within 15 seconds" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

	# Wait for start
	sleep 15
	run curl http://drupal7.docksal/robots.txt
	[[ $output =~ "robots.txt" ]]
}

@test "Proxy can start an existing stopped project by https" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

	cwd=$(pwd)
	cd ../drupal7 && fin stop
	cd $cwd

	run curl -k https://drupal7.docksal/robots.txt
	[[ $output =~ "Waking up the daemons..." ]]
}

@test "Proxy started the project by https within 15 seconds" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

	# Wait for start
	sleep 15
	run curl -k https://drupal7.docksal/robots.txt
	[[ $output =~ "robots.txt" ]]
}

@test "Proxy cleaned up projects after \"${PROJECT_DANGLING_TIMEOUT}\" of inactivity" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Cleanup has been disabled via PROJECT_DANGLING_TIMEOUT=0"

    sleep $PROJECT_DANGLING_TIMEOUT && sleep 1
    # Trigger proxyctl cleanup manually to skip the cron job wait.
    fin docker exec docksal-vhost-proxy proxyctl cleanup

    # Check project containers were removed
	[[ $(fin docker ps -a -q --filter "label=com.docker.compose.project=drupal7" | wc -l) =~ "0" ]]
	# Check project network was removed
	[[ $(fin docker network ls -q --filter "name=drupal7_default" | wc -l) =~ "0" ]]
	# Check project folder was removed
	[[ ! -d "/projects/drupal7" ]]
}

@test "Proxy did not clean up permanent projects" {
	[[ $SKIP == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] && \
	    skip "Cleanup has been disabled via PROJECT_DANGLING_TIMEOUT=0"

	# Check that project containers exist
	# Using both filter to be sure the label io.docksal.permanent was set properly on the drupal8 project web container
	[[ $(fin docker ps -a --filter "label=io.docksal.permanent=true" --filter "name=drupal8_web_1" --format "{{ .Status }}") =~ "Exited (0)" ]]
	# Check that project folder exists
	[[ ! -d "/projects/drupal8" ]]
}
