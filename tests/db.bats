#!/usr/bin/env bats

# Debugging
teardown ()
{
	# TODO: figure out why $status is always 0 here
	#echo "Status: $status"
	# Print output from the last failed test
	echo "Output:"
	echo "================================================================"
	for line in "${lines[@]}"; do
		echo "$line"
	done
	echo "================================================================"
}

# To work on a specific test:
# run `export SKIP=1` locally, then comment skip in the test you want to debug

# Set dumb terminal so fin does not output colors
TERM=dumb

# This step is required
@test "Start test-db project" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p .docksal
	fin project reset -f
	sleep 5

	run fin project list
	[[ "$output" == *"test-db"* ]]
	unset output
}

@test "fin db list" {
	[[ $SKIP == 1 ]] && skip

	dbname="default"

	run fin db list
	[[ "$output" == *"${dbname}"* ]]
	unset output
}

@test "fin db cli with query" {
	[[ $SKIP == 1 ]] && skip

	run fin db cli 'show databases like "mysql";'
	[[ "$output" == *"mysql"* ]]
	unset output
}

@test "fin db create without tty" {
	[[ $SKIP == 1 ]] && skip

	dbname="testnotty"
	echo "fin db create ${dbname}" | bash

	# Cleanup
	run fin db drop "${dbname}"
}

@test "fin db drop and recreate default" {
	[[ $SKIP == 1 ]] && skip

	dbname="default"
	run fin db drop "$dbname"
	[[ "$output" == *"Database ${dbname} dropped"* ]]
	unset output

	# TODO: fix this in fin
	# Running drop second time should fail
#	run fin db drop "$dbname"
#	echo "$output" | grep "Dropping '${dbname}' database failed"
#	[[ ${status} != 0 ]]
#	unset output

	# Check the db does not exist
	run fin db list
	[[ "$output" != *"${dbname}"* ]]
	unset output

	run fin db create "$dbname"
	[[ "$output" == *"Database ${dbname} created"* ]]
	unset output

	# TODO: fix this in fin
	# Running create second time should fail
#	run fin db create "$dbname"
#	echo "$output" | grep "Database '${dbname}' creation failed"
#	[[ ${status} != 0 ]]
#	unset output

	run fin db list
	[[ "$output" == *"${dbname}"* ]]
	unset output
}

@test "fin db drop and create 'nondefault' database" {
	[[ $SKIP == 1 ]] && skip

	dbname="nondefault"
	fin db drop "$dbname" || true  # start clean

	# Check the db does not exist
	run fin db list
	[[ "$output" != *"${dbname}"* ]]
	unset output

	run fin db create "$dbname"
	[[ "$output" == *"Database ${dbname} created"* ]]
	unset output

	run fin db list
	[[ "$output" == *"${dbname}"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Cleanup
	fin db drop "$dbname"
}

@test "fin db truncate" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	fin db cli 'CREATE TABLE IF NOT EXISTS test_table (id INT(11) NOT NULL AUTO_INCREMENT, PRIMARY KEY (id));'

	run fin db cli 'SHOW TABLES;'
	[[ "$output" == *"test_table"* ]]
	unset output

	run fin db truncate ${dbname}
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check the test_table is gone
	run fin db cli 'SHOW TABLES;'
	[[ "$output" != *"test_table"* ]]
	unset output
}

@test "fin db dump with no params" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbdump="dump.sql"

	# Setup: create a dummy table for testing purposes
	fin db cli 'CREATE TABLE IF NOT EXISTS test_table (id INT(11) NOT NULL AUTO_INCREMENT, PRIMARY KEY (id));'
	rm -f ${dbdump} || true

	# Create a backup
	run fin db dump ${dbdump}
	[[ "$output" == *"Exporting"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check that we've got a valid dump
	grep "test_table" ${dbdump}
}

@test "fin db import with no params" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	dbdump="dump.sql"
	fin db truncate ${dbname}

	# Import a db dump
	run fin db import ${dbdump} --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check the test_table is present
	run fin db cli 'SHOW TABLES;'
	[[ "$output" == *"test_table"* ]]
	unset output
}

@test "fin db import with user and password" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	dbdump="dump.sql"
	fin db truncate ${dbname}

	# Import mysql dump
	run fin db import ${dbdump} --db-user="user" --db-password="user" --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check the test_table is present
	run fin db cli 'SHOW TABLES;'
	[[ "$output" == *"test_table"* ]]
	unset output
}

@test "fin db import with the wrong user and password" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	dbdump="dump.sql"
	fin db truncate ${dbname}

	# Import mysql dump
	run fin db import ${dbdump} --db-user="wrong-user" --db-password="wrong-password" --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ "$output" == *"Import failed"* ]]
	[[ ${status} != 0 ]]
	unset output
}

@test "fin db import from stdin" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	dbdump="dump.sql"
	fin db truncate ${dbname}

	# Use "bash -c" here since there is a pipe
	run bash -c "cat ${dbdump} | fin db import"
	[[ "$output" == *"Importing from stdin"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check the test_table is present
	run fin db cli 'SHOW TABLES;'
	[[ "$output" == *"test_table"* ]]
	unset output
}

@test "fin db import a broken dump" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="default"
	dbdump="broken.sql"
	fin db truncate ${dbname}
	rm -f ${dbdump} || true
	echo "dummy" > ${dbdump}

	# Import a broken dump
	run fin db import ${dbdump} --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ "$output" == *"Import failed"* ]]
	[[ ${status} != 0 ]]
	unset output
}

@test "fin db import into 'nonexisting' database" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="nonexisting"
	dbdump="dump.sql"

	# Import mysql dump
	run fin db import "${dbdump}" --db-user="user" --db-password="user" --db="${dbname}" --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ "$output" == *"Import failed"* ]]
	[[ ${status} != 0 ]]
	unset output
}

@test "fin db import into 'nondefault' database" {
	[[ $SKIP == 1 ]] && skip

	# Setup
	dbname="nondefault"
	dbdump="dump.sql"
	fin db drop ${dbname} || true
	fin db create ${dbname}

	# Import mysql dump
	run fin db import ${dbdump} --db-user="user" --db-password="user" --db="${dbname}" --force
	[[ "$output" == *"Truncating ${dbname} database"* ]]
	[[ "$output" == *"Importing ${dbdump}"* ]]
	[[ ${status} == 0 ]]
	unset output

	# Check the test_table is present
	run fin db cli --db=${dbname} 'SHOW TABLES;'
	[[ "$output" == *"test_table"* ]]
	unset output
}
