#!/usr/bin/env bash

source travis.sh
run_tests config.bats "$TRAVIS_BUILD_DIR/../test-config"
