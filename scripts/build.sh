#!/bin/bash

# Drude build script.
# Builds drude and pushes to the "build" branch at the origin.

GIT_URL=$(git config --get remote.origin.url)
VERSION_FILE="VERSION"
VERSION_TAG="v$(cat $VERSION_FILE)"

rm -rf build
git clone -b build $GIT_URL build && cd build

# VERSION file change detection first
cp -f "../$VERSION_FILE" .docker
VERSION_CHANGE=0
if [[ !  -z  $(git status .docker/$VERSION_FILE|grep modified) ]]; then
	VERSION_CHANGE=1
fi

# We want to restart from master here
git checkout -f master
git branch -d build && git checkout -b build

# Remove everything
git rm -r *
git rm -r .docker
git rm .gitignore

# Copy only the following
cp -fR "../.docker" .
cp -f "../docker-compose.yml" .
cp -f "../README.md" .docker && sed -i '' 's/(\.docker\/docs/(docs/g' .docker/README.md
cp -f "../CHANGELOG.md" .docker
cp -f "../$VERSION_FILE" .docker

# Add, commit and push
git add -A
git commit -m "Build"
git push origin build --force

# Push release tag
if [[ $VERSION_CHANGE == 1 ]]; then
	echo "New release $VERSION_TAG detected"
	git tag $VERSION_TAG
	git push origin $VERSION_TAG
fi
