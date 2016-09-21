#!/usr/bin/env bats

load dsh_script

true_if_failed() {
	true
	if_failed
}

@test "Checking if_failed function. Text #1" {
	run true_if_failed

	[ $status -eq 0 ]
}

not_true_if_failed() {
	! true
	if_failed
}

@test "Checking if_failed function. Text #2" {
	run not_true_if_failed

	[ $status -eq 1 ]
}

@test "Checking upfind function. Text #1" {
	run upfind $(pwd)/docroot/sites

	[ $status -eq 0 ]
	[ $output = $(pwd) ]
}

@test "Checking upfind function. Text #2" {
	run upfind $(pwd)/dir_not_exists

	[ $status -eq 0 ]
	[ "$output" = "" ]
}

@test "Checking upfind function. Text #3" {
	run upfind ""

	[ $status -eq 1 ]
}

@test "Checking get_yml_path function" {
	run get_yml_path
	echo $output

	[ $status -eq 0 ]
	[ $output = "$(pwd)" ]
}

@test "Checking get_drude_path function" {
	run get_drude_path

	[ $status -eq 0 ]
	[ $output = $(pwd) ]
}

@test "Checking get_abs_path function" {
	run get_abs_path ./docroot/sites

	[ $status -eq 0 ]
	[ "$output" = "$(pwd)/docroot/sites" ]
}

@test "Checking get_current_relative_path function. Case#1: Inside docroot folder condition" {
	cd docroot/sites/all
	run get_current_relative_path

	# <debug section>
	echo "+=============================================================="
	local proj_root=$(get_yml_path)
	echo "+ Project root: $proj_root"
	local cwd=$(pwd)
	echo "+ Current directory: $cwd"
	local pathdiff=${cwd#$proj_root/}
	echo "+ Path diff: $pathdiff"
	# </debug section>

	[ $status -eq 0 ]
	[ "$output" = "docroot/sites/all" ]
}

# @todo check this function
@test "Checking get_current_relative_path function. Case#2: Outside docroot folder condition" {
	run get_current_relative_path

	# <debug section>
	echo "+=============================================================="
	local proj_root=$(get_yml_path)
	echo "+ Project root: $proj_root"
	local cwd=$(pwd)
	echo "+ Current directory: $cwd"
	local pathdiff=${cwd#$proj_root/}
	echo "+ Path diff: $pathdiff"
	# </debug section>

	[ $status -eq 0 ]
	[ "$output" = "$cwd" ]
}

@test "Checking clean_string function." {
	local string="Abc-123/"
	run clean_string $string

	# <debug section>
	local cleaned=$(echo "$string" | sed -e 's/[^a-zA-Z0-9_-]$//')
	echo ${cleaned}
	echo "+=============================================================="
	echo "+ Input string: $string"
	# </debug section>

	[ $status -eq 0 ]
	[ "$output" = "Abc-123" ]
}

@test "Checking get_mysql_connect function. Case#1: Outside of docroot" {
	run get_mysql_connect

	# <debug section>
	echo "==============================================================="
	echo "Output of sql-connect with disabled TTY: $(DRUDE_IS_TTY=0 _run drush sql-connect)"
	# </debug section>

	[ $status -eq 0 ]
	[ "${lines[8]}" = "#1 [internal function]: drush_sql_connect()" ]
}

@test "Checking get_mysql_connect function. Case#2: Inside of docroot" {
	cd docroot/sites
	run get_mysql_connect

	# <debug section>
	echo "==============================================================="
	echo "Output of sql-connect with disabled TTY: $(DRUDE_IS_TTY=0 _run drush sql-connect)"
	echo "==============================================================="
	# </debug section>

	[ $status -eq 0 ]
	[[ "$output" =~ "mysql --user=drupal --password=123 --database=drupal --host" ]]
}

@test "Checking docker_compose function. Case#1: Call without specified command" {
	run docker_compose

	# <debug section>
	cwd=$(pwd)
	echo "+=============================================================="
	echo "+ Current path: $cwd"
	cd $(get_yml_path)
	echo "+ Yml path directory: $(pwd)"
	# </debug section>

	[ $status -eq 1 ]
	[ "${lines[0]}" = "Define and run multi-container applications with Docker." ]
}

@test "Checking docker_compose function. Case#2: Call with specified command" {
	run docker_compose version

	# <debug section>
	cwd=$(pwd)
	echo "+=============================================================="
	echo "+ Current path: $cwd"
	cd $(get_yml_path)
	echo "+ Yml path directory: $(pwd)"
	# </debug section>

	[ $status -eq 0 ]
}

@test "Checking get_container_id function. Case#1: cli" {
	run get_container_id 'cli'

	# <debug section>
	echo "==============================================================="
	echo "Docker compose output: "
	compose_output=$(docker-compose ps -q cli | tr -d '\r')
	echo $compose_output
	# </debug section>

	[ $status -eq 0 ]
	[ "$output" = $compose_output ]
}

@test "Checking get_container_id function. Case#2: web" {
	run get_container_id 'web'

	# <debug section>
	echo "==============================================================="
	echo "Docker compose output: "
	compose_output=$(docker-compose ps -q web | tr -d '\r')
	echo $compose_output
	# </debug section>

	[ $status -eq 0 ]
	[ "$output" = $compose_output ]
}