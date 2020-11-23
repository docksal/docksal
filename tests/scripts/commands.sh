#!/usr/bin/env bash

mkdir "$GITHUB_WORKSPACE/../test-commands"
cd mkdir "$GITHUB_WORKSPACE/../test-commands"
bats "$GITHUB_WORKSPACE/tests/commands.bats"
