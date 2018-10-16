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
SERVICE_VHOST_PROXY_VERSION=1.4
SERVICE_DNS_VERSION=1.1
SERVICE_SSH_AGENT_VERSION=1.1
DOCKSAL_IP=192.168.64.100

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

# Add default sample keys on Travis only. We don't want to mess with a real host ssh key.
[[ "$TRAVIS" == "true" ]] && cp tests/ssh-keys/* ~/.ssh

@test "IP: ($DOCKSAL_IP) is reachable" {
	[[ $SKIP == 1 ]] && skip

	# Check up is up
	run ping -c 1 -t 1 $DOCKSAL_IP
	[ "$status" -eq 0 ]
	unset output

}

@test "DNS: fin system reset dns" {
	[[ $SKIP == 1 ]] && skip

	run fin system reset dns
	echo "$output" | grep "Resetting Docksal DNS service and configuring resolver for .docksal domain"
	unset output

	# Wait 2s to let the service fully initialize
	sleep 2

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep "docksal/dns:$SERVICE_DNS_VERSION"
	unset output
}

@test "DNS: .docksal name resolution via ping" {
	[[ $SKIP == 1 ]] && skip

	# .docksal domain resolution via ping
	run ping -c 1 -t 1 anything.docksal
	[[ "$(echo \"$output\" | awk -F'[()]' '/PING/{print $2}')" == "$DOCKSAL_IP" ]]
	unset output
}

@test "DSN: .docksal name resolution via nslookup" {
	# TODO: fix this test on Travis
	skip
	[[ $SKIP == 1 ]] && skip

	# .docksal domain resolution via nslookup
	run nslookup anything.docksal
	#[[ "$(echo \"$output\" | awk '/^Address/ { print $2 }' | tail -1)" == "$DOCKSAL_IP" ]]
	[[ "$(echo \"$output\" | grep "Address" | tail -1 | tr -d ' ' | awk -F ':' '{print $2}')" == "$DOCKSAL_IP" ]]
	unset output
}

@test "VHOST-PROXY: fin system reset vhost-proxy" {
	[[ $SKIP == 1 ]] && skip

	run fin system reset vhost-proxy
	echo "$output" | grep "Resetting Docksal HTTP/HTTPS reverse proxy service"
	unset output

	# Wait 2s to let the service fully initialize
	sleep 2

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep "docksal/vhost-proxy:$SERVICE_VHOST_PROXY_VERSION"
	unset output

	# Proxy routes requests properly
	# Start an nginx container with "nginx.docksal" virtual host assigned
	fin docker run -d --name bats-nginx --label 'io.docksal.virtual-host=nginx.docksal' -e 'VIRTUAL_HOST=nginx.docksal' nginx:alpine && sleep 2
	# Actual Test
	run curl -sL http://nginx.docksal
	# Cleanup
	fin docker rm -vf bats-nginx
	# Parsing test output
	echo "$output" | grep 'Welcome to nginx!'
	unset output
}

@test "SSH-AGENT: fin system reset ssh-agent" {
	[[ $SKIP == 1 ]] && skip

	run fin system reset ssh-agent
	echo "$output" | grep "Resetting Docksal ssh-agent service"
	# Assuming there is at least one default key
	echo "$output" | egrep "Identity added: id_.+ \(id_.+\)"
	unset output

	# Wait 2s to let the service fully initialize
	sleep 2

	# Service is running and image version is correct
	run fin docker ps
	echo "$output" | grep "docksal/ssh-agent:$SERVICE_SSH_AGENT_VERSION"
	unset output
}

@test "SSH-AGENT: fin ssh-key" {
	[[ $SKIP == 1 ]] && skip

	# Checking "fin ssh-key rm"
	run fin ssh-key rm
	echo "$output" | grep "All identities removed."
	unset output

	# Adding default keys
	# Run these tests on Travis only
	if [[ "$TRAVIS" == "true" ]]; then
		run fin ssh-key add
		echo "$output" | grep "Identity added: id_dsa (id_dsa)"
		echo "$output" | grep "Identity added: id_ecdsa (id_ecdsa)"
		echo "$output" | grep "Identity added: id_rsa (id_rsa)"
		unset output

		# Adding a non-default key
		run fin ssh-key add bats_rsa
		echo "$output" | grep "Identity added: bats_rsa (bats_rsa)"
		unset output

		# Checking "fin ssh-key ls"
		run fin ssh-key ls
		echo "$output" | egrep "SHA256:.+ id_.+"
		echo "$output" | egrep "4096 SHA256:.+ bats_rsa \(RSA\)"
		unset output

		# Checking "fin ssh-key add" with a key listed in docksal.env
		echo "SECRET_SSH_KEY_TEST=\"test_rsa\"" >> $HOME/.docksal/docksal.env
		run fin ssh-key add
		echo "$output" | egrep "Identity added: test_rsa"
		unset output
		# Cleanup
		sed -i~ '/SECRET_SSH_KEY_TEST/d' $HOME/.docksal/docksal.env
	else
		run fin ssh-key add
		# On a real host assuming there is at least one default key
		echo "$output" | egrep "Identity added: id_.+ \(id_.+\)"
		unset output

		# Checking fin ssh-key ls
		run fin ssh-key ls
		echo "$output" | egrep "SHA256:.+ id_.+"
		unset output
	fi

	# Checking "fin ssh-key add": key doesn't exist
	run fin ssh-key add doesnt_exist_rsa
	echo "$output" | egrep "Key '.*\/doesnt_exist_rsa' does not exist"
	unset output

	# Checking "fin ssh-key rm"
	run fin ssh-key rm
	echo "$output" | grep "All identities removed."
	unset output

	# Checking "fin ssh-key ls" (no keys)
	run fin ssh-key ls
	echo "$output" | grep "The agent has no identities."
	unset output

	# Check that the same key will not be added twice
	# This avoids re-prompting for a passphrase on a key, that's already present in the agent
	fin ssh-key add id_rsa
	run fin ssh-key add id_rsa
	echo "$output" | egrep "Key 'id_rsa' already loaded in the agent. Skipping."
	unset output
}

@test "DNS: .docksal name resolution inside cli" {
	[[ $SKIP == 1 ]] && skip

	cd ../drupal8 && fin up
	run fin exec nslookup anything.docksal
	[[ "$status" == 0 ]]
	unset output
}

@test "DNS: external name resolution inside cli" {
	[[ $SKIP == 1 ]] && skip

	cd ../drupal8 && fin up
	run fin exec nslookup google.com
	[[ "$status" == 0 ]]
	unset output
}
