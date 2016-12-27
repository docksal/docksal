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
DOCKSAL_IP=192.168.64.100

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

# Add default sample keys on Travis only. We don't want to mess with a real host ssh key.
[[ "$TRAVIS" == "true" ]] && cp tests/ssh-keys/* ~/.ssh

@test "fin mysql-list" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	run fin mysql-list

	echo "$output" | grep "mysql"

	cd ..
}


@test "fin mysql-dump with no params" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Create backup
	run fin mysql-dump ../dump.sql

	echo "$output" | grep "Exporting..."
	echo "$output" | grep "OK"

	cd ..
}

@test "fin mysql-import with user and password" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-dump ../dump.sql --db-user="user" --db-password="user"
	echo "$output" | grep "Exporting..."
	echo "$output" | grep "OK"

	# Check if site is available and it's name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"

	cd ..
}


@test "fin mysql-import with no params" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-import ../dump.sql --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	echo "$output" | grep "OK"

	# Check if site is available and it's name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"

	cd ..
}

@test "fin mysql-import with user and password" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-import ../dump.sql --db-user="user" --db-password="user" --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	echo "$output" | grep "OK"

	# Check if site is available and it's name is correct
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"

	cd ..
}

@test "fin mysql-import into different db" {
	[[ $SKIP == 1 ]] && skip

	cd docroot

	# Import mysql dump
	run fin mysql-import ../dump.sql --db-user="user" --db-password="user" --db="nondefault" --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Unknown database 'nondefault'"

	cd ..
}