#!/usr/bin/env bash

fin ssh-key add project_key
fin config set --global "SECRET_ACAPI_EMAIL=${SECRET_ACAPI_EMAIL}"
fin config set --global "SECRET_ACAPI_KEY=${SECRET_ACAPI_KEY}"

mkdir "$GITHUB_WORKSPACE/../test-pull"
cd "$GITHUB_WORKSPACE/../test-pull"
bats "$GITHUB_WORKSPACE/tests/pull/acquia.bats"
