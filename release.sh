#!/bin/bash

# Drude release script.
# Pushes a release to the "release" branch on github whenever the VERSION number is changed.

GIT_URL=$(git config --get remote.origin.url)
VERSION_FILE="VERSION"
VERSION_TAG="v$(cat $VERSION_FILE)"

rm -rf release
git clone $GIT_URL release && cd release && git checkout release

# Copy the VERSION file first to detect any version changes
cp -f ../$VERSION_FILE .docker
if [[ !  -z  $(git status .docker/$VERSION_FILE|grep modified) ]]; then

	# TODO: replace with something more sophisticated
	git reset --hard
	git rm *
	git rm .gitignore
	
	cp -fR ../.docker .
	cp -f ../docker-compose.yml .
	cp -f ../README.md .docker && sed -i '' 's/(\.docker\/docs/(docs/g' .docker/README.md
	cp -f ../$VERSION_FILE .docker

	# Commit and push the new release
	echo "New release $VERSION_TAG detected"
	git add -A
	git commit -m "Release $VERSION_TAG"
	git push origin release
	git tag $VERSION_TAG
	git push origin $VERSION_TAG
fi
