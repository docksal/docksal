#!/usr/bin/env bash

set -euo pipefail

# Triggers builds for boilerplate-* repos when master branch is tested
# $1 - repo name, e.g. docksal/boilerplate-drupal7
build_trigger() {
	if [[ "$GITHUB_REF" == "refs/heads/master" ]]; then
		cd "$GITHUB_WORKSPACE"
		github-build-trigger "$1"
	fi
}

build_trigger docksal/boilerplate-drupal7
build_trigger docksal/boilerplate-drupal7-advanced
build_trigger docksal/boilerplate-drupal8
build_trigger docksal/boilerplate-wordpress
build_trigger docksal/boilerplate-magento
build_trigger docksal/boilerplate-magento-demo
