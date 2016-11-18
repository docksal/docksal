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

# Global constants
SERVICE_VHOST_PROXY_VERSION=1.0
SERVICE_DNS_VERSION=1.0
SERVICE_SSH_AGENT_VERSION=1.0

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

# Add default sample keys on Travis only. We don't want to mess with a real host ssh key.
[[ "$TRAVIS" == "true" ]] && cp tests/ssh-keys/* ~/.ssh


@test "fin reset dns" {
	[[ $SKIP == 1 ]] && skip

	run fin reset dns
	echo "$output" | grep "Resetting Docksal DNS service and configuring resolver for .docksal domain"

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep docksal/dns:$SERVICE_SSH_AGENT_VERSION

	# IP and .docksal domain resolution
	# TODO: Skipping on Travis. Figure out why Docksal's default IP assignment does not work on Travis.
	if [[ "$TRAVIS" != "true" ]]; then
    	run ping -c 1 anything.docksal
		[[ $(echo "$output" | awk -F'[()]' '/PING/{print $2}') == "192.168.64.100" ]]
	fi
}

@test "fin reset proxy" {
	[[ $SKIP == 1 ]] && skip

	run fin reset proxy
	echo "$output" | grep "Resetting Docksal HTTP/HTTPS reverse proxy service"

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep docksal/vhost-proxy:$SERVICE_VHOST_PROXY_VERSION

	# Proxy routes requests properly
	# Start an nginx container with "nginx.docksal" virtual host assigned
	fin docker run -d --name bats-nginx --label 'io.docksal.virtual-host=nginx.docksal' -e 'VIRTUAL_HOST=nginx.docksal' nginx:alpine && sleep 2
	# Actual Test
	run curl -sL http://nginx.docksal
	# Cleanup
	fin docker rm -vf bats-nginx
	# Parsing test output
	echo "$output" | grep 'Welcome to nginx!'
}

@test "fin reset ssh-agent" {
	[[ $SKIP == 1 ]] && skip

	run fin reset ssh-agent
	echo "$output" | grep "Resetting Docksal ssh-agent service"
	# Assuming there is at least one default key
	echo "$output" | egrep "Identity added: id_.+ \(id_.+\)"

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep docksal/ssh-agent:$SERVICE_SSH_AGENT_VERSION
}

@test "fin ssh-add" {
	[[ $SKIP == 1 ]] && skip

	# Checking fin ssh-add -D
	run fin ssh-add -D
	echo "$output" | grep "All identities removed."

	# Adding default keys
	# Run these tests on Travis only
	if [[ "$TRAVIS" == "true" ]]; then
		run fin ssh-add
		echo "$output" | grep "Identity added: id_dsa (id_dsa)"
		echo "$output" | grep "Identity added: id_ecdsa (id_ecdsa)"
		echo "$output" | grep "Identity added: id_rsa (id_rsa)"

		# Adding a non-default key
		run fin ssh-add bats_rsa
		echo "$output" | grep "Identity added: bats_rsa (bats_rsa)"

		# Checking fin ssh-add -l
		run fin ssh-add -l
		echo "$output" | egrep "SHA256:.+ id_.+"
		echo "$output" | egrep "4096 SHA256:.+ bats_rsa \(RSA\)"
	else
		run fin ssh-add
		# On a real host assuming there is at least one default key
		echo "$output" | egrep "Identity added: id_.+ \(id_.+\)"

		# Checking fin ssh-add -l
		run fin ssh-add -l
		echo "$output" | egrep "SHA256:.+ id_.+"
	fi

	# Checking fin ssh-add: key doesn't exist
	run fin ssh-add doesnt_exist_rsa
	echo "$output" | grep "doesnt_exist_rsa: No such file or directory"

	# Checking fin ssh-add -D
	run fin ssh-add -D
	echo "$output" | grep "All identities removed."

	# Checking fin ssh-add -l (no keys)
	run fin ssh-add -l
	echo "$output" | grep "The agent has no identities."
}
