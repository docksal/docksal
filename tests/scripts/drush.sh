#!/usr/bin/env bash

fin ssh-key add project_key

mkdir "$TRAVIS_BUILD_DIR/../test-pull"
cd "$TRAVIS_BUILD_DIR/../test-pull"
bats "$TRAVIS_BUILD_DIR/tests/pull/drush.bats"
