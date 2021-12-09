#!/usr/bin/env bash

set -euo pipefail

mkdir "$GITHUB_WORKSPACE/../test-project"
cd "$GITHUB_WORKSPACE/../test-project"
mkdir .docksal
bats "$GITHUB_WORKSPACE/tests/project.bats"

mkdir "$GITHUB_WORKSPACE/../test-duplicates"
cd "$GITHUB_WORKSPACE/../test-duplicates"
bats "$GITHUB_WORKSPACE/tests/duplicates.bats"
