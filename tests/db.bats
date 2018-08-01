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

@test "Prepare project after general.bats" {
	fin config rm --env=local VIRTUAL_HOST
	fin project start
}

@test "fin db list" {
	[[ $SKIP == 1 ]] && skip

	run fin db list
	echo "$output" | grep "default"
	unset output
}

@test "fin db drop and recreate default" {
	[[ $SKIP == 1 ]] && skip

	dbname="default"
	run fin db drop "$dbname"
	echo "$output" | grep "Database '${dbname}' dropped"
	unset output

	run fin db create "$dbname"
	echo "$output" | grep "Database '${dbname}' created"
	unset output

	run fin db list
	echo "$output" | grep "$dbname"
	unset output
}

@test "fin db drop and create nondefault" {
	[[ $SKIP == 1 ]] && skip

	dbname="nondefault"
	fin db drop "$dbname" || true  # start clean
	run fin db drop "$dbname"
	echo "$output" | grep "Database '${dbname}' dropped"
	unset output

	run fin db create "$dbname"
	echo "$output" | grep "Database '${dbname}' created"
	unset output

	run fin db list
	echo "$output" | grep "$dbname"
	unset output
}

# Cannot do cleanup outside of a test case as bats will evaluate/run that code before every single test case.
@test "Initializing a Drupal 8 site" {
	[[ $SKIP == 1 ]] && skip

	fin init
	return 0
}

@test "fin db dump with no params" {
	[[ $SKIP == 1 ]] && skip

	# Create backup
	rm -f dump.sql
	run fin db dump dump.sql
	echo "$output" | grep "Exporting..."
	unset output

	# Check that we've got a valid dump
	grep "Database: default" dump.sql
}

@test "fin db import with no params" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin db import dump.sql --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	unset output
}

@test "fin db import with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin db import dump.sql --db-user="user" --db-password="user" --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	unset output
}

@test "fin db import with the wrong user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin db import dump.sql --db-user="wrong-user" --db-password="wrong-password" --force
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Import failed"
	unset output
}

@test "fin db import from stdin" {
	#[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	# TODO: remove stderr redirection here after cli image is fixed to not throw error "mesg: ttyname failed: Inappropriate ioctl for device"
	run cat dump.sql | fin db import 2>/dev/null
	echo "$output" | grep "Truncating"
	echo "$output" | grep "Importing from stdin"
	echo "$output" | grep "Done"
	unset output

	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
	unset output
}

@test "fin db import into nonexisting db" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	dbname="nonexisting"
	run fin db import dump.sql --db-user="user" --db-password="user" --db="$dbname" --force
	echo "$output" | grep "Truncating" | grep "$dbname"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Import failed"
	unset output
}

@test "fin db create 'nondefault' db" {
	[[ $SKIP == 1 ]] && skip

	dbname="nondefault"
	fin db drop "$dbname" || true  # cleanup just in case
	run fin db create "$dbname"
	echo "$output" | grep "Database '${dbname}' created"
	unset output

	run fin db list
	echo "$output" | grep "$dbname"
	unset output
}

@test "fin db import into 'nondefault' db" {
	#[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	dbname="nondefault"
	run fin db import dump.sql --db-user="user" --db-password="user" --db="$dbname" --force
	echo "$output" | grep "Truncating" | grep "$dbname"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Done"
	unset output
}
