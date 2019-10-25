#!/usr/bin/env bash

mkdir "$TRAVIS_BUILD_DIR/../test-config"
cd "$TRAVIS_BUILD_DIR/../test-config"
bats "$TRAVIS_BUILD_DIR/tests/config.bats"
