#!/usr/bin/env bash

mkdir "$TRAVIS_BUILD_DIR/../test-db"
cd "$TRAVIS_BUILD_DIR/../test-db"
bats "$TRAVIS_BUILD_DIR/tests/db.bats"
