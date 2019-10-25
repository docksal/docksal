#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_ACAPI_EMAIL=${SECRET_ACAPI_EMAIL}"
fin config set --global "SECRET_ACAPI_KEY=${SECRET_ACAPI_KEY}"

mkdir "$TRAVIS_BUILD_DIR/../test-pull"
cd "$TRAVIS_BUILD_DIR/../test-pull"
bats "$TRAVIS_BUILD_DIR/tests/pull/acquia.bats"
