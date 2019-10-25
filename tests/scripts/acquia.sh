#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_ACAPI_EMAIL=${SECRET_ACAPI_EMAIL}"
fin config set --global "SECRET_ACAPI_KEY=${SECRET_ACAPI_KEY}"
run_tests pull/${PROVIDER}.bats "$TRAVIS_BUILD_DIR/../test-pull"
