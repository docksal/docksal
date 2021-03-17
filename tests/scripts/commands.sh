#!/usr/bin/env bash

set -euo pipefail

mkdir "$GITHUB_WORKSPACE/../test-commands"
cd mkdir "$GITHUB_WORKSPACE/../test-commands"
bats "$GITHUB_WORKSPACE/tests/commands.bats"
