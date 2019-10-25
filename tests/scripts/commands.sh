#!/usr/bin/env bash

mkdir "$TRAVIS_BUILD_DIR/../test-commands"
cd mkdir "$TRAVIS_BUILD_DIR/../test-commands"
bats "$TRAVIS_BUILD_DIR/tests/commands.bats"
