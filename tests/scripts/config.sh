#!/usr/bin/env bash

set -euo pipefail

mkdir "$GITHUB_WORKSPACE/../test-config"
cd "$GITHUB_WORKSPACE/../test-config"
bats "$GITHUB_WORKSPACE/tests/config.bats"
