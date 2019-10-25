#!/usr/bin/env bash

# Use it to debug tests that are failing for mysterious reasons.
# Uncomment quicktest provider in the travis.yml, and push.
# Once build starts, manually cancel other provider jobs in Travis UI to avoid waitisng for them

# Runs bats interactively for full output
bats -i "$TRAVIS_BUILD_DIR/tests/quicktest.bats"
