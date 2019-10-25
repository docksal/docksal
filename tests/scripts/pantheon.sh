#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_TERMINUS_TOKEN=${SECRET_TERMINUS_TOKEN}"
run_tests pull/${PROVIDER}.bats "$TRAVIS_BUILD_DIR/../test-pull"
