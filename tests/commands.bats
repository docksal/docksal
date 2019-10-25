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

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

# Cannot do cleanup outside of a test case as bats will evaluate/run that code before every single test case.
@test "uber cleanup" {
	[[ $SKIP == 1 ]] && skip

	fin project reset -f
	return 0
}

@test "fin init (built-in)" {
	[[ $SKIP == 1 ]] && skip

	cd "$TRAVIS_BUILD_DIR/../test-init"
	run fin init
	echo "$output" | grep "http://test-init.docksal"
	unset output

	# Give Travis some time because looks like it needs some time to understand that everything is up
	sleep 5
	# Check if site is available and its name is correct
	run curl -sLI http://test-init.docksal
	echo "$output" | grep "X-Powered-By: PHP"
	unset output
}

@test "fin init (custom command)" {
	[[ $SKIP == 1 ]] && skip

	run fin init
	# Do not do unset output to preserve logs from this command
	#unset output

	# Check if site is available and its name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
	unset output
}

@test "fin namespace/custom-command" {
	[[ $SKIP == 1 ]] && skip

	mkdir .docksal/commands/team 2>/dev/null
	cat <<EOF > .docksal/commands/team/test
#!/usr/bin/env bash
echo "Test Command"
EOF
	chmod +x .docksal/commands/team/test

	run fin team/test
	[[ "${output}" == "Test Command" ]]
	unset output
}

@test "fin exec" {
	[[ $SKIP == 1 ]] && skip

	run fin exec uname -a
	[[ "$output" =~ "Linux cli" ]]
	unset output

	# Test output in TTY vs no-TTY mode.
	[[ "$(fin exec echo)" != "$(fin exec -T echo)" ]]

	# Test the no-TTY output is a "clean" string (does not have extra control characters and can be compared)
	run fin exec -T pwd
	[[ "$output" == "/var/www" ]]
	unset output

	# Test that switching directories on host carries over into cli
	cd docroot
	run fin exec -T pwd
	[[ "$output" == "/var/www/docroot" ]]
	unset output

	# fin exec uses the docker user
	run fin exec -T id -un
	[[ "$output" == "docker" ]]
	unset output

	# docker user uid/gid in cli matches the host user uid/gid
	run fin exec -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
	unset output

	# setting target container with --in
	run fin exec -T --in=web cat /etc/hostname
	[[ "$output" == "web" ]]
	unset output
}

@test "fin share" {
	[[ $SKIP == 1 ]] && skip

	# Send all mail to /bin/true
	echo "sendmail_path=/bin/true" >> .docksal/etc/php/php.ini
	# Initialize the Project
	fin init
	# Run fin share in a emulated terminal
	screen -S testNgrok -d -m fin share
	# sleep so ngrok can load
	sleep 20
	# Query API for information
	container_name="$(fin docker ps -a --filter "label=com.docker.compose.project=drupal8" --filter "label=com.docker.compose.service=web" --format '{{.Names }}')_ngrok"
	API=$(docker exec -it "$container_name" sh -c "wget -qO- http://localhost:4040/api/tunnels")
	# Return Public URL for site.
	PUBLIC_HTTP_URL=$(echo "${API}" | jq -r '.tunnels[0].public_url')
	# Run CURL command against $PUBLIC_HTTP_URL
	run curl -i ${PUBLIC_HTTP_URL}
	# Confirm site is reachable
	[[ "${output}" =~ "HTTP/1.1 200 OK" ]] &&
	[[ "${output}" =~ "My Drupal 8 Site" ]]
	unset output

	# Clean Up
	# Clean up kill ngrok session
	screen -X -S testNgrok quit
	# Kill Docker Container
	docker rm -f "$container_name"
	# Destroy Project
	fin rm -f
}
