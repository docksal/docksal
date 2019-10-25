#!/usr/bin/env bash

source travis.sh
run_tests db.bats "$TRAVIS_BUILD_DIR/../test-db"
