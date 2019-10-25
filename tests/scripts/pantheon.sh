#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_TERMINUS_TOKEN=${SECRET_TERMINUS_TOKEN}"

mkdir "$TRAVIS_BUILD_DIR/../test-pull"
cd "$TRAVIS_BUILD_DIR/../test-pull"
bats "$TRAVIS_BUILD_DIR/tests/pull/pantheon.bats"
