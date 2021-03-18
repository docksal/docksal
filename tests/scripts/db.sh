#!/usr/bin/env bash

set -euo pipefail

mkdir "$GITHUB_WORKSPACE/../test-db"
cd "$GITHUB_WORKSPACE/../test-db"
bats "$GITHUB_WORKSPACE/tests/db.bats"
