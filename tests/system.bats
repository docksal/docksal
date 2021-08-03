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
SERVICE_VHOST_PROXY_VERSION=${SERVICE_VHOST_PROXY_VERSION:-1.7}
SERVICE_DNS_VERSION=${SERVICE_DNS_VERSION:-1.1}
SERVICE_SSH_AGENT_VERSION=${SERVICE_SSH_AGENT_VERSION:-1.3}
DOCKSAL_IP=${DOCKSAL_IP:-192.168.64.100}
DOCKSAL_DNS_DOMAIN=${DOCKSAL_DNS_DOMAIN:-docksal}

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

# Add default sample keys on Travis only. We don't want to mess with a real host ssh key.
[[ "$GITHUB_RUN_ID" != "" ]] && cp tests/ssh-keys/* ~/.ssh

@test "IP: ($DOCKSAL_IP) is reachable" {
	[[ $SKIP == 1 ]] && skip

	# Check DOCKSAL_IP is up
	run ping -c 1 -W 1 ${DOCKSAL_IP}
	[[ "$status" == 0 ]]
	unset output
}

@test "DNS: fin system reset dns" {
	[[ ${SKIP} == 1 ]] && skip
	[[ ${DOCKSAL_DNS_DISABLED} == 1 ]] && skip

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
	[[ ${DOCKSAL_DNS_DISABLED} == 1 ]] && skip

	# .docksal domain resolution via ping
	run ping -c 1 -W 1 anything.docksal
	[[ "$(echo \"$output\" | awk -F'[()]' '/PING/{print $2}')" == "$DOCKSAL_IP" ]]
	unset output
}

@test "DSN: .docksal name resolution via nslookup" {
	[[ $SKIP == 1 ]] && skip
	[[ ${DOCKSAL_DNS_DISABLED} == 1 ]] && skip

	# .docksal domain resolution via nslookup
	# Unfortunately, nslookup does not reliably resolve .docksal.
	# This test is only verifying that docksal-dns replies to direct nslookup requests.
	run nslookup anything.docksal ${DOCKSAL_IP}
	[[ "$status" == 0 ]]
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
	# Start an nginx container with a given virtual host assigned
	vhost="nginx.${DOCKSAL_DNS_DOMAIN}"
	fin docker run -d --name bats-nginx --label "io.docksal.virtual-host=${vhost}" -e "VIRTUAL_HOST=${vhost}" nginx:alpine && sleep 2
	# Actual Test
	run curl -sL http://${vhost}
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
	echo "$output" | egrep "Identity added: id_.+ \(.+\)"
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
	if [[ "$GITHUB_RUN_ID" != "" ]]; then
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
		echo "$output" | egrep "Identity added: id_.+ \(.+\)"
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

	# Checking "fin ssh-key new"
	# Run non-interactively to skip configuration prompts
	run bash -c 'echo "fin ssh-key new myserver_id_rsa" | bash'
	# Check new key files exist and are valid SSH keys
	ssh-keygen -lf ~/.ssh/myserver_id_rsa
	ssh-keygen -lf ~/.ssh/myserver_id_rsa.pub
	# Check public key was printed in the output
	[[ "$output" == *"$(cat ~/.ssh/myserver_id_rsa.pub)"* ]]
	unset output
}

@test "DNS: .docksal name resolution inside cli" {
	[[ $SKIP == 1 ]] && skip
	[[ ${DOCKSAL_DNS_DISABLED} == 1 ]] && skip

	# .docksal domain resolution via nslookup
	# Unfortunately, nslookup does not reliably resolve .docksal.
	# This test is only verifying that docksal-dns replies to direct nslookup requests.
	run fin rc nslookup anything.docksal ${DOCKSAL_IP}
	[[ "$status" == 0 ]]
	unset output
}

@test "DNS: external name resolution inside cli" {
	[[ $SKIP == 1 ]] && skip

	run fin rc nslookup google.com
	[[ "$status" == 0 ]]
	unset output
}

@test "fin run-cli" {
	[[ $SKIP == 1 ]] && skip

	# Dummy command to pre-pull the image run-cli is using.
	fin rc uname

	# Test output in TTY vs no-TTY mode.
	# TODO: Revise as this is failing in Github Actions. Disabled for now.
	#[[ "$(fin rc echo)" != "$(fin rc -T echo)" ]]

	# fin rc uses the docker user
	run fin rc -T id -un
	[[ "$output" == "docker" ]]
	unset output

	# docker user uid/gid in cli matches the host user uid/gid
	run fin rc -T 'echo $(id -u):$(id -g)'
	[[ "$output" == "$(id -u):$(id -g)" ]]
	unset output

	# check to make sure custom variables are passed into container
	run fin rc -T -e TEST_VAR="TEST VARIABLES" "echo \$TEST_VAR"
	[[ "$output" == "TEST VARIABLES" ]]
	unset output

	# check to make sure a global default variable (from $HOME/.docksal/docksal.env) is passed automatically.
	# These are SECRET_ and some other variables passed by default.
	# Note: SECRET_SSH_PRIVATE_KEY must be a valid base64 encoded string
	echo "SECRET_SSH_PRIVATE_KEY=\"$(echo 'xyz' | base64)\"" >> $HOME/.docksal/docksal.env
	run fin rc -T "echo \$SECRET_SSH_PRIVATE_KEY | base64 -d"
	[[ "$output" == "xyz" ]]
	unset output

	# Check to make sure a global default variable can be overridden
	# Note: SECRET_SSH_PRIVATE_KEY must be a valid base64 encoded string
	run fin rc -T -e SECRET_SSH_PRIVATE_KEY="$(echo 'abc' | base64)" "echo \$SECRET_SSH_PRIVATE_KEY | base64 -d"
	[[ "$output" == "abc" ]]
	unset output

	# check to make sure a global (non-default) variable can be passed if included in command
	echo "TEST=1234" >> $HOME/.docksal/docksal.env
	run fin rc -T -e TEST "echo \$TEST"
	[[ "$output" == "1234" ]]
	unset output

	# Check persistent volume
	fin rc touch /home/docker/test
	run fin rc -T ls /home/docker/test
	[[ "$output" == "/home/docker/test" ]]
	unset output

	# Check one-off volume --clean
	fin rc touch /home/docker/test
	run fin rc --clean -T ls /home/docker/test
	[[ "$output" == "ls: cannot access '/home/docker/test': No such file or directory" ]]
	unset output

	# Check --cleanup persistent volume
	fin rc touch /home/docker/test
	run fin rc --cleanup -T ls /home/docker/test
	[[ "$output" == "ls: cannot access '/home/docker/test': No such file or directory" ]]
	unset output
}
