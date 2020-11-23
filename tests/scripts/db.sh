#!/usr/bin/env bash

mkdir "$GITHUB_WORKSPACE/../test-db"
cd "$GITHUB_WORKSPACE/../test-db"
bats "$GITHUB_WORKSPACE/tests/db.bats"
