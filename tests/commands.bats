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

@test "fin namespace/command (project)" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p .docksal/commands/namespace 2>/dev/null
	cat <<EOF > .docksal/commands/namespace/command
#!/usr/bin/env bash
echo "Test Command"
EOF
	chmod +x .docksal/commands/namespace/command

	run fin namespace/command
	[[ "${output}" == "Test Command" ]]
	unset output
}

@test "fin namespace/command (global)" {
	[[ $SKIP == 1 ]] && skip

	mkdir -p ~/.docksal/commands/team 2>/dev/null
	cat <<EOF > ~/.docksal/commands/team/command
#!/usr/bin/env bash
echo "Test Global Command"
EOF
	chmod +x ~/.docksal/commands/team/command

	run fin team/command
	[[ "${output}" == "Test Global Command" ]]
	unset output
}
