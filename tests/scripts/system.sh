#!/usr/bin/env bash

set -euo pipefail

bats "$GITHUB_WORKSPACE/tests/system.bats"
