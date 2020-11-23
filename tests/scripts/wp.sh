#!/usr/bin/env bash

fin ssh-key add project_key

mkdir "$GITHUB_WORKSPACE/../test-pull"
cd "$GITHUB_WORKSPACE/../test-pull"
bats "$GITHUB_WORKSPACE/tests/pull/wp.bats"
