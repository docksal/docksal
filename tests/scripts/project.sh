#!/usr/bin/env bash

mkdir "$TRAVIS_BUILD_DIR/../test-project"
cd "$TRAVIS_BUILD_DIR/../test-project"
bats "$TRAVIS_BUILD_DIR/tests/project.bats"

mkdir "$TRAVIS_BUILD_DIR/../test-duplicates"
cd "$TRAVIS_BUILD_DIR/../test-duplicates"
bats "$TRAVIS_BUILD_DIR/tests/duplicates.bats"
