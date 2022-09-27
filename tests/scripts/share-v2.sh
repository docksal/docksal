#!/usr/bin/env bash

set -euo pipefail

mkdir "$GITHUB_WORKSPACE/../test-share-v2"
cd "$GITHUB_WORKSPACE/../test-share-v2"
mkdir .docksal
bats "$GITHUB_WORKSPACE/tests/share-v2.bats"
