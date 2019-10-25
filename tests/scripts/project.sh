#!/usr/bin/env bash

git clone https://github.com/docksal/drupal8.git "$TRAVIS_BUILD_DIR/../drupal8"
cd "$TRAVIS_BUILD_DIR/../drupal8"
bats "$TRAVIS_BUILD_DIR/tests/project.bats"

mkdir "$TRAVIS_BUILD_DIR/../test-duplicates"
cd "$TRAVIS_BUILD_DIR/../test-duplicates"
bats "$TRAVIS_BUILD_DIR/tests/duplicates.bats"
