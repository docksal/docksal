#!/usr/bin/env bash

source travis.sh
git clone https://github.com/docksal/drupal8.git ../drupal8
mkdir -p ../test-duplicates ../test-init
run_tests quicktest.bats
run_tests general.bats "$TRAVIS_BUILD_DIR/../drupal8"
run_tests duplicates.bats "$TRAVIS_BUILD_DIR/../test-duplicates"
