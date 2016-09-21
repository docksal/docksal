#!/bin/bash

# Switch to drude-d7-testing folder.
cd ../../drude-d7-testing

OS="${OS:-mac}"
if [ ! -z "$1" ]; then
	OS="$1"
fi

# Run tests. Order is important.
echo "Test command: start"
OS=$OS bats ../drude/tests/start.bats
echo "Test command: init"
OS=$OS bats ../drude/tests/init.bats
echo "Test command: stop"
OS=$OS bats ../drude/tests/stop.bats
echo "Test command: reset"
OS=$OS bats ../drude/tests/reset.bats
echo "Test command: restart"
OS=$OS bats ../drude/tests/restart.bats
echo "Test command: drush"
OS=$OS bats ../drude/tests/drush.bats
echo "Test command: exec"
OS=$OS bats ../drude/tests/exec.bats
echo "Test command: ssh-add"
OS=$OS bats ../drude/tests/ssh-add.bats
echo "Test command: status"
OS=$OS bats ../drude/tests/status.bats
echo "Test command: update"
OS=$OS bats ../drude/tests/update.bats
echo "Test dsh helper functions"
OS=$OS bats ../drude/tests/helper_functions.bats
echo "Tests dsh basics check functions"
OS=$OS bats ../drude/tests/basics_check_functions.bats
echo "Tests dsh control functions"
OS=$OS bats ../drude/tests/control_functions.bats