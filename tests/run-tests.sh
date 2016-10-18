#!/bin/bash

# Switch to drupal7 folder.
cd ../../drupal7

OS="${OS:-mac}"
if [ ! -z "$1" ]; then
	OS="$1"
fi

# Run tests. Order is important.
echo "Test command: init"
OS=$OS bats ../docksal/tests/init.bats
echo "Test command: start"
OS=$OS bats ../docksal/tests/start.bats
echo "Test command: stop"
OS=$OS bats ../docksal/tests/stop.bats
echo "Test command: reset"
OS=$OS bats ../docksal/tests/reset.bats
echo "Test command: restart"
OS=$OS bats ../docksal/tests/restart.bats
echo "Test command: drush"
OS=$OS bats ../docksal/tests/drush.bats
echo "Test command: exec"
OS=$OS bats ../docksal/tests/exec.bats
echo "Test command: ssh-add"
OS=$OS bats ../docksal/tests/ssh-add.bats
echo "Test command: status"
OS=$OS bats ../docksal/tests/status.bats
echo "Test command: update"
OS=$OS bats ../docksal/tests/update.bats
echo "Test fin helper functions"
OS=$OS bats ../docksal/tests/helper_functions.bats
echo "Tests fin basics check functions"
OS=$OS bats ../docksal/tests/basics_check_functions.bats
echo "Tests fin control functions"
OS=$OS bats ../docksal/tests/control_functions.bats
