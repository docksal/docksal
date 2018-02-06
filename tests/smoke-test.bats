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

@test "Proxy container is up and using the \"${IMAGE}\" image" {
	[[ ${SKIP} == 1 ]] && skip

	run fin docker ps --filter "name=docksal-vhost-proxy" --format "{{ .Image }}"
	[[ "$output" =~ "$IMAGE" ]]
	unset output
}

@test "Test projects are up and running" {
	[[ ${SKIP} == 1 ]] && skip

	# TODO: figure out why fin aliases do not work on Travis
	#fin @project1 start
	#fin @project2 start
	cd projects/project1 && fin start && cd ..
	cd projects/project2 && fin start && cd ..

	run fin pl
	[[ "$output" =~ "project1" ]]
	[[ "$output" =~ "project2" ]]
}

@test "Projects directory mounted correctly" {
	[[ ${SKIP} == 1 ]] && skip

	run fin docker exec docksal-vhost-proxy ls -la /projects
	[[ "$output" =~ "project1" ]]
	[[ "$output" =~ "project2" ]]
}

@test "Proxy returns 404 for a non-existing virtual-host" {
	[[ ${SKIP} == 1 ]] && skip

	run curl -I http://test.docksal
	[[ "$output" =~ "HTTP/1.1 404 Not Found" ]]
	unset output
}

@test "Proxy returns 200 for an existing virtual-host" {
	[[ ${SKIP} == 1 ]] && skip

	run curl -I http://project1.docksal
	[[ "$output" =~ "HTTP/1.1 200 OK" ]]
	unset output

	run curl -I http://project2.docksal
	[[ "$output" =~ "HTTP/1.1 200 OK" ]]
	unset output
}

@test "Proxy stops project containers after \"${PROJECT_INACTIVITY_TIMEOUT}\" of inactivity" {
	[[ ${SKIP} == 1 ]] && skip

	[[ "$PROJECT_INACTIVITY_TIMEOUT" == "0" ]] &&
		skip "Stopping has been disabled via PROJECT_INACTIVITY_TIMEOUT=0"

	sleep ${PROJECT_INACTIVITY_TIMEOUT} && sleep 5
	# Trigger proxyctl stop manually to skip the cron job wait.
	fin docker exec docksal-vhost-proxy proxyctl stop

	# Check projects were stopped, but not removed
	run fin pl -a
	echo "$output" | grep project1 | grep 'Exited (0)'
	echo "$output" | grep project2 | grep 'Exited (0)'
	unset output

	# Check project networks were removed
	run fin docker network ls
	echo "$output" | grep -v project1
	echo "$output" | grep -v project2
	unset output
}

@test "Proxy starts an existing stopped project (HTTP)" {
	[[ ${SKIP} == 1 ]] && skip

	# Make sure the project is stopped
	#fin @project1 stop
	cd projects/project1 && fin stop && cd ..

	run curl http://project1.docksal
	[[ "$output" =~ "Waking up the daemons..." ]]
	unset output

	# Wait for project start
	sleep 15

	run curl http://project1.docksal
	[[ "$output" =~ "Project 1" ]]
	unset output
}

@test "Proxy starts an existing stopped project (HTTPS)" {
	[[ ${SKIP} == 1 ]] && skip

	# Make sure the project is stopped
	#fin @project1 stop
	cd projects/project1 && fin stop && cd ..

	run curl -k https://project1.docksal
	[[ "$output" =~ "Waking up the daemons..." ]]
	unset output

	# Wait for project start
	sleep 15

	run curl -k https://project1.docksal
	[[ "$output" =~ "Project 1" ]]
	unset output
}

@test "Proxy cleans up projects after \"${PROJECT_DANGLING_TIMEOUT}\" of inactivity" {
	[[ ${SKIP} == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] &&
		skip "Cleanup has been disabled via PROJECT_DANGLING_TIMEOUT=0"

	sleep ${PROJECT_DANGLING_TIMEOUT} && sleep 5
	# Trigger proxyctl cleanup manually to skip the cron job wait.
	fin docker exec docksal-vhost-proxy proxyctl cleanup

	# Check project1 containers were removed
	run fin docker ps -a -q --filter "label=com.docker.compose.project=project1"
	[[ "$output" == "" ]]
	unset output
	# Check project1 network was removed
	run fin docker network ls
	echo "$output" | grep -v project1
	unset output
	# Check project1 folder was removed
	fin docker exec docksal-vhost-proxy ls -la /projects
	echo "$output" | grep -v project1
}

@test "Proxy does not clean up permanent projects" {
	[[ ${SKIP} == 1 ]] && skip

	[[ "$PROJECT_DANGLING_TIMEOUT" == "0" ]] &&
		skip "Cleanup has been disabled via PROJECT_DANGLING_TIMEOUT=0"

	# Check that project2 still exist
	run fin pl -a
	echo "$output" | grep project2
	unset output
	# Check that project2 folder was NOT removed
	run fin docker exec docksal-vhost-proxy ls -la /projects
	echo "$output" | grep project2
	unset output
}
