#!/usr/bin/env bash

set -euo pipefail

fin ssh-key add project_key
fin config set --global "SECRET_ACQUIA_CLI_SECRET=${SECRET_ACQUIA_CLI_SECRET}"
fin config set --global "SECRET_ACQUIA_CLI_KEY=${SECRET_ACQUIA_CLI_KEY}"

mkdir "$GITHUB_WORKSPACE/../test-pull"
cd "$GITHUB_WORKSPACE/../test-pull"
bats "$GITHUB_WORKSPACE/tests/pull/acquia.bats"
