#!/usr/bin/env bash

set -euo pipefail

fin ssh-key add project_key
fin config set --global "SECRET_PLATFORMSH_CLI_TOKEN=${SECRET_PLATFORMSH_CLI_TOKEN}"

mkdir "$GITHUB_WORKSPACE/../test-pull"
cd "$GITHUB_WORKSPACE/../test-pull"
bats "$GITHUB_WORKSPACE/tests/pull/platform.bats"
