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

@test "fin init" {
	[[ $SKIP == 1 ]] && skip

	fin init
	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-list" {
	[[ $SKIP == 1 ]] && skip

	run fin mysql-list
	echo "$output" | grep "mysql"
}

@test "fin mysql-dump with no params" {
	[[ $SKIP == 1 ]] && skip

	# Create backup
	rm -f dump.sql
	run fin mysql-dump dump.sql
    echo "$output" | grep "Exporting..."

	# Check that we've got a valid dump
	run grep "Database: default" dump.sql
    [ $status -eq 0 ]
}

@test "fin mysql-dump with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Create backup
    rm -f dump.sql
	run fin mysql-dump dump.sql --db-user="user" --db-password="user"
    echo "$output" | grep "Exporting..."

	# Check that we've got a valid dump
	run grep "Database: default" dump.sql
    [ $status -eq 0 ]
}

@test "fin mysql-import with no params" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
    run fin mysql-import dump.sql --force
    echo "$output" | grep "Truncating 'default'"
    echo "$output" | grep "Importing"

	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-import with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="user" --db-password="user" --force
    echo "$output" | grep "Truncating 'default'"
    echo "$output" | grep "Importing"

	# Check that the site is available
	run curl -sL http://drupal8.docksal
	echo "$output" | grep "My Drupal 8 Site"
}

@test "fin mysql-import with the wrong user and password" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="wront-user" --db-password="wrong-password" --force
    echo "$output" | grep "Truncating 'default'"
    echo "$output" | grep "Importing"
    echo "$output" | grep "Import failed"
}

@test "fin mysql-import into different db" {
	[[ $SKIP == 1 ]] && skip

	# Import mysql dump
	run fin mysql-import dump.sql --db-user="user" --db-password="user" --db="nondefault" --force
	echo "$output" | grep "Truncating 'nondefault'"
	echo "$output" | grep "Importing"
	echo "$output" | grep "Import failed"
}
