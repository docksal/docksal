#!/usr/bin/env bash

set -euo pipefail

# Use it to debug tests that are failing for mysterious reasons.
# Uncomment quicktest provider in the travis.yml, and push.
# Once build starts, manually cancel other provider jobs in Travis UI to avoid waiting for them

# Runs bats interactively for full output
bats -i "$GITHUB_WORKSPACE/tests/quicktest.bats"
