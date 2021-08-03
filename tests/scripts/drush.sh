#!/usr/bin/env bash

set -euo pipefail

fin ssh-key add project_key

mkdir "$GITHUB_WORKSPACE/../test-pull"
cd "$GITHUB_WORKSPACE/../test-pull"
bats "$GITHUB_WORKSPACE/tests/pull/drush.bats"
