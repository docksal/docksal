#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_PLATFORMSH_CLI_TOKEN=${SECRET_PLATFORMSH_CLI_TOKEN}"

mkdir "$TRAVIS_BUILD_DIR/../test-pull"
cd "$TRAVIS_BUILD_DIR/../test-pull"
bats "$TRAVIS_BUILD_DIR/tests/pull/platform.bats"
