#!/usr/bin/env bash

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
	# develop => edge
	[[ "${TRAVIS_BRANCH}" == "develop" ]] && TAG="edge"
	# master => latest
	[[ "${TRAVIS_BRANCH}" == "master" ]] && TAG="latest"
	# tags/v1.2.0 => 1.2
	[[ "${TRAVIS_TAG}" != "" ]] && TAG="${TRAVIS_TAG:1:3}"

	if [[ "$TAG" != "" ]]; then
		docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}"
		docker tag ${REPO}:dev ${REPO}:${TAG}
		docker push ${REPO}:${TAG}
	fi;
fi;
